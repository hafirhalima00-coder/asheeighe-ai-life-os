CREATE TABLE IF NOT EXISTS voice_usage (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  language TEXT NOT NULL DEFAULT 'en',
  duration_seconds INTEGER DEFAULT 0,
  type TEXT NOT NULL DEFAULT 'tts' CHECK (type IN ('tts', 'stt')),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_voice_usage_user ON voice_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_voice_usage_date ON voice_usage(created_at);
