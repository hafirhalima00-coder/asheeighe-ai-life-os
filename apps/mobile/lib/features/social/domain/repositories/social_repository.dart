import '../entities/template.dart';
import '../entities/referral.dart';
import '../entities/shared_achievement.dart';

abstract class SocialRepository {
  // Templates
  Future<List<Template>> getTemplates({
    TemplateCategory? category,
    String? search,
    bool? isProOnly,
    String? sortBy,
    int limit = 20,
    int offset = 0,
  });

  Future<Template?> getTemplateById(String id);

  Future<List<Template>> getFeaturedTemplates();

  Future<List<Template>> getTemplatesByCategory(TemplateCategory category);

  Future<Map<String, dynamic>> useTemplate(String templateId);

  Future<void> rateTemplate(String templateId, int rating);

  Future<List<TemplateCategory>> getPopularCategories();

  // Referrals
  Future<String> generateReferralCode();

  Future<String> getReferralLink();

  Future<ReferralStats> getReferralStats();

  Future<bool> validateReferralCode(String code);

  Future<void> applyReferralCode(String code);

  Future<String> getShareMessage();

  // Achievements
  Future<SharedAchievement> createSharedAchievement({
    required AchievementType type,
    required String title,
    required String description,
    AchievementData? data,
  });

  Future<List<SharedAchievement>> getUserAchievements({int limit = 20});

  Future<SharedAchievement?> getAchievement(String achievementId);

  Future<void> incrementShareCount(String achievementId);

  Future<String> getShareUrl({String? achievementId});
}
