CREATE TABLE IF NOT EXISTS tutor_progress (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  language TEXT NOT NULL,
  level INTEGER NOT NULL DEFAULT 1,
  lesson_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
  score INTEGER DEFAULT 0,
  completed_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_tutor_progress_user ON tutor_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_tutor_progress_language ON tutor_progress(user_id, language);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tutor_progress_lesson ON tutor_progress(user_id, lesson_id);

CREATE TABLE IF NOT EXISTS tutor_sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  language TEXT NOT NULL,
  messages TEXT NOT NULL DEFAULT '[]',
  lesson_id TEXT,
  started_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_message_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_tutor_sessions_user ON tutor_sessions(user_id);

CREATE TABLE IF NOT EXISTS tutor_achievements (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  achievement_type TEXT NOT NULL,
  metadata TEXT DEFAULT '{}',
  earned_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_tutor_achievements_user ON tutor_achievements(user_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tutor_achievements_type ON tutor_achievements(user_id, achievement_type);
