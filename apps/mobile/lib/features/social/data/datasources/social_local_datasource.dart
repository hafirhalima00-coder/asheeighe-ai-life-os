import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/template_model.dart';

abstract class SocialLocalDataSource {
  // Templates
  Future<List<TemplateModel>> getCachedTemplates(String cacheKey);
  Future<void> cacheTemplates(String cacheKey, List<TemplateModel> templates);
  Future<TemplateModel?> getCachedTemplate(String id);
  Future<void> cacheTemplate(TemplateModel template);
  Future<List<String>> getRecentlyUsedTemplates();
  Future<void> addRecentlyUsedTemplate(String templateId);

  // Referrals
  Future<String?> getCachedReferralCode();
  Future<void> cacheReferralCode(String code);
  Future<String?> getCachedReferralLink();
  Future<void> cacheReferralLink(String link);

  // Achievements
  Future<List<Map<String, dynamic>>> getCachedAchievements();
  Future<void> cacheAchievements(List<Map<String, dynamic>> achievements);

  // General
  Future<void> clearCache();
}

class SocialLocalDataSourceImpl implements SocialLocalDataSource {
  final SharedPreferences _prefs;

  static const String _templatesCachePrefix = 'templates_cache_';
  static const String _recentlyUsedKey = 'recently_used_templates';
  static const String _referralCodeKey = 'referral_code';
  static const String _referralLinkKey = 'referral_link';
  static const String _achievementsCacheKey = 'achievements_cache';
  static const int _cacheExpirationHours = 24;

  SocialLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<List<TemplateModel>> getCachedTemplates(String cacheKey) async {
    final cacheString = _prefs.getString('$_templatesCachePrefix$cacheKey');
    if (cacheString == null) return [];

    final cacheData = json.decode(cacheString) as Map<String, dynamic>;
    final expiry = DateTime.parse(cacheData['expiry'] as String);

    if (DateTime.now().isAfter(expiry)) {
      await _prefs.remove('$_templatesCachePrefix$cacheKey');
      return [];
    }

    final templates = (cacheData['templates'] as List)
        .map((json) => TemplateModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return templates;
  }

  @override
  Future<void> cacheTemplates(String cacheKey, List<TemplateModel> templates) async {
    final cacheData = {
      'expiry': DateTime.now()
          .add(const Duration(hours: _cacheExpirationHours))
          .toIso8601String(),
      'templates': templates.map((t) => t.toJson()).toList(),
    };

    await _prefs.setString(
      '$_templatesCachePrefix$cacheKey',
      json.encode(cacheData),
    );
  }

  @override
  Future<TemplateModel?> getCachedTemplate(String id) async {
    final cacheString = _prefs.getString('template_$id');
    if (cacheString == null) return null;

    final cacheData = json.decode(cacheString) as Map<String, dynamic>;
    final expiry = DateTime.parse(cacheData['expiry'] as String);

    if (DateTime.now().isAfter(expiry)) {
      await _prefs.remove('template_$id');
      return null;
    }

    return TemplateModel.fromJson(cacheData['template'] as Map<String, dynamic>);
  }

  @override
  Future<void> cacheTemplate(TemplateModel template) async {
    final cacheData = {
      'expiry': DateTime.now()
          .add(const Duration(hours: _cacheExpirationHours))
          .toIso8601String(),
      'template': template.toJson(),
    };

    await _prefs.setString('template_${template.id}', json.encode(cacheData));
  }

  @override
  Future<List<String>> getRecentlyUsedTemplates() async {
    return _prefs.getStringList(_recentlyUsedKey) ?? [];
  }

  @override
  Future<void> addRecentlyUsedTemplate(String templateId) async {
    final recentlyUsed = await getRecentlyUsedTemplates();
    recentlyUsed.remove(templateId);
    recentlyUsed.insert(0, templateId);

    // Keep only last 20
    if (recentlyUsed.length > 20) {
      recentlyUsed.removeRange(20, recentlyUsed.length);
    }

    await _prefs.setStringList(_recentlyUsedKey, recentlyUsed);
  }

  @override
  Future<String?> getCachedReferralCode() async {
    return _prefs.getString(_referralCodeKey);
  }

  @override
  Future<void> cacheReferralCode(String code) async {
    await _prefs.setString(_referralCodeKey, code);
  }

  @override
  Future<String?> getCachedReferralLink() async {
    return _prefs.getString(_referralLinkKey);
  }

  @override
  Future<void> cacheReferralLink(String link) async {
    await _prefs.setString(_referralLinkKey, link);
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedAchievements() async {
    final cacheString = _prefs.getString(_achievementsCacheKey);
    if (cacheString == null) return [];

    final cacheData = json.decode(cacheString) as Map<String, dynamic>;
    final expiry = DateTime.parse(cacheData['expiry'] as String);

    if (DateTime.now().isAfter(expiry)) {
      await _prefs.remove(_achievementsCacheKey);
      return [];
    }

    return (cacheData['achievements'] as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> cacheAchievements(List<Map<String, dynamic>> achievements) async {
    final cacheData = {
      'expiry': DateTime.now()
          .add(const Duration(hours: _cacheExpirationHours))
          .toIso8601String(),
      'achievements': achievements,
    };

    await _prefs.setString(_achievementsCacheKey, json.encode(cacheData));
  }

  @override
  Future<void> clearCache() async {
    final keys = _prefs.getKeys.where(
      (key) =>
          key.startsWith(_templatesCachePrefix) ||
          key.startsWith('template_') ||
          key == _recentlyUsedKey ||
          key == _referralCodeKey ||
          key == _referralLinkKey ||
          key == _achievementsCacheKey,
    );

    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
