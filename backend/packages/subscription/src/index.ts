export * from './plans';
export * from './entitlements';
export * from './webhook';

export type PlanId = 'FREE' | 'PRO_MONTHLY' | 'PRO_YEARLY' | 'PREMIUM_MONTHLY' | 'PREMIUM_YEARLY';

export type SubscriptionStatus = 'active' | 'canceled' | 'trialing' | 'past_due' | 'incomplete';

export type Feature =
  | 'ai_unlimited'
  | 'voice_engine'
  | 'islamic_full'
  | 'advanced_analytics'
  | 'templates'
  | 'gamification_full'
  | 'code_tutor'
  | 'priority_ai'
  | 'business_features'
  | 'api_access'
  | 'custom_integrations'
  | 'white_label'
  | 'family_sharing';

export interface Subscription {
  id: string;
  userId: string;
  planId: PlanId;
  status: SubscriptionStatus;
  currentPeriodStart: string;
  currentPeriodEnd: string;
  stripeSubscriptionId: string | null;
  stripeCustomerId: string | null;
  cancelAt: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface Payment {
  id: string;
  userId: string;
  subscriptionId: string;
  amount: number;
  currency: string;
  status: string;
  stripePaymentId: string;
  createdAt: string;
}

export interface UsageRecord {
  id: string;
  userId: string;
  feature: string;
  count: number;
  date: string;
}
