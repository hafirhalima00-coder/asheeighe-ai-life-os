import { Hono } from 'hono';
import { ReferralService } from '@pinkz/social';

const referrals = new Hono();

// Generate referral code
referrals.post('/generate', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  const code = await referralService.generateReferralCode(userId);

  return c.json({
    success: true,
    data: code,
  });
});

// Get user's referral code
referrals.get('/code', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  const code = await referralService.getUserReferralCode(userId);

  return c.json({
    success: true,
    data: code,
  });
});

// Get referral link
referrals.get('/link', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  const link = await referralService.getReferralLink(userId);

  return c.json({
    success: true,
    data: { link },
  });
});

// Get referral stats
referrals.get('/stats', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  const stats = await referralService.getReferralStats(userId);

  return c.json({
    success: true,
    data: stats,
  });
});

// Validate referral code
referrals.post('/validate', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const { code } = await c.req.json();

  if (!code) {
    return c.json({ success: false, error: 'Code is required' }, 400);
  }

  const isValid = await referralService.validateReferralCode(code);

  return c.json({
    success: true,
    data: { isValid },
  });
});

// Apply referral code
referrals.post('/apply', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');
  const { code } = await c.req.json();

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  if (!code) {
    return c.json({ success: false, error: 'Code is required' }, 400);
  }

  try {
    const referral = await referralService.applyReferralCode(userId, code);

    // Track analytics
    await c.get('supabase').rpc('track_analytics_event', {
      p_user_id: userId,
      p_event: 'referral_applied',
      p_properties: { code, referrer_id: referral.referrerId },
    });

    return c.json({
      success: true,
      data: referral,
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

// Get share message
referrals.get('/share-message', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  const message = await referralService.getShareMessage(userId);

  return c.json({
    success: true,
    data: { message },
  });
});

// Get referred users
referrals.get('/referred', async (c) => {
  const referralService = new ReferralService(c.get('supabase'));
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  const users = await referralService.getReferredUsers(userId);

  return c.json({
    success: true,
    data: users,
  });
});

// Track referral sent (for analytics)
referrals.post('/track-sent', async (c) => {
  const userId = c.get('userId');
  const { platform, message } = await c.req.json();

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  // Track analytics
  await c.get('supabase').rpc('track_analytics_event', {
    p_user_id: userId,
    p_event: 'referral_sent',
    p_properties: { platform, message },
  });

  return c.json({
    success: true,
    message: 'Tracked',
  });
});

export default referrals;
