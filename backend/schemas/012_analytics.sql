-- Analytics events table for tracking viral metrics
CREATE TABLE IF NOT EXISTS analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  event VARCHAR(100) NOT NULL,
  properties JSONB DEFAULT '{}',
  session_id VARCHAR(100),
  device_info JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_analytics_events_user ON analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_events_event ON analytics_events(event);
CREATE INDEX IF NOT EXISTS idx_analytics_events_created ON analytics_events(created_at);
CREATE INDEX IF NOT EXISTS idx_analytics_events_session ON analytics_events(session_id);

-- Composite index for viral metrics queries
CREATE INDEX IF NOT EXISTS idx_analytics_viral_metrics ON analytics_events(event, created_at, user_id);

-- Row Level Security
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

-- Users can view their own analytics
CREATE POLICY "Users can view own analytics"
  ON analytics_events FOR SELECT
  USING (auth.uid() = user_id);

-- Service role can insert analytics (via API)
CREATE POLICY "Service can insert analytics"
  ON analytics_events FOR INSERT
  WITH CHECK (true);

-- Common analytics events for viral tracking:
-- - referral_sent: When a user shares their referral code
-- - referral_applied: When a user applies a referral code
-- - template_shared: When a user shares a template
-- - achievement_shared: When a user shares an achievement
-- - app_installed: When a new user installs the app
-- - onboarding_completed: When a user completes onboarding
-- - first_action: When a user takes their first action
-- - daily_active: Daily active user event
-- - share_clicked: When a share button is clicked

-- View for viral metrics dashboard
CREATE OR REPLACE VIEW viral_metrics AS
SELECT
  DATE(created_at) as date,
  event,
  COUNT(DISTINCT user_id) as unique_users,
  COUNT(*) as total_events,
  COUNT(DISTINCT session_id) as unique_sessions
FROM analytics_events
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at), event
ORDER BY date DESC, total_events DESC;

-- View for referral funnel
CREATE OR REPLACE VIEW referral_funnel AS
SELECT
  DATE(created_at) as date,
  COUNT(CASE WHEN event = 'referral_sent' THEN 1 END) as referrals_sent,
  COUNT(CASE WHEN event = 'referral_applied' THEN 1 END) as referrals_applied,
  COUNT(CASE WHEN event = 'referral_completed' THEN 1 END) as referrals_completed,
  ROUND(
    COUNT(CASE WHEN event = 'referral_applied' THEN 1 END)::DECIMAL / 
    NULLIF(COUNT(CASE WHEN event = 'referral_sent' THEN 1 END), 0) * 100,
    2
  ) as conversion_rate
FROM analytics_events
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- View for template popularity
CREATE OR REPLACE VIEW template_popularity AS
SELECT
  (properties->>'template_id') as template_id,
  (properties->>'template_name') as template_name,
  COUNT(*) as usage_count,
  COUNT(DISTINCT user_id) as unique_users,
  DATE(created_at) as date
FROM analytics_events
WHERE event = 'template_used'
GROUP BY (properties->>'template_id'), (properties->>'template_name'), DATE(created_at)
ORDER BY usage_count DESC;

-- Function to track analytics event
CREATE OR REPLACE FUNCTION track_analytics_event(
  p_user_id UUID,
  p_event VARCHAR(100),
  p_properties JSONB DEFAULT '{}',
  p_session_id VARCHAR(100) DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO analytics_events (user_id, event, properties, session_id)
  VALUES (p_user_id, p_event, p_properties, p_session_id)
  RETURNING id INTO v_id;
  
  RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Function to get viral coefficient
CREATE OR REPLACE FUNCTION get_viral_coefficient(days INTEGER DEFAULT 30)
RETURNS DECIMAL AS $$
DECLARE
  v_new_users INTEGER;
  v_referrals INTEGER;
  v_coefficient DECIMAL;
BEGIN
  -- Count new users in the period
  SELECT COUNT(DISTINCT user_id) INTO v_new_users
  FROM analytics_events
  WHERE event = 'app_installed'
    AND created_at >= NOW() - (days || ' days')::INTERVAL;
  
  -- Count successful referrals
  SELECT COUNT(DISTINCT referee_id) INTO v_referrals
  FROM referrals
  WHERE created_at >= NOW() - (days || ' days')::INTERVAL
    AND status = 'completed';
  
  -- Calculate coefficient
  IF v_new_users > 0 THEN
    v_coefficient := v_referrals::DECIMAL / v_new_users;
  ELSE
    v_coefficient := 0;
  END IF;
  
  RETURN v_coefficient;
END;
$$ LANGUAGE plpgsql;
