import type {
  CodeReviewResult,
  TutorMessage,
  TutorSession,
  AdaptiveDifficulty,
  TutorStats,
  TutorLesson,
} from './index';
import { getLessonById, getLessonsForLanguage, getNextLesson } from './curriculum';

const HINT_ESCALATION = [
  'Think about the basic concept being tested here.',
  'Try breaking the problem into smaller steps.',
  'Look at the code example for inspiration.',
  'The key is understanding how the syntax works.',
];

export class CodeTutorEngine {
  generatePersonalizedLesson(
    language: string,
    difficulty: AdaptiveDifficulty,
    completedLessons: string[],
  ): TutorLesson | null {
    return getNextLesson(language, completedLessons);
  }

  reviewCode(
    submittedCode: string,
    lesson: TutorLesson,
    difficulty: AdaptiveDifficulty,
  ): CodeReviewResult {
    const normalized = submittedCode.trim().toLowerCase();
    const expected = (lesson.expectedOutput ?? '').trim().toLowerCase();

    if (!expected) {
      return {
        isCorrect: true,
        score: 80,
        feedback: 'Code submitted successfully! Let me review it.',
        suggestions: [],
        hints: [],
      };
    }

    const isCorrect = normalized === expected;
    const baseScore = isCorrect ? 100 : 60;
    const adjustedScore = Math.min(100, baseScore + (difficulty.level * 2));

    const suggestions: string[] = [];
    if (!isCorrect) {
      if (!normalized.includes('print') && lesson.content.includes('print')) {
        suggestions.push('Make sure you use print() to display output.');
      }
      if (normalized.length < expected.length * 0.5) {
        suggestions.push('Your solution seems incomplete. Try writing more code.');
      }
      suggestions.push('Compare your output with the expected output carefully.');
    }

    return {
      isCorrect,
      score: adjustedScore,
      feedback: isCorrect
        ? 'Excellent work! Your code is correct.'
        : 'Not quite there yet. Check the hints and try again!',
      suggestions,
      hints: isCorrect ? [] : this.getProgressiveHints(lesson, 2),
    };
  }

  generateHint(lesson: TutorLesson, hintIndex: number): string {
    const idx = Math.min(hintIndex, HINT_ESCALATION.length - 1);
    const customHint = lesson.hints[hintIndex];
    const genericHint = HINT_ESCALATION[idx];
    return customHint ?? genericHint;
  }

  private getProgressiveHints(lesson: TutorLesson, count: number): string[] {
    return Array.from({ length: count }, (_, i) => this.generateHint(lesson, i));
  }

  async generateTutorResponse(
    messages: TutorMessage[],
    lesson: TutorLesson,
    mode: 'help' | 'explain' | 'fix' | 'project' = 'help',
  ): Promise<string> {
    const lastUserMessage = messages.filter((m) => m.role === 'user').pop();
    const userQuery = lastUserMessage?.content.toLowerCase() ?? '';

    if (mode === 'explain' || userQuery.includes('explain')) {
      return this.explainConcept(lesson);
    }
    if (mode === 'fix' || userQuery.includes('fix') || userQuery.includes('error')) {
      return this.provideFixGuidance(lesson, lastUserMessage?.content ?? '');
    }
    if (mode === 'project') {
      return this.suggestProject(lesson);
    }
    return this.provideHelp(lesson, userQuery);
  }

  private explainConcept(lesson: TutorLesson): string {
    return `Here's a breakdown of "${lesson.title}":\n\n${lesson.content}\n\nKey example:\n\`\`\`\n${lesson.codeExample ?? 'No example available'}\n\`\`\`\n\nTry to understand each line step by step. Would you like me to explain any specific part?`;
  }

  private provideFixGuidance(lesson: TutorLesson, userCode: string): string {
    const hints = this.getProgressiveHints(lesson, 2);
    return `Let's debug your code together!\n\nCommon issues to check:\n${hints.map((h) => `- ${h}`).join('\n')}\n\nYour code:\n\`\`\`\n${userCode}\n\`\`\`\n\nTry making the suggested changes and run it again.`;
  }

  private suggestProject(lesson: TutorLesson): string {
    return `Great idea! Based on what you've learned in "${lesson.title}", here's a mini-project:\n\n1. Extend the example code with your own additions\n2. Add new variables or modify the output\n3. Try combining concepts from previous lessons\n\nStart small and build up. You've got this! 💪`;
  }

  private provideHelp(lesson: TutorLesson, query: string): string {
    if (query.includes('hint')) {
      return `Here's a hint for "${lesson.title}":\n\n${this.generateHint(lesson, 0)}\n\nStill stuck? Ask for another hint!`;
    }
    if (query.includes('example')) {
      return `Here's the code example for this lesson:\n\n\`\`\`\n${lesson.codeExample ?? 'No example yet'}\n\`\`\`\n\nTry running this code first, then modify it!`;
    }
    return `I can help you with "${lesson.title}"!\n\nYou can:\n- Ask me to **explain** a concept\n- Ask for a **hint** if you're stuck\n- Say "fix my code" and paste your attempt\n- Ask for an **example**\n\nWhat would you like to do?`;
  }

  calculateAdaptiveDifficulty(
    recentScores: number[],
    currentLevel: number,
  ): AdaptiveDifficulty {
    const avg = recentScores.length > 0
      ? recentScores.reduce((a, b) => a + b, 0) / recentScores.length
      : 50;

    let speed: AdaptiveDifficulty['speed'] = 'normal';
    if (avg >= 85) speed = 'fast';
    else if (avg < 60) speed = 'slow';

    return {
      level: currentLevel,
      speed,
      retryCount: recentScores.filter((s) => s < 60).length,
      averageScore: avg,
    };
  }

  calculateStats(progress: { score: number; completedAt?: string }[]): TutorStats {
    const completed = progress.filter((p) => p.completedAt);
    const scores = completed.map((p) => p.score);
    const avg = scores.length > 0
      ? scores.reduce((a, b) => a + b, 0) / scores.length
      : 0;

    return {
      lessonsCompleted: completed.length,
      totalScore: scores.reduce((a, b) => a + b, 0),
      averageScore: Math.round(avg),
      currentStreak: this.calculateStreak(completed),
      bestStreak: this.calculateBestStreak(completed),
      timeSpentMinutes: completed.length * 12,
      languagesStarted: 0,
      languagesCompleted: 0,
    };
  }

  private calculateStreak(completed: { completedAt?: string }[]): number {
    if (completed.length === 0) return 0;
    const dates = completed
      .filter((c) => c.completedAt)
      .map((c) => new Date(c.completedAt!).toDateString())
      .filter((d, i, arr) => arr.indexOf(d) === i)
      .sort()
      .reverse();

    let streak = 1;
    for (let i = 0; i < dates.length - 1; i++) {
      const curr = new Date(dates[i]);
      const prev = new Date(dates[i + 1]);
      const diffDays = (curr.getTime() - prev.getTime()) / (1000 * 60 * 60 * 24);
      if (diffDays === 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  private calculateBestStreak(completed: { completedAt?: string }[]): number {
    const dates = completed
      .filter((c) => c.completedAt)
      .map((c) => new Date(c.completedAt!).toDateString())
      .filter((d, i, arr) => arr.indexOf(d) === i)
      .sort();

    let best = 0;
    let current = 1;
    for (let i = 1; i < dates.length; i++) {
      const curr = new Date(dates[i]);
      const prev = new Date(dates[i - 1]);
      const diffDays = (curr.getTime() - prev.getTime()) / (1000 * 60 * 60 * 24);
      if (diffDays === 1) {
        current++;
      } else {
        best = Math.max(best, current);
        current = 1;
      }
    }
    return Math.max(best, current);
  }
}

export function createTutorEngine(): CodeTutorEngine {
  return new CodeTutorEngine();
}
