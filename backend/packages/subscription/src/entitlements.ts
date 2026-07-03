import { Subscription, PlanId, Feature, UsageRecord } from './index';
import { PLANS, PRO_FEATURES, PREMIUM_FEATURES } from './plans';

export function isPro(subscription: Subscription | null): boolean {
  if (!subscription || subscription.status !== 'active') return false;
  return (
    subscription.planId === 'PRO_MONTHLY' ||
    subscription.planId === 'PRO_YEARLY' ||
    isPremium(subscription)
  );
}

export function isPremium(subscription: Subscription | null): boolean {
  if (!subscription || subscription.status !== 'active') return false;
  return (
    subscription.planId === 'PREMIUM_MONTHLY' ||
    subscription.planId === 'PREMIUM_YEARLY'
  );
}

export function isPaidUser(subscription: Subscription | null): boolean {
  return isPro(subscription) || isPremium(subscription);
}

export function canAccessFeature(
  subscription: Subscription | null,
  feature: Feature
): boolean {
  if (!subscription || subscription.status !== 'active') {
    return false;
  }

  const plan = PLANS[subscription.planId];
  if (!plan) return false;

  if (subscription.planId === 'PREMIUM_MONTHLY' || subscription.planId === 'PREMIUM_YEARLY') {
    return PREMIUM_FEATURES.includes(feature);
  }

  if (subscription.planId === 'PRO_MONTHLY' || subscription.planId === 'PRO_YEARLY') {
    return PRO_FEATURES.includes(feature);
  }

  return false;
}

export function getRemainingAiMessages(
  subscription: Subscription | null,
  todayUsage: UsageRecord | null
): number {
  if (!subscription || subscription.status !== 'active') {
    return 0;
  }

  const plan = PLANS[subscription.planId];
  if (!plan) return 0;

  if (plan.aiMessagesPerDay === -1) {
    return -1; // unlimited
  }

  const used = todayUsage?.count ?? 0;
  return Math.max(0, plan.aiMessagesPerDay - used);
}

export function getStorageUsed(bytesUsed: number): {
  used: string;
  limit: string;
  percentage: number;
  subscription: Subscription | null;
} {
  return {
    used: formatBytes(bytesUsed),
    limit: '',
    percentage: 0,
    subscription: null,
  };
}

export function getStorageLimit(subscription: Subscription | null): string {
  if (!subscription || subscription.status !== 'active') {
    return '50MB';
  }
  const plan = PLANS[subscription.planId];
  return plan?.storageLimit ?? '50MB';
}

export function getStoragePercentage(
  subscription: Subscription | null,
  bytesUsed: number
): number {
  const limit = getStorageLimit(subscription);
  const limitBytes = parseStorageLimit(limit);
  if (limitBytes === 0) return 0;
  return Math.min(100, (bytesUsed / limitBytes) * 100);
}

function formatBytes(bytes: number): string {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
}

function parseStorageLimit(limit: string): number {
  const match = limit.match(/^([\d.]+)\s*(B|KB|MB|GB|TB)$/i);
  if (!match) return 0;
  const value = parseFloat(match[1]);
  const unit = match[2].toUpperCase();
  const multipliers: Record<string, number> = {
    B: 1,
    KB: 1024,
    MB: 1024 * 1024,
    GB: 1024 * 1024 * 1024,
    TB: 1024 * 1024 * 1024 * 1024,
  };
  return value * (multipliers[unit] ?? 1);
}

export function getEffectivePlanId(
  subscription: Subscription | null
): PlanId {
  if (!subscription || subscription.status !== 'active') {
    return 'FREE';
  }
  return subscription.planId;
}
