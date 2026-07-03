import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/template_model.dart';

abstract class SocialRemoteDataSource {
  // Templates
  Future<List<TemplateModel>> getTemplates({
    String? category,
    String? search,
    bool? isProOnly,
    String? sortBy,
    int limit = 20,
    int offset = 0,
  });

  Future<TemplateModel?> getTemplateById(String id);

  Future<List<TemplateModel>> getFeaturedTemplates();

  Future<List<TemplateModel>> getTemplatesByCategory(String category);

  Future<Map<String, dynamic>> useTemplate(String templateId);

  Future<void> rateTemplate(String templateId, int rating);

  // Referrals
  Future<String> generateReferralCode();

  Future<String> getReferralLink();

  Future<Map<String, dynamic>> getReferralStats();

  Future<bool> validateReferralCode(String code);

  Future<void> applyReferralCode(String code);

  Future<String> getShareMessage();

  // Achievements
  Future<Map<String, dynamic>> createSharedAchievement({
    required String type,
    required String title,
    required String description,
    Map<String, dynamic>? data,
  });

  Future<List<Map<String, dynamic>>> getUserAchievements({int limit = 20});

  Future<Map<String, dynamic>?> getAchievement(String achievementId);

  Future<void> incrementShareCount(String achievementId);

  Future<String> getShareUrl({String? achievementId});
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final SupabaseClient _supabase;
  final http.Client _httpClient;

  SocialRemoteDataSourceImpl({
    required SupabaseClient supabase,
    http.Client? httpClient,
  })  : _supabase = supabase,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<List<TemplateModel>> getTemplates({
    String? category,
    String? search,
    bool? isProOnly,
    String? sortBy,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _supabase.from('templates').select('*');

    if (category != null) {
      query = query.eq('category', category);
    }

    if (search != null && search.isNotEmpty) {
      query = query.or('name.ilike.%$search%,description.ilike.%$search%');
    }

    if (isProOnly != null) {
      query = query.eq('is_pro_only', isProOnly);
    }

    switch (sortBy) {
      case 'popular':
        query = query.order('usage_count', ascending: false);
        break;
      case 'newest':
        query = query.order('created_at', ascending: false);
        break;
      case 'rating':
        query = query.order('rating', ascending: false);
        break;
      default:
        query = query.order('usage_count', ascending: false);
    }

    final data = await query.range(offset, offset + limit - 1);
    return (data as List).map((json) => TemplateModel.fromJson(json)).toList();
  }

  @override
  Future<TemplateModel?> getTemplateById(String id) async {
    final data = await _supabase
        .from('templates')
        .select('*')
        .eq('id', id)
        .single();

    return data != null ? TemplateModel.fromJson(data) : null;
  }

  @override
  Future<List<TemplateModel>> getFeaturedTemplates() async {
    final data = await _supabase
        .from('templates')
        .select('*')
        .eq('is_featured', true)
        .order('usage_count', ascending: false)
        .limit(10);

    return (data as List).map((json) => TemplateModel.fromJson(json)).toList();
  }

  @override
  Future<List<TemplateModel>> getTemplatesByCategory(String category) async {
    final data = await _supabase
        .from('templates')
        .select('*')
        .eq('category', category)
        .order('usage_count', ascending: false)
        .limit(20);

    return (data as List).map((json) => TemplateModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> useTemplate(String templateId) async {
    final data = await _supabase
        .from('templates')
        .select('data')
        .eq('id', templateId)
        .single();

    // Record usage
    await _supabase.from('template_usage').insert({
      'template_id': templateId,
      'user_id': _supabase.auth.currentUser?.id,
      'used_at': DateTime.now().toIso8601String(),
    });

    // Increment usage count
    await _supabase.rpc('increment_template_usage', params: {'template_id': templateId});

    return data['data'] as Map<String, dynamic>;
  }

  @override
  Future<void> rateTemplate(String templateId, int rating) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase.from('template_ratings').upsert({
      'template_id': templateId,
      'user_id': userId,
      'rating': rating,
    });

    // Update average rating
    final ratings = await _supabase
        .from('template_ratings')
        .select('rating')
        .eq('template_id', templateId);

    if (ratings.isNotEmpty) {
      final avgRating = ratings.fold<double>(0, (sum, r) => sum + (r['rating'] as int)) / ratings.length;
      await _supabase
          .from('templates')
          .update({
            'rating': (avgRating * 10).round() / 10,
            'rating_count': ratings.length,
          })
          .eq('id', templateId);
    }
  }

  @override
  Future<String> generateReferralCode() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Check if user already has a code
    final existing = await _supabase
        .from('referral_codes')
        .select('code')
        .eq('user_id', userId)
        .eq('is_active', true)
        .maybeSingle();

    if (existing != null) return existing['code'];

    // Generate unique code
    final code = 'PINKZ-${_generateRandomCode(6)}';

    await _supabase.from('referral_codes').insert({
      'user_id': userId,
      'code': code,
      'is_active': true,
    });

    return code;
  }

  @override
  Future<String> getReferralLink() async {
    final code = await generateReferralCode();
    return 'https://pinkz.app/join/$code';
  }

  @override
  Future<Map<String, dynamic>> getReferralStats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final referrals = await _supabase
        .from('referrals')
        .select('*')
        .eq('referrer_id', userId);

    final completed = (referrals as List).where((r) => r['status'] == 'completed' || r['status'] == 'rewarded').toList();
    final pending = (referrals as List).where((r) => r['status'] == 'pending').toList();
    final rewards = completed
        .where((r) => r['reward'] != null)
        .map((r) => r['reward'])
        .toList();

    return {
      'total_referrals': referrals.length,
      'completed_referrals': completed.length,
      'pending_referrals': pending.length,
      'rewards_earned': rewards,
      'next_milestone': _getNextMilestone(completed.length),
      'progress_to_next_milestone': _getProgressToNextMilestone(completed.length),
    };
  }

  @override
  Future<bool> validateReferralCode(String code) async {
    final data = await _supabase
        .from('referral_codes')
        .select('id')
        .eq('code', code.toUpperCase())
        .eq('is_active', true)
        .maybeSingle();

    return data != null;
  }

  @override
  Future<void> applyReferralCode(String code) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final referralCode = await _supabase
        .from('referral_codes')
        .select('user_id')
        .eq('code', code.toUpperCase())
        .eq('is_active', true)
        .single();

    // Check if user already used a code
    final existingReferral = await _supabase
        .from('referrals')
        .select('id')
        .eq('referee_id', userId)
        .maybeSingle();

    if (existingReferral != null) {
      throw Exception('You have already used a referral code');
    }

    await _supabase.from('referrals').insert({
      'referrer_id': referralCode['user_id'],
      'referee_id': userId,
      'code': code.toUpperCase(),
      'status': 'completed',
    });
  }

  @override
  Future<String> getShareMessage() async {
    final link = await getReferralLink();
    return 'Join me on PINKZ - your AI Life OS! 🌸\n\nUse my referral link: $link\n\nWe both get rewards!';
  }

  @override
  Future<Map<String, dynamic>> createSharedAchievement({
    required String type,
    required String title,
    required String description,
    Map<String, dynamic>? data,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final shareUrl = 'https://pinkz.app/share/$userId/${DateTime.now().millisecondsSinceEpoch}';

    final achievement = await _supabase.from('shared_achievements').insert({
      'user_id': userId,
      'type': type,
      'title': title,
      'description': description,
      'data': data ?? {},
      'share_url': shareUrl,
    }).select().single();

    return achievement;
  }

  @override
  Future<List<Map<String, dynamic>>> getUserAchievements({int limit = 20}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = await _supabase
        .from('shared_achievements')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>?> getAchievement(String achievementId) async {
    final data = await _supabase
        .from('shared_achievements')
        .select('*')
        .eq('id', achievementId)
        .single();

    return data;
  }

  @override
  Future<void> incrementShareCount(String achievementId) async {
    await _supabase.rpc('increment_share_count', params: {'achievement_id': achievementId});
  }

  @override
  Future<String> getShareUrl({String? achievementId}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final baseUrl = 'https://pinkz.app/share/$userId';
    return achievementId != null ? '$baseUrl?achievement=$achievementId' : baseUrl;
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var code = '';
    for (var i = 0; i < length; i++) {
      code += chars[(random + i) % chars.length];
    }
    return code;
  }

  Map<String, dynamic>? _getNextMilestone(int completedCount) {
    const milestones = [
      {'required_referrals': 1, 'title': 'First Friend', 'reward': {'type': 'pro_week', 'value': 7, 'description': '1 week of Pro free'}},
      {'required_referrals': 3, 'title': 'Growing Circle', 'reward': {'type': 'pro_week', 'value': 14, 'description': '2 weeks of Pro free'}},
      {'required_referrals': 5, 'title': 'Popular Host', 'reward': {'type': 'pro_month', 'value': 1, 'description': '1 month of Pro free'}},
      {'required_referrals': 10, 'title': 'Influencer', 'reward': {'type': 'pro_month', 'value': 3, 'description': '3 months of Pro free'}},
      {'required_referrals': 25, 'title': 'PINKZ Ambassador', 'reward': {'type': 'lifetime_pro', 'value': 1, 'description': 'Lifetime Pro access'}},
    ];

    for (final milestone in milestones) {
      if (milestone['required_referrals'] as int > completedCount) {
        return milestone;
      }
    }
    return null;
  }

  double _getProgressToNextMilestone(int completedCount) {
    const milestones = [1, 3, 5, 10, 25];
    for (final milestone in milestones) {
      if (milestone > completedCount) {
        final previousMilestone = milestones.where((m) => m <= completedCount).lastOrNull ?? 0;
        return ((completedCount - previousMilestone) / (milestone - previousMilestone)) * 100;
      }
    }
    return 100;
  }
}
