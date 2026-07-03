CREATE TABLE voice_usage (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  language TEXT NOT NULL DEFAULT 'en',
  duration INTEGER NOT NULL DEFAULT 0,
  type TEXT NOT NULL CHECK (type IN ('tts', 'stt')),
  feature TEXT,
  createdAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_voice_usage_userId ON voice_usage(userId);
CREATE INDEX idx_voice_usage_createdAt ON voice_usage(createdAt);
CREATE INDEX idx_voice_usage_type ON voice_usage(type);
CREATE INDEX idx_voice_usage_language ON voice_usage(language);

-- Daily voice usage aggregation view
CREATE OR REPLACE VIEW voice_usage_daily AS
SELECT
  userId,
  DATE(createdAt) as date,
  SUM(duration) as totalDuration,
  COUNT(*) as totalRequests,
  SUM(CASE WHEN type = 'tts' THEN duration ELSE 0 END) as ttsDuration,
  SUM(CASE WHEN type = 'stt' THEN duration ELSE 0 END) as sttDuration
FROM voice_usage
GROUP BY userId, DATE(createdAt);
