import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/template.dart';
import '../../domain/entities/referral.dart';
import '../../domain/entities/shared_achievement.dart';
import '../../domain/repositories/social_repository.dart';
import '../datasources/social_remote_datasource.dart';
import '../datasources/social_local_datasource.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDataSource _remoteDataSource;
  final SocialLocalDataSource _localDataSource;

  SocialRepositoryImpl({
    required SocialRemoteDataSource remoteDataSource,
    required SocialLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Template>> getTemplates({
    TemplateCategory? category,
    String? search,
    bool? isProOnly,
    String? sortBy,
    int limit = 20,
    int offset = 0,
  }) async {
    final cacheKey = 'templates_${category?.name}_${search}_${isProOnly}_$sortBy';

    if (offset == 0) {
      final cached = await _localDataSource.getCachedTemplates(cacheKey);
      if (cached.isNotEmpty) return cached;
    }

    final templates = await _remoteDataSource.getTemplates(
      category: category?.name,
      search: search,
      isProOnly: isProOnly,
      sortBy: sortBy,
      limit: limit,
      offset: offset,
    );

    if (offset == 0) {
      await _localDataSource.cacheTemplates(cacheKey, templates);
    }

    return templates;
  }

  @override
  Future<Template?> getTemplateById(String id) async {
    final cached = await _localDataSource.getCachedTemplate(id);
    if (cached != null) return cached;

    final template = await _remoteDataSource.getTemplateById(id);
    if (template != null) {
      await _localDataSource.cacheTemplate(template);
    }

    return template;
  }

  @override
  Future<List<Template>> getFeaturedTemplates() async {
    const cacheKey = 'featured_templates';
    final cached = await _localDataSource.getCachedTemplates(cacheKey);
    if (cached.isNotEmpty) return cached;

    final templates = await _remoteDataSource.getFeaturedTemplates();
    await _localDataSource.cacheTemplates(cacheKey, templates);

    return templates;
  }

  @override
  Future<List<Template>> getTemplatesByCategory(TemplateCategory category) async {
    final cacheKey = 'category_${category.name}';
    final cached = await _localDataSource.getCachedTemplates(cacheKey);
    if (cached.isNotEmpty) return cached;

    final templates = await _remoteDataSource.getTemplatesByCategory(category.name);
    await _localDataSource.cacheTemplates(cacheKey, templates);

    return templates;
  }

  @override
  Future<Map<String, dynamic>> useTemplate(String templateId) async {
    final data = await _remoteDataSource.useTemplate(templateId);
    await _localDataSource.addRecentlyUsedTemplate(templateId);
    return data;
  }

  @override
  Future<void> rateTemplate(String templateId, int rating) async {
    await _remoteDataSource.rateTemplate(templateId, rating);
  }

  @override
  Future<List<TemplateCategory>> getPopularCategories() async {
    // This could be cached but for simplicity we'll fetch each time
    return TemplateCategory.values;
  }

  @override
  Future<String> generateReferralCode() async {
    final cached = await _localDataSource.getCachedReferralCode();
    if (cached != null) return cached;

    final code = await _remoteDataSource.generateReferralCode();
    await _localDataSource.cacheReferralCode(code);

    return code;
  }

  @override
  Future<String> getReferralLink() async {
    final cached = await _localDataSource.getCachedReferralLink();
    if (cached != null) return cached;

    final link = await _remoteDataSource.getReferralLink();
    await _localDataSource.cacheReferralLink(link);

    return link;
  }

  @override
  Future<ReferralStats> getReferralStats() async {
    final data = await _remoteDataSource.getReferralStats();
    return ReferralStats.fromJson(data);
  }

  @override
  Future<bool> validateReferralCode(String code) async {
    return _remoteDataSource.validateReferralCode(code);
  }

  @override
  Future<void> applyReferralCode(String code) async {
    await _remoteDataSource.applyReferralCode(code);
  }

  @override
  Future<String> getShareMessage() async {
    return _remoteDataSource.getShareMessage();
  }

  @override
  Future<SharedAchievement> createSharedAchievement({
    required AchievementType type,
    required String title,
    required String description,
    AchievementData? data,
  }) async {
    final achievementData = await _remoteDataSource.createSharedAchievement(
      type: type.name,
      title: title,
      description: description,
      data: data?.toJson(),
    );

    return SharedAchievement.fromJson(achievementData);
  }

  @override
  Future<List<SharedAchievement>> getUserAchievements({int limit = 20}) async {
    final cached = await _localDataSource.getCachedAchievements();
    if (cached.isNotEmpty) {
      return cached.map((json) => SharedAchievement.fromJson(json)).toList();
    }

    final achievements = await _remoteDataSource.getUserAchievements(limit: limit);
    await _localDataSource.cacheAchievements(achievements);

    return achievements.map((json) => SharedAchievement.fromJson(json)).toList();
  }

  @override
  Future<SharedAchievement?> getAchievement(String achievementId) async {
    final data = await _remoteDataSource.getAchievement(achievementId);
    return data != null ? SharedAchievement.fromJson(data) : null;
  }

  @override
  Future<void> incrementShareCount(String achievementId) async {
    await _remoteDataSource.incrementShareCount(achievementId);
  }

  @override
  Future<String> getShareUrl({String? achievementId}) async {
    return _remoteDataSource.getShareUrl(achievementId: achievementId);
  }
}
