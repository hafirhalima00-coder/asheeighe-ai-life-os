export * from './tts';
export * from './stt';

export interface VoiceSettings {
  language: 'ar' | 'en' | 'fr';
  speed: number;
  pitch: number;
  voice: 'male' | 'female';
  isTTSEnabled: boolean;
  isSTTEnabled: boolean;
}

export interface VoiceUsage {
  id: string;
  userId: string;
  language: string;
  duration: number;
  type: 'tts' | 'stt';
  createdAt: string;
}

export const DEFAULT_VOICE_SETTINGS: VoiceSettings = {
  language: 'en',
  speed: 1.0,
  pitch: 1.0,
  voice: 'female',
  isTTSEnabled: true,
  isSTTEnabled: true,
};

export const VOICE_LIMITS = {
  free: { dailyMinutes: 5, monthlyMinutes: 60 },
  pro: { dailyMinutes: -1, monthlyMinutes: -1 },
  premium: { dailyMinutes: -1, monthlyMinutes: -1 },
};
