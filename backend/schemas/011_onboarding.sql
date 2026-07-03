CREATE TABLE IF NOT EXISTS onboarding_progress (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  step INTEGER NOT NULL DEFAULT 0,
  selected_persona TEXT,
  selected_interests TEXT DEFAULT '[]',
  selected_goals TEXT DEFAULT '[]',
  completed_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_onboarding_user ON onboarding_progress(user_id);
