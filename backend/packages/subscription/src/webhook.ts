import Stripe from 'stripe';
import { Subscription, PlanId, SubscriptionStatus } from './index';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
});

const PRICE_TO_PLAN: Record<string, PlanId> = {
  price_pro_monthly: 'PRO_MONTHLY',
  price_pro_yearly: 'PRO_YEARLY',
  price_premium_monthly: 'PREMIUM_MONTHLY',
  price_premium_yearly: 'PREMIUM_YEARLY',
};

export async function handleStripeWebhook(
  event: Stripe.Event,
  db: any
): Promise<void> {
  switch (event.type) {
    case 'checkout.session.completed':
      await handleCheckoutCompleted(event.data.object as Stripe.Checkout.Session, db);
      break;

    case 'invoice.paid':
      await handleInvoicePaid(event.data.object as Stripe.Invoice, db);
      break;

    case 'invoice.payment_failed':
      await handlePaymentFailed(event.data.object as Stripe.Invoice, db);
      break;

    case 'customer.subscription.updated':
      await handleSubscriptionUpdated(
        event.data.object as Stripe.Subscription,
        db
      );
      break;

    case 'customer.subscription.deleted':
      await handleSubscriptionDeleted(
        event.data.object as Stripe.Subscription,
        db
      );
      break;

    default:
      console.log(`Unhandled webhook event: ${event.type}`);
  }
}

async function handleCheckoutCompleted(
  session: Stripe.Checkout.Session,
  db: any
): Promise<void> {
  const userId = session.metadata?.userId;
  if (!userId) return;

  const subscriptionId = session.subscription as string;
  if (!subscriptionId) return;

  const stripeSubscription = await stripe.subscriptions.retrieve(subscriptionId);
  const priceId = stripeSubscription.items.data[0]?.price.id;
  const planId = PRICE_TO_PLAN[priceId] ?? 'FREE';

  const periodStart = new Date(
    (stripeSubscription as any).current_period_start * 1000
  );
  const periodEnd = new Date(
    (stripeSubscription as any).current_period_end * 1000
  );

  await db.query(
    `INSERT INTO subscriptions (id, userId, planId, status, currentPeriodStart, currentPeriodEnd, stripeSubscriptionId, stripeCustomerId, createdAt, updatedAt)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW())
     ON CONFLICT (userId) DO UPDATE SET
       planId = $3, status = $4, currentPeriodStart = $5, currentPeriodEnd = $6,
       stripeSubscriptionId = $7, stripeCustomerId = $8, updatedAt = NOW()`,
    [
      `sub_${Date.now()}_${userId}`,
      userId,
      planId,
      'active',
      periodStart,
      periodEnd,
      subscriptionId,
      session.customer as string,
    ]
  );

  console.log(`Subscription created for user ${userId}: ${planId}`);
}

async function handleInvoicePaid(
  invoice: Stripe.Invoice,
  db: any
): Promise<void> {
  const subscriptionId = invoice.subscription as string;
  if (!subscriptionId) return;

  const sub = await db.query(
    'SELECT * FROM subscriptions WHERE stripeSubscriptionId = $1',
    [subscriptionId]
  );

  if (sub.rows.length === 0) return;

  const subscription = sub.rows[0];

  await db.query(
    `INSERT INTO payments (id, userId, subscriptionId, amount, currency, status, stripePaymentId, createdAt)
     VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())`,
    [
      `pay_${Date.now()}_${subscription.userId}`,
      subscription.userId,
      subscription.id,
      invoice.amount_paid,
      invoice.currency,
      'succeeded',
      invoice.payment_intent as string,
    ]
  );
}

async function handlePaymentFailed(
  invoice: Stripe.Invoice,
  db: any
): Promise<void> {
  const subscriptionId = invoice.subscription as string;
  if (!subscriptionId) return;

  await db.query(
    `UPDATE subscriptions SET status = 'past_due', updatedAt = NOW()
     WHERE stripeSubscriptionId = $1`,
    [subscriptionId]
  );
}

async function handleSubscriptionUpdated(
  subscription: Stripe.Subscription,
  db: any
): Promise<void> {
  const statusMap: Record<string, SubscriptionStatus> = {
    active: 'active',
    canceled: 'canceled',
    past_due: 'past_due',
    trialing: 'trialing',
    unpaid: 'past_due',
  };

  const status = statusMap[subscription.status] ?? 'active';

  const periodStart = new Date(
    (subscription as any).current_period_start * 1000
  );
  const periodEnd = new Date(
    (subscription as any).current_period_end * 1000
  );

  const cancelAt = subscription.cancel_at
    ? new Date(subscription.cancel_at * 1000)
    : null;

  await db.query(
    `UPDATE subscriptions SET
       status = $1, currentPeriodStart = $2, currentPeriodEnd = $3,
       cancelAt = $4, updatedAt = NOW()
     WHERE stripeSubscriptionId = $5`,
    [status, periodStart, periodEnd, cancelAt, subscription.id]
  );
}

async function handleSubscriptionDeleted(
  subscription: Stripe.Subscription,
  db: any
): Promise<void> {
  await db.query(
    `UPDATE subscriptions SET status = 'canceled', updatedAt = NOW()
     WHERE stripeSubscriptionId = $1`,
    [subscription.id]
  );
}

export async function createCheckoutSession(
  userId: string,
  priceId: string,
  planId: PlanId,
  successUrl: string,
  cancelUrl: string
): Promise<string> {
  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{ price: priceId, quantity: 1 }],
    metadata: { userId, planId },
    success_url: `${successUrl}?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: cancelUrl,
  });

  return session.url!;
}

export async function cancelSubscriptionAtPeriodEnd(
  stripeSubscriptionId: string
): Promise<void> {
  await stripe.subscriptions.update(stripeSubscriptionId, {
    cancel_at_period_end: true,
  });
}

export async function reactivateSubscription(
  stripeSubscriptionId: string
): Promise<void> {
  await stripe.subscriptions.update(stripeSubscriptionId, {
    cancel_at_period_end: false,
  });
}
