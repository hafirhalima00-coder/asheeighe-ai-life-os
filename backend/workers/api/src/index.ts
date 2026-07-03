import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { HTTPException } from 'hono/http-exception';
import { authMiddleware } from './middleware/auth';
import { rateLimitMiddleware } from './middleware/rate-limit';
import authRoutes from './routes/auth';
import calendarRoutes from './routes/calendar';
import tasksRoutes from './routes/tasks';
import remindersRoutes from './routes/reminders';
import notesRoutes from './routes/notes';
import chatRoutes from './routes/chat';
import composioRoutes from './routes/composio';
import usersRoutes from './routes/users';
import type { AppEnv } from './types';
import { handleError, isAppError } from '@pinkz/core/errors';

const app = new Hono<AppEnv>();

app.use('*', cors({
  origin: ['http://localhost:5173', 'https://pinkz.app'],
  credentials: true,
  allowMethods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowHeaders: ['Content-Type', 'Authorization'],
  exposeHeaders: ['Content-Length', 'X-Request-Id'],
  maxAge: 86400,
}));

app.use('*', rateLimitMiddleware);

app.get('/health', (c) => {
  return c.json({
    success: true,
    message: 'PINKZ API is running',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  });
});

app.route('/auth', authRoutes);

app.use('/api/*', authMiddleware);

app.route('/api/calendar', calendarRoutes);
app.route('/api/tasks', tasksRoutes);
app.route('/api/reminders', remindersRoutes);
app.route('/api/notes', notesRoutes);
app.route('/api/chat', chatRoutes);
app.route('/api/composio', composioRoutes);
app.route('/api/users', usersRoutes);

app.onError((err, c) => {
  if (err instanceof HTTPException) {
    return c.json({ success: false, error: err.message, message: err.message }, err.status);
  }
  const appError = isAppError(err) ? err : handleError(err);
  console.error(`[ERROR] ${appError.code}: ${appError.message}`, appError.details);
  return c.json(appError.toJSON(), appError.statusCode as 400 | 401 | 403 | 404 | 409 | 429 | 500 | 502);
});

app.notFound((c) => {
  return c.json({ success: false, error: 'NOT_FOUND', message: `Route not found: ${c.req.method} ${c.req.path}` }, 404);
});

export default app;
