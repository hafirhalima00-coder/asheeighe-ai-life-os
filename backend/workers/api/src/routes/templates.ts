import { Hono } from 'hono';
import { TemplateService, TemplateCategory, TemplateFilter } from '@asheeighe/social';

const templates = new Hono();

// Get all templates with filtering
templates.get('/', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));

  const {
    category,
    search,
    isProOnly,
    sortBy,
    limit = '20',
    offset = '0',
  } = c.req.query();

  const filter: TemplateFilter = {
    category: category as TemplateCategory | undefined,
    search,
    isProOnly: isProOnly === 'true' ? true : isProOnly === 'false' ? false : undefined,
    sortBy: sortBy as 'popular' | 'newest' | 'rating' | undefined,
    limit: parseInt(limit, 10),
    offset: parseInt(offset, 10),
  };

  const templates = await templateService.getTemplates(filter);

  return c.json({
    success: true,
    data: templates,
  });
});

// Get featured templates
templates.get('/featured', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));
  const featured = await templateService.getFeaturedTemplates();

  return c.json({
    success: true,
    data: featured,
  });
});

// Get templates by category
templates.get('/category/:category', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));
  const category = c.req.param('category') as TemplateCategory;

  const templates = await templateService.getTemplatesByCategory(category);

  return c.json({
    success: true,
    data: templates,
  });
});

// Get template by ID
templates.get('/:id', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));
  const id = c.req.param('id');

  const template = await templateService.getTemplateById(id);

  if (!template) {
    return c.json({ success: false, error: 'Template not found' }, 404);
  }

  return c.json({
    success: true,
    data: template,
  });
});

// Use a template
templates.post('/:id/use', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));
  const id = c.req.param('id');
  const userId = c.get('userId');

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  try {
    const data = await templateService.useTemplate(id, userId);

    // Track analytics
    await c.get('supabase').rpc('track_analytics_event', {
      p_user_id: userId,
      p_event: 'template_used',
      p_properties: { template_id: id },
    });

    return c.json({
      success: true,
      data,
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

// Rate a template
templates.post('/:id/rate', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));
  const id = c.req.param('id');
  const userId = c.get('userId');
  const { rating } = await c.req.json();

  if (!userId) {
    return c.json({ success: false, error: 'Unauthorized' }, 401);
  }

  if (typeof rating !== 'number' || rating < 1 || rating > 5) {
    return c.json({ success: false, error: 'Rating must be between 1 and 5' }, 400);
  }

  try {
    await templateService.rateTemplate(id, userId, rating);

    return c.json({
      success: true,
      message: 'Rating submitted',
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

// Get popular categories
templates.get('/meta/categories', async (c) => {
  const templateService = new TemplateService(c.get('supabase'));
  const categories = await templateService.getPopularCategories();

  return c.json({
    success: true,
    data: categories,
  });
});

export default templates;
