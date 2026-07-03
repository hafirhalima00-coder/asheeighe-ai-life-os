import { SupabaseClient } from '@supabase/supabase-js';

export interface ReferralCode {
  id: string;
  userId: string;
  code: string;
  createdAt: Date;
  isActive: boolean;
}

export interface Referral {
  id: string;
  referrerId: string;
  refereeId: string;
  code: string;
  status: ReferralStatus;
  reward: ReferralReward | null;
  createdAt: Date;
  completedAt: Date | null;
}

export type ReferralStatus = 'pending' | 'completed' | 'rewarded';

export interface ReferralReward {
  type: 'pro_week' | 'pro_month' | 'lifetime_pro' | 'credits';
  value: number;
  description: string;
}

export interface ReferralStats {
  totalReferrals: number;
  completedReferrals: number;
  pendingReferrals: number;
  rewardsEarned: ReferralReward[];
  nextMilestone: ReferralMilestone | null;
  progressToNextMilestone: number;
}

export interface ReferralMilestone {
  requiredReferrals: number;
  reward: ReferralReward;
  title: string;
  description: string;
}

export const REFERRAL_MILESTONES: ReferralMilestone[] = [
  {
    requiredReferrals: 1,
    reward: { type: 'pro_week', value: 7, description: '1 week of Pro free' },
    title: 'First Friend',
    description: 'Invite your first friend',
  },
  {
    requiredReferrals: 3,
    reward: { type: 'pro_week', value: 14, description: '2 weeks of Pro free' },
    title: 'Growing Circle',
    description: 'Invite 3 friends',
  },
  {
    requiredReferrals: 5,
    reward: { type: 'pro_month', value: 1, description: '1 month of Pro free' },
    title: 'Popular Host',
    description: 'Invite 5 friends',
  },
  {
    requiredReferrals: 10,
    reward: { type: 'pro_month', value: 3, description: '3 months of Pro free' },
    title: 'Influencer',
    description: 'Invite 10 friends',
  },
  {
    requiredReferrals: 25,
    reward: { type: 'lifetime_pro', value: 1, description: 'Lifetime Pro access' },
    title: 'PINKZ Ambassador',
    description: 'Invite 25 friends',
  },
];

export class ReferralService {
  constructor(private supabase: SupabaseClient) {}

  async generateReferralCode(userId: string): Promise<ReferralCode> {
    // Check if user already has a code
    const existing = await this.getUserReferralCode(userId);
    if (existing) return existing;

    const code = this.generateUniqueCode();

    const { data, error } = await this.supabase
      .from('referral_codes')
      .insert({
        user_id: userId,
        code,
        is_active: true,
      })
      .select()
      .single();

    if (error) throw error;

    return {
      id: data.id,
      userId: data.user_id,
      code: data.code,
      createdAt: new Date(data.created_at),
      isActive: data.is_active,
    };
  }

  async getUserReferralCode(userId: string): Promise<ReferralCode | null> {
    const { data, error } = await this.supabase
      .from('referral_codes')
      .select('*')
      .eq('user_id', userId)
      .eq('is_active', true)
      .single();

    if (error || !data) return null;

    return {
      id: data.id,
      userId: data.user_id,
      code: data.code,
      createdAt: new Date(data.created_at),
      isActive: data.is_active,
    };
  }

  async validateReferralCode(code: string): Promise<boolean> {
    const { data, error } = await this.supabase
      .from('referral_codes')
      .select('id')
      .eq('code', code.toUpperCase())
      .eq('is_active', true)
      .single();

    return !error && !!data;
  }

  async applyReferralCode(refereeId: string, code: string): Promise<Referral> {
    const { data: referralCode, error: codeError } = await this.supabase
      .from('referral_codes')
      .select('*')
      .eq('code', code.toUpperCase())
      .eq('is_active', true)
      .single();

    if (codeError || !referralCode) {
      throw new Error('Invalid referral code');
    }

    // Check if referee already used a code
    const existingReferral = await this.getUserReferral(refereeId);
    if (existingReferral) {
      throw new Error('You have already used a referral code');
    }

    // Create referral
    const { data, error } = await this.supabase
      .from('referrals')
      .insert({
        referrer_id: referralCode.user_id,
        referee_id: refereeId,
        code: code.toUpperCase(),
        status: 'completed',
      })
      .select()
      .single();

    if (error) throw error;

    // Grant rewards
    await this.processReferralReward(referralCode.user_id, refereeId);

    return {
      id: data.id,
      referrerId: data.referrer_id,
      refereeId: data.referee_id,
      code: data.code,
      status: data.status,
      reward: null,
      createdAt: new Date(data.created_at),
      completedAt: data.completed_at ? new Date(data.completed_at) : null,
    };
  }

  async getUserReferral(userId: string): Promise<Referral | null> {
    const { data, error } = await this.supabase
      .from('referrals')
      .select('*')
      .eq('referee_id', userId)
      .single();

    if (error || !data) return null;

    return {
      id: data.id,
      referrerId: data.referrer_id,
      refereeId: data.referee_id,
      code: data.code,
      status: data.status,
      reward: data.reward ? JSON.parse(data.reward) : null,
      createdAt: new Date(data.created_at),
      completedAt: data.completed_at ? new Date(data.completed_at) : null,
    };
  }

  async getReferralStats(userId: string): Promise<ReferralStats> {
    const { data: referrals, error } = await this.supabase
      .from('referrals')
      .select('*')
      .eq('referrer_id', userId);

    if (error) throw error;

    const completed = referrals.filter(r => r.status === 'completed' || r.status === 'rewarded');
    const pending = referrals.filter(r => r.status === 'pending');
    const rewards = referrals
      .filter(r => r.reward)
      .map(r => JSON.parse(r.reward) as ReferralReward);

    const nextMilestone = REFERRAL_MILESTONES.find(m => m.requiredReferrals > completed.length) || null;
    const previousMilestone = REFERRAL_MILESTONES.filter(m => m.requiredReferrals <= completed.length).pop();
    const prevCount = previousMilestone?.requiredReferrals || 0;
    const nextCount = nextMilestone?.requiredReferrals || completed.length;
    const progress = nextMilestone
      ? ((completed.length - prevCount) / (nextCount - prevCount)) * 100
      : 100;

    return {
      totalReferrals: referrals.length,
      completedReferrals: completed.length,
      pendingReferrals: pending.length,
      rewardsEarned: rewards,
      nextMilestone,
      progressToNextMilestone: Math.min(progress, 100),
    };
  }

  async getReferredUsers(userId: string): Promise<{ id: string; email: string; joinedAt: Date }[]> {
    const { data, error } = await this.supabase
      .from('referrals')
      .select('referee_id, referee:referee_id(email, created_at)')
      .eq('referrer_id', userId);

    if (error) throw error;

    return (data || []).map(r => ({
      id: r.referee_id,
      email: r.referee?.email || 'Unknown',
      joinedAt: new Date(r.referee?.created_at || r.created_at),
    }));
  }

  private async processReferralReward(referrerId: string, refereeId: string): Promise<void> {
    const stats = await this.getReferralStats(referrerId);
    const completedCount = stats.completedReferrals;

    // Check milestones
    const milestone = REFERRAL_MILESTONES.find(m => m.requiredReferrals === completedCount);
    if (milestone) {
      await this.grantReward(referrerId, milestone.reward);
    }

    // Give referee their first week free
    await this.grantReward(refereeId, {
      type: 'pro_week',
      value: 7,
      description: 'Welcome! 1 week of Pro free with referral',
    });
  }

  private async grantReward(userId: string, reward: ReferralReward): Promise<void> {
    const { error } = await this.supabase
      .from('user_rewards')
      .insert({
        user_id: userId,
        reward_type: reward.type,
        reward_value: reward.value,
        reward_description: reward.description,
      });

    if (error) throw error;

    // Extend Pro if applicable
    if (reward.type === 'pro_week' || reward.type === 'pro_month') {
      await this.supabase.rpc('extend_pro_subscription', {
        user_id: userId,
        days: reward.value,
      });
    } else if (reward.type === 'lifetime_pro') {
      await this.supabase
        .from('users')
        .update({ is_pro: true, pro_expires_at: null })
        .eq('id', userId);
    }
  }

  private generateUniqueCode(): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let code = 'PINKZ-';
    for (let i = 0; i < 6; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return code;
  }

  async getReferralLink(userId: string): Promise<string> {
    const code = await this.getUserReferralCode(userId);
    if (!code) {
      const newCode = await this.generateReferralCode(userId);
      return `https://pinkz.app/join/${newCode.code}`;
    }
    return `https://pinkz.app/join/${code.code}`;
  }

  async getShareMessage(userId: string): Promise<string> {
    const link = await this.getReferralLink(userId);
    const stats = await this.getReferralStats(userId);
    const nextMilestone = stats.nextMilestone;

    let message = `Join me on PINKZ - your AI Life OS! 🌸\n\nUse my referral link: ${link}\n\nWe both get rewards!`;

    if (nextMilestone) {
      message += `\n\nI'm ${stats.completedReferrals}/${nextMilestone.requiredReferrals} referrals to earning ${nextMilestone.reward.description}!`;
    }

    return message;
  }
}
