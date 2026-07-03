import { Hono } from 'hono';
import { z } from 'zod';
import { zValidator } from '@hono/zod-validator';
import type { AppEnv } from '../types';
import { generateId } from '@pinkz/core/utils';

const notes = new Hono<AppEnv>();

const createNoteSchema = z.object({
  title: z.string().max(500).optional().default(''),
  content: z.string().optional().default(''),
  contentType: z.enum(['markdown', 'plain', 'rich']).optional().default('markdown'),
  tags: z.array(z.string().max(50)).max(20).optional().default([]),
  color: z.string().regex(/^#[0-9a-fA-F]{6}$/).optional().nullable().default(null),
  pinned: z.boolean().optional().default(false),
  notebookId: z.string().optional().nullable().default(null),
});

const updateNoteSchema = createNoteSchema.partial();

notes.get('/', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const notebookId = c.req.query('notebookId');
  const archived = c.req.query('archived');

  if (notebookId !== undefined) {
    const notesList = await db.getNotesByNotebook(userId, notebookId === 'null' ? null : notebookId);
    return c.json({ success: true, data: notesList });
  }

  const filters: Record<string, unknown> = {};
  if (archived !== undefined) filters.archived = archived === 'true' ? 1 : 0;
  else filters.archived = 0;

  const result = await db.findByUserId<Record<string, unknown>>('notes', userId, { filters, orderBy: 'updated_at', orderDir: 'DESC' });
  return c.json({ success: true, ...result });
});

notes.get('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const note = await db.findById<Record<string, unknown>>('notes', id);
  if (!note || note.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Note not found' }, 404);
  }

  return c.json({ success: true, data: note });
});

notes.post('/', zValidator('json', createNoteSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const body = c.req.valid('json');

  const id = generateId();
  await db.insert('notes', {
    id,
    user_id: userId,
    title: body.title,
    content: body.content,
    content_type: body.contentType,
    tags: JSON.stringify(body.tags),
    color: body.color,
    pinned: body.pinned ? 1 : 0,
    notebook_id: body.notebookId,
    sort_order: Date.now(),
  });

  const note = await db.findById('notes', id);
  return c.json({ success: true, message: 'Note created', data: note }, 201);
});

notes.put('/:id', zValidator('json', updateNoteSchema), async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');
  const body = c.req.valid('json');

  const existing = await db.findById<Record<string, unknown>>('notes', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Note not found' }, 404);
  }

  const updateData: Record<string, unknown> = {};
  if (body.title !== undefined) updateData.title = body.title;
  if (body.content !== undefined) updateData.content = body.content;
  if (body.contentType !== undefined) updateData.content_type = body.contentType;
  if (body.tags !== undefined) updateData.tags = JSON.stringify(body.tags);
  if (body.color !== undefined) updateData.color = body.color;
  if (body.pinned !== undefined) updateData.pinned = body.pinned ? 1 : 0;
  if (body.notebookId !== undefined) updateData.notebook_id = body.notebookId;

  await db.update('notes', id, updateData);
  const updated = await db.findById('notes', id);
  return c.json({ success: true, message: 'Note updated', data: updated });
});

notes.delete('/:id', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('notes', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Note not found' }, 404);
  }

  await db.delete('notes', id);
  return c.json({ success: true, message: 'Note deleted' });
});

notes.post('/:id/pin', async (c) => {
  const userId = c.get('userId');
  const db = c.get('db');
  const id = c.req.param('id');

  const existing = await db.findById<Record<string, unknown>>('notes', id);
  if (!existing || existing.user_id !== userId) {
    return c.json({ success: false, error: 'NOT_FOUND', message: 'Note not found' }, 404);
  }

  const pinned = existing.pinned === 1 ? 0 : 1;
  await db.update('notes', id, { pinned });
  return c.json({ success: true, message: pinned ? 'Note pinned' : 'Note unpinned' });
});

export default notes;
