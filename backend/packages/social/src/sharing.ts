import { SupabaseClient } from '@supabase/supabase-js';

export interface SharedAchievement {
  id: string;
  userId: string;
  type: AchievementType;
  title: string;
  description: string;
  data: AchievementData;
  shareUrl: string;
  imageUrl: string | null;
  createdAt: Date;
}

export type AchievementType =
  | 'streak'
  | 'milestone'
  | 'completion'
  | 'level_up'
  | 'custom';

export interface AchievementData {
  value?: number;
  unit?: string;
  icon?: string;
  color?: string;
  image?: string;
}

export interface ShareCard {
  id: string;
  title: string;
  description: string;
  imageUrl: string;
  shareUrl: string;
  stats: ShareCardStat[];
  theme: ShareCardTheme;
}

export interface ShareCardStat {
  label: string;
  value: string | number;
}

export interface ShareCardTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
}

export const SHARE_THEMES: ShareCardTheme[] = [
  {
    primaryColor: '#FF6B9D',
    secondaryColor: '#FFB3D1',
    backgroundColor: '#FFF0F5',
    textColor: '#1A1A1A',
  },
  {
    primaryColor: '#4A90E2',
    secondaryColor: '#82B1FF',
    backgroundColor: '#E3F2FD',
    textColor: '#1A1A1A',
  },
  {
    primaryColor: '#50C878',
    secondaryColor: '#98FB98',
    backgroundColor: '#E8F5E9',
    textColor: '#1A1A1A',
  },
  {
    primaryColor: '#9B59B6',
    secondaryColor: '#CE93D8',
    backgroundColor: '#F3E5F5',
    textColor: '#1A1A1A',
  },
  {
    primaryColor: '#FF9800',
    secondaryColor: '#FFB74D',
    backgroundColor: '#FFF3E0',
    textColor: '#1A1A1A',
  },
];

export interface SharePlatform {
  id: string;
  name: string;
  icon: string;
  shareUrl: string;
  maxChars?: number;
}

export const SHARE_PLATFORMS: SharePlatform[] = [
  {
    id: 'twitter',
    name: 'Twitter',
    icon: 'twitter',
    shareUrl: 'https://twitter.com/intent/tweet',
    maxChars: 280,
  },
  {
    id: 'instagram',
    name: 'Instagram',
    icon: 'instagram',
    shareUrl: 'https://www.instagram.com/',
  },
  {
    id: 'whatsapp',
    name: 'WhatsApp',
    icon: 'whatsapp',
    shareUrl: 'https://wa.me/',
  },
  {
    id: 'facebook',
    name: 'Facebook',
    icon: 'facebook',
    shareUrl: 'https://www.facebook.com/sharer/sharer.php',
  },
  {
    id: 'copy',
    name: 'Copy Link',
    icon: 'link',
    shareUrl: '',
  },
];

export class SharingService {
  constructor(private supabase: SupabaseClient) {}

  async createSharedAchievement(
    userId: string,
    type: AchievementType,
    title: string,
    description: string,
    data: AchievementData = {}
  ): Promise<SharedAchievement> {
    const shareUrl = this.generateShareUrl(userId);
    const imageUrl = await this.generateShareImage(userId, type, title, data);

    const { data: achievement, error } = await this.supabase
      .from('shared_achievements')
      .insert({
        user_id: userId,
        type,
        title,
        description,
        data: JSON.stringify(data),
        share_url: shareUrl,
        image_url: imageUrl,
      })
      .select()
      .single();

    if (error) throw error;

    return this.mapAchievement(achievement);
  }

  async getUserAchievements(userId: string, limit = 20): Promise<SharedAchievement[]> {
    const { data, error } = await this.supabase
      .from('shared_achievements')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) throw error;
    return data.map(this.mapAchievement);
  }

  async getAchievement(achievementId: string): Promise<SharedAchievement | null> {
    const { data, error } = await this.supabase
      .from('shared_achievements')
      .select('*')
      .eq('id', achievementId)
      .single();

    if (error || !data) return null;
    return this.mapAchievement(data);
  }

  async incrementShareCount(achievementId: string): Promise<void> {
    await this.supabase.rpc('increment_share_count', { achievement_id: achievementId });
  }

  async getShareUrl(userId: string, achievementId?: string): Promise<string> {
    const baseUrl = `https://asheeighe.app/share/${userId}`;
    return achievementId ? `${baseUrl}?achievement=${achievementId}` : baseUrl;
  }

  async getPublicProfile(userId: string): Promise<PublicProfile | null> {
    const { data: user, error: userError } = await this.supabase
      .from('users')
      .select('id, name, avatar_url, bio')
      .eq('id', userId)
      .single();

    if (userError || !user) return null;

    const { data: achievements } = await this.supabase
      .from('shared_achievements')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .limit(10);

    return {
      id: user.id,
      name: user.name,
      avatarUrl: user.avatar_url,
      bio: user.bio,
      achievements: (achievements || []).map(this.mapAchievement),
    };
  }

  async generateShareCard(
    userId: string,
    achievementId: string,
    theme: ShareCardTheme = SHARE_THEMES[0]
  ): Promise<ShareCard> {
    const achievement = await this.getAchievement(achievementId);
    if (!achievement) throw new Error('Achievement not found');

    const stats = await this.getShareStats(achievementId);

    return {
      id: achievementId,
      title: achievement.title,
      description: achievement.description,
      imageUrl: achievement.imageUrl || '',
      shareUrl: achievement.shareUrl,
      stats,
      theme,
    };
  }

  private generateShareUrl(userId: string): string {
    const timestamp = Date.now().toString(36);
    const random = Math.random().toString(36).substring(2, 8);
    return `https://asheeighe.app/share/${userId}/${timestamp}${random}`;
  }

  private async generateShareImage(
    userId: string,
    type: AchievementType,
    title: string,
    data: AchievementData
  ): Promise<string> {
    // In production, this would generate an image using a service like
    // Cloudflare Images or a canvas library
    const imageUrl = `https://asheeighe.app/api/share-image?userId=${userId}&type=${type}&title=${encodeURIComponent(title)}&color=${data.color || 'FF6B9D'}`;
    return imageUrl;
  }

  private async getShareStats(achievementId: string): Promise<ShareCardStat[]> {
    const { data } = await this.supabase
      .from('shared_achievements')
      .select('share_count, view_count')
      .eq('id', achievementId)
      .single();

    return [
      { label: 'Shares', value: data?.share_count || 0 },
      { label: 'Views', value: data?.view_count || 0 },
    ];
  }

  private mapAchievement(data: any): SharedAchievement {
    return {
      id: data.id,
      userId: data.user_id,
      type: data.type,
      title: data.title,
      description: data.description,
      data: typeof data.data === 'string' ? JSON.parse(data.data) : data.data,
      shareUrl: data.share_url,
      imageUrl: data.image_url,
      createdAt: new Date(data.created_at),
    };
  }
}

interface PublicProfile {
  id: string;
  name: string;
  avatarUrl: string | null;
  bio: string | null;
  achievements: SharedAchievement[];
}

export function generateShareText(achievement: SharedAchievement): string {
  const emoji = getAchievementEmoji(achievement.type);
  return `${emoji} ${achievement.title}\n\n${achievement.description}\n\nCheck out my progress on asheeighe! 🌸\n${achievement.shareUrl}`;
}

function getAchievementEmoji(type: AchievementType): string {
  const emojis: Record<AchievementType, string> = {
    streak: '🔥',
    milestone: '🎉',
    completion: '✅',
    level_up: '⬆️',
    custom: '⭐',
  };
  return emojis[type];
}
