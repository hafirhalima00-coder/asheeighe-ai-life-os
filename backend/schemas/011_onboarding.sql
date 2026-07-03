-- Onboarding progress table
CREATE TABLE IF NOT EXISTS onboarding_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  step INTEGER DEFAULT 0,
  selected_persona VARCHAR(50),
  selected_interests TEXT[] DEFAULT '{}',
  selected_goals TEXT[] DEFAULT '{}',
  notification_settings JSONB DEFAULT '{
    "prayer_reminders": true,
    "task_reminders": true,
    "study_reminders": true,
    "daily_inspiration": true
  }',
  connected_apps TEXT[] DEFAULT '{}',
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_onboarding_progress_user ON onboarding_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_onboarding_progress_step ON onboarding_progress(step);

-- Row Level Security
ALTER TABLE onboarding_progress ENABLE ROW LEVEL SECURITY;

-- Users can view their own onboarding progress
CREATE POLICY "Users can view own onboarding progress"
  ON onboarding_progress FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own onboarding progress
CREATE POLICY "Users can insert own onboarding progress"
  ON onboarding_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own onboarding progress
CREATE POLICY "Users can update own onboarding progress"
  ON onboarding_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- Function to complete onboarding
CREATE OR REPLACE FUNCTION complete_onboarding(user_id UUID)
RETURNS VOID AS $$
BEGIN
  INSERT INTO onboarding_progress (user_id, step, completed_at)
  VALUES (user_id, 6, NOW())
  ON CONFLICT (user_id)
  DO UPDATE SET
    step = 6,
    completed_at = NOW(),
    updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to save onboarding progress
CREATE OR REPLACE FUNCTION save_onboarding_progress(
  p_user_id UUID,
  p_step INTEGER,
  p_persona VARCHAR(50) DEFAULT NULL,
  p_interests TEXT[] DEFAULT NULL,
  p_goals TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO onboarding_progress (user_id, step, selected_persona, selected_interests, selected_goals)
  VALUES (p_user_id, p_step, p_persona, p_interests, p_goals)
  ON CONFLICT (user_id)
  DO UPDATE SET
    step = p_step,
    selected_persona = COALESCE(p_persona, onboarding_progress.selected_persona),
    selected_interests = COALESCE(p_interests, onboarding_progress.selected_interests),
    selected_goals = COALESCE(p_goals, onboarding_progress.selected_goals),
    updated_at = NOW();
END;
$$ LANGUAGE plpgsql;
