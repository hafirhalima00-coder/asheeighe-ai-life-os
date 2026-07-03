-- Composio connections table
-- Stores third-party OAuth connections managed through Composio
CREATE TABLE IF NOT EXISTS composio_connections (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  integration_name TEXT NOT NULL,
  integration_id TEXT NOT NULL,
  connection_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  auth_mode TEXT NOT NULL DEFAULT 'oauth',
  account_info TEXT NOT NULL DEFAULT '{}',
  metadata TEXT NOT NULL DEFAULT '{}',
  last_sync_at TEXT DEFAULT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_composio_connections_connection ON composio_connections(connection_id);
CREATE INDEX IF NOT EXISTS idx_composio_connections_user ON composio_connections(user_id);
CREATE INDEX IF NOT EXISTS idx_composio_connections_integration ON composio_connections(integration_name);
