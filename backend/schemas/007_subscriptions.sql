CREATE TABLE subscriptions (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL UNIQUE,
  planId TEXT NOT NULL DEFAULT 'FREE',
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'canceled', 'trialing', 'past_due', 'incomplete')),
  currentPeriodStart TIMESTAMP WITH TIME ZONE,
  currentPeriodEnd TIMESTAMP WITH TIME ZONE,
  stripeSubscriptionId TEXT,
  stripeCustomerId TEXT,
  cancelAt TIMESTAMP WITH TIME ZONE,
  createdAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updatedAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_subscriptions_userId ON subscriptions(userId);
CREATE INDEX idx_subscriptions_stripeSubscriptionId ON subscriptions(stripeSubscriptionId);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);

CREATE TABLE payments (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  subscriptionId TEXT NOT NULL,
  amount INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'usd',
  status TEXT NOT NULL CHECK (status IN ('succeeded', 'pending', 'failed', 'refunded')),
  stripePaymentId TEXT,
  createdAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payments_userId ON payments(userId);
CREATE INDEX idx_payments_subscriptionId ON payments(subscriptionId);
CREATE INDEX idx_payments_createdAt ON payments(createdAt);

CREATE TABLE usage_tracking (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  feature TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 1,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  createdAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_usage_tracking_unique ON usage_tracking(userId, feature, date);
CREATE INDEX idx_usage_tracking_userId ON usage_tracking(userId);
CREATE INDEX idx_usage_tracking_date ON usage_tracking(date);

-- Seed default free subscription for all users
-- INSERT INTO subscriptions (id, userId, planId, status) SELECT 'free_' || id, id, 'FREE', 'active' FROM users ON CONFLICT DO NOTHING;
