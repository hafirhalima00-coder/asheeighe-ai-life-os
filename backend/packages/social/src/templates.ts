import { SupabaseClient } from '@supabase/supabase-js';

export interface Template {
  id: string;
  name: string;
  description: string;
  category: TemplateCategory;
  authorId: string;
  authorName: string;
  data: Record<string, unknown>;
  usageCount: number;
  rating: number;
  ratingCount: number;
  isProOnly: boolean;
  previewImages: string[];
  tags: string[];
  createdAt: Date;
  updatedAt: Date;
}

export type TemplateCategory =
  | 'study'
  | 'business'
  | 'wellness'
  | 'islamic'
  | 'personal'
  | 'productivity';

export interface TemplateFilter {
  category?: TemplateCategory;
  search?: string;
  isProOnly?: boolean;
  sortBy?: 'popular' | 'newest' | 'rating';
  limit?: number;
  offset?: number;
}

export interface TemplateUsage {
  id: string;
  templateId: string;
  userId: string;
  usedAt: Date;
}

export class TemplateService {
  constructor(private supabase: SupabaseClient) {}

  async getTemplates(filter: TemplateFilter = {}): Promise<Template[]> {
    let query = this.supabase
      .from('templates')
      .select('*');

    if (filter.category) {
      query = query.eq('category', filter.category);
    }

    if (filter.search) {
      query = query.or(`name.ilike.%${filter.search}%,description.ilike.%${filter.search}%`);
    }

    if (filter.isProOnly !== undefined) {
      query = query.eq('is_pro_only', filter.isProOnly);
    }

    switch (filter.sortBy) {
      case 'popular':
        query = query.order('usage_count', { ascending: false });
        break;
      case 'newest':
        query = query.order('created_at', { ascending: false });
        break;
      case 'rating':
        query = query.order('rating', { ascending: false });
        break;
      default:
        query = query.order('usage_count', { ascending: false });
    }

    query = query.range(
      filter.offset || 0,
      (filter.offset || 0) + (filter.limit || 20) - 1
    );

    const { data, error } = await query;

    if (error) throw error;

    return data.map(this.mapTemplate);
  }

  async getTemplateById(id: string): Promise<Template | null> {
    const { data, error } = await this.supabase
      .from('templates')
      .select('*')
      .eq('id', id)
      .single();

    if (error) throw error;
    if (!data) return null;

    return this.mapTemplate(data);
  }

  async getFeaturedTemplates(): Promise<Template[]> {
    const { data, error } = await this.supabase
      .from('templates')
      .select('*')
      .eq('is_featured', true)
      .order('usage_count', { ascending: false })
      .limit(10);

    if (error) throw error;
    return data.map(this.mapTemplate);
  }

  async getTemplatesByCategory(category: TemplateCategory): Promise<Template[]> {
    const { data, error } = await this.supabase
      .from('templates')
      .select('*')
      .eq('category', category)
      .order('usage_count', { ascending: false })
      .limit(20);

    if (error) throw error;
    return data.map(this.mapTemplate);
  }

  async useTemplate(templateId: string, userId: string): Promise<Record<string, unknown>> {
    const template = await this.getTemplateById(templateId);
    if (!template) throw new Error('Template not found');

    // Check if Pro template and user has access
    if (template.isProOnly) {
      const { data: user } = await this.supabase
        .from('users')
        .select('is_pro')
        .eq('id', userId)
        .single();

      if (!user?.is_pro) {
        throw new Error('Pro subscription required');
      }
    }

    // Record usage
    await this.supabase.from('template_usage').insert({
      template_id: templateId,
      user_id: userId,
      used_at: new Date().toISOString(),
    });

    // Increment usage count
    await this.supabase.rpc('increment_template_usage', { template_id: templateId });

    return template.data;
  }

  async rateTemplate(templateId: string, userId: string, rating: number): Promise<void> {
    if (rating < 1 || rating > 5) {
      throw new Error('Rating must be between 1 and 5');
    }

    const { error } = await this.supabase
      .from('template_ratings')
      .upsert({
        template_id: templateId,
        user_id: userId,
        rating,
      });

    if (error) throw error;

    // Update average rating
    const { data: ratings } = await this.supabase
      .from('template_ratings')
      .select('rating')
      .eq('template_id', templateId);

    if (ratings && ratings.length > 0) {
      const avgRating = ratings.reduce((sum, r) => sum + r.rating, 0) / ratings.length;

      await this.supabase
        .from('templates')
        .update({
          rating: Math.round(avgRating * 10) / 10,
          rating_count: ratings.length,
        })
        .eq('id', templateId);
    }
  }

  async getPopularCategories(): Promise<{ category: TemplateCategory; count: number }[]> {
    const { data, error } = await this.supabase
      .from('templates')
      .select('category')
      .order('usage_count', { ascending: false });

    if (error) throw error;

    const categoryCounts = data.reduce((acc, item) => {
      acc[item.category] = (acc[item.category] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return Object.entries(categoryCounts)
      .map(([category, count]) => ({ category: category as TemplateCategory, count }))
      .sort((a, b) => b.count - a.count);
  }

  private mapTemplate(data: any): Template {
    return {
      id: data.id,
      name: data.name,
      description: data.description,
      category: data.category,
      authorId: data.author_id,
      authorName: data.author_name,
      data: data.data,
      usageCount: data.usage_count,
      rating: data.rating,
      ratingCount: data.rating_count,
      isProOnly: data.is_pro_only,
      previewImages: data.preview_images || [],
      tags: data.tags || [],
      createdAt: new Date(data.created_at),
      updatedAt: new Date(data.updated_at),
    };
  }
}

export const TEMPLATE_CATEGORIES: { id: TemplateCategory; name: string; icon: string; description: string }[] = [
  { id: 'study', name: 'Study', icon: '📚', description: 'Academic planning and learning' },
  { id: 'business', name: 'Business', icon: '💼', description: 'Professional and business tools' },
  { id: 'wellness', name: 'Wellness', icon: '🧘', description: 'Health and self-care' },
  { id: 'islamic', name: 'Islamic', icon: '🕌', description: 'Spiritual growth and worship' },
  { id: 'personal', name: 'Personal', icon: '🎯', description: 'Life organization' },
  { id: 'productivity', name: 'Productivity', icon: '⚡', description: 'Get more done' },
];
