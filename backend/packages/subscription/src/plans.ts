import { PlanId, Feature } from './index';

export interface PlanDefinition {
  id: PlanId;
  name: string;
  description: string;
  price: number;
  yearlyPrice: number;
  features: Feature[];
  aiMessagesPerDay: number;
  storageLimit: string;
  isPopular: boolean;
}

export const PLANS: Record<PlanId, PlanDefinition> = {
  FREE: {
    id: 'FREE',
    name: 'Free',
    description: 'Get started with essential features',
    price: 0,
    yearlyPrice: 0,
    features: [],
    aiMessagesPerDay: 5,
    storageLimit: '50MB',
    isPopular: false,
  },
  PRO_MONTHLY: {
    id: 'PRO_MONTHLY',
    name: 'Pro',
    description: 'Unlock the full asheeighe experience',
    price: 999,
    yearlyPrice: 7999,
    features: [
      'ai_unlimited',
      'islamic_full',
      'voice_engine',
      'advanced_analytics',
      'templates',
      'gamification_full',
    ],
    aiMessagesPerDay: -1, // unlimited
    storageLimit: '10GB',
    isPopular: true,
  },
  PRO_YEARLY: {
    id: 'PRO_YEARLY',
    name: 'Pro',
    description: 'Unlock the full asheeighe experience',
    price: 999,
    yearlyPrice: 7999,
    features: [
      'ai_unlimited',
      'islamic_full',
      'voice_engine',
      'advanced_analytics',
      'templates',
      'gamification_full',
    ],
    aiMessagesPerDay: -1,
    storageLimit: '10GB',
    isPopular: true,
  },
  PREMIUM_MONTHLY: {
    id: 'PREMIUM_MONTHLY',
    name: 'Premium',
    description: 'The ultimate productivity suite',
    price: 1999,
    yearlyPrice: 14999,
    features: [
      'ai_unlimited',
      'islamic_full',
      'voice_engine',
      'advanced_analytics',
      'templates',
      'gamification_full',
      'code_tutor',
      'priority_ai',
      'business_features',
      'api_access',
      'custom_integrations',
      'white_label',
      'family_sharing',
    ],
    aiMessagesPerDay: -1,
    storageLimit: '100GB',
    isPopular: false,
  },
  PREMIUM_YEARLY: {
    id: 'PREMIUM_YEARLY',
    name: 'Premium',
    description: 'The ultimate productivity suite',
    price: 1999,
    yearlyPrice: 14999,
    features: [
      'ai_unlimited',
      'islamic_full',
      'voice_engine',
      'advanced_analytics',
      'templates',
      'gamification_full',
      'code_tutor',
      'priority_ai',
      'business_features',
      'api_access',
      'custom_integrations',
      'white_label',
      'family_sharing',
    ],
    aiMessagesPerDay: -1,
    storageLimit: '100GB',
    isPopular: false,
  },
};

export const FREE_FEATURES: Feature[] = [];

export const PRO_FEATURES: Feature[] = [
  'ai_unlimited',
  'islamic_full',
  'voice_engine',
  'advanced_analytics',
  'templates',
  'gamification_full',
];

export const PREMIUM_FEATURES: Feature[] = [
  ...PRO_FEATURES,
  'code_tutor',
  'priority_ai',
  'business_features',
  'api_access',
  'custom_integrations',
  'white_label',
  'family_sharing',
];

export const FEATURE_DISPLAY_NAMES: Record<Feature, string> = {
  ai_unlimited: 'Unlimited AI Messages',
  voice_engine: 'Voice Engine',
  islamic_full: 'All Islamic Features',
  advanced_analytics: 'Advanced Analytics',
  templates: 'Premium Templates',
  gamification_full: 'Full Gamification',
  code_tutor: 'AI Code Tutor',
  priority_ai: 'Priority AI (Faster)',
  business_features: 'Business Features',
  api_access: 'API Access',
  custom_integrations: 'Custom Integrations',
  white_label: 'White-Label Exports',
  family_sharing: 'Family Sharing (5)',
};

export function getPlanById(planId: PlanId): PlanDefinition {
  return PLANS[planId];
}

export function getDisplayPlans(): PlanDefinition[] {
  return [PLANS.FREE, PLANS.PRO_MONTHLY, PLANS.PREMIUM_MONTHLY];
}
