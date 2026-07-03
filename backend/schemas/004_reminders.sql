-- Reminders table
-- Stores reminders linked to tasks or calendar events
CREATE TABLE IF NOT EXISTS reminders (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  remind_at TEXT NOT NULL,
  dismissed INTEGER NOT NULL DEFAULT 0,
  repeat_interval TEXT DEFAULT NULL,
  linked_entity_type TEXT DEFAULT NULL,
  linked_entity_id TEXT DEFAULT NULL,
  notification_channels TEXT NOT NULL DEFAULT '["in_app"]',
  metadata TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_reminders_user_id ON reminders(user_id);
CREATE INDEX IF NOT EXISTS idx_reminders_remind_at ON reminders(remind_at);
CREATE INDEX IF NOT EXISTS idx_reminders_dismissed ON reminders(dismissed);
CREATE INDEX IF NOT EXISTS idx_reminders_linked ON reminders(linked_entity_type, linked_entity_id);
