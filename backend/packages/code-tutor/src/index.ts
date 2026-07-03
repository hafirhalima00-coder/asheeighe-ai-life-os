export interface CodeLanguage {
  id: string;
  name: string;
  icon: string;
  description: string;
  totalLessons: number;
}

export interface TutorLevel {
  number: number;
  title: string;
  topics: string[];
  lessons: TutorLesson[];
  requiredScore: number;
}

export interface TutorLesson {
  id: string;
  levelNumber: number;
  title: string;
  description: string;
  type: 'concept' | 'exercise' | 'quiz' | 'project';
  content: string;
  codeExample?: string;
  expectedOutput?: string;
  hints: string[];
  order: number;
  estimatedMinutes: number;
  xpReward: number;
}

export interface TutorProgress {
  userId: string;
  language: string;
  level: number;
  lessonId: string;
  status: 'not_started' | 'in_progress' | 'completed';
  score: number;
  completedAt?: string;
  createdAt: string;
  updatedAt: string;
}

export interface TutorSession {
  id: string;
  userId: string;
  language: string;
  messages: TutorMessage[];
  lessonId?: string;
  startedAt: string;
  lastMessageAt: string;
}

export interface TutorMessage {
  id: string;
  role: 'user' | 'assistant' | 'system';
  content: string;
  timestamp: string;
  metadata?: Record<string, unknown>;
}

export interface TutorAchievement {
  id: string;
  userId: string;
  achievementType: string;
  metadata?: Record<string, unknown>;
  earnedAt: string;
}

export interface CodeReviewResult {
  isCorrect: boolean;
  score: number;
  feedback: string;
  suggestions: string[];
  hints: string[];
}

export interface AdaptiveDifficulty {
  level: number;
  speed: 'slow' | 'normal' | 'fast';
  retryCount: number;
  averageScore: number;
}

export interface TutorStats {
  lessonsCompleted: number;
  totalScore: number;
  averageScore: number;
  currentStreak: number;
  bestStreak: number;
  timeSpentMinutes: number;
  languagesStarted: number;
  languagesCompleted: number;
}
