export * from './templates';
export * from './referrals';
export * from './sharing';

export interface SocialConfig {
  supabaseUrl: string;
  supabaseKey: string;
  shareBaseUrl: string;
}

export interface SocialUser {
  id: string;
  email: string;
  isPro: boolean;
  referralCode: string;
  createdAt: Date;
}

export interface SocialResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}
