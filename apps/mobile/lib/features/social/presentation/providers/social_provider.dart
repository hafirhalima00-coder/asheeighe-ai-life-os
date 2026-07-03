import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/template.dart';
import '../../domain/entities/referral.dart';
import '../../domain/entities/shared_achievement.dart';
import '../../domain/repositories/social_repository.dart';
import '../../domain/usecases/get_templates_usecase.dart';
import '../../domain/usecases/use_template_usecase.dart';
import '../../domain/usecases/get_referral_info_usecase.dart';
import '../../domain/usecases/share_achievement_usecase.dart';

// Repository Provider
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  throw UnimplementedError('SocialRepository must be provided');
});

// Use Case Providers
final getTemplatesUseCaseProvider = Provider<GetTemplatesUseCase>((ref) {
  return GetTemplatesUseCase(ref.watch(socialRepositoryProvider));
});

final getFeaturedTemplatesUseCaseProvider = Provider<GetFeaturedTemplatesUseCase>((ref) {
  return GetFeaturedTemplatesUseCase(ref.watch(socialRepositoryProvider));
});

final useTemplateUseCaseProvider = Provider<UseTemplateUseCase>((ref) {
  return UseTemplateUseCase(ref.watch(socialRepositoryProvider));
});

final rateTemplateUseCaseProvider = Provider<RateTemplateUseCase>((ref) {
  return RateTemplateUseCase(ref.watch(socialRepositoryProvider));
});

final generateReferralCodeUseCaseProvider = Provider<GenerateReferralCodeUseCase>((ref) {
  return GenerateReferralCodeUseCase(ref.watch(socialRepositoryProvider));
});

final getReferralStatsUseCaseProvider = Provider<GetReferralStatsUseCase>((ref) {
  return GetReferralStatsUseCase(ref.watch(socialRepositoryProvider));
});

final applyReferralCodeUseCaseProvider = Provider<ApplyReferralCodeUseCase>((ref) {
  return ApplyReferralCodeUseCase(ref.watch(socialRepositoryProvider));
});

final getShareMessageUseCaseProvider = Provider<GetShareMessageUseCase>((ref) {
  return GetShareMessageUseCase(ref.watch(socialRepositoryProvider));
});

final createSharedAchievementUseCaseProvider = Provider<CreateSharedAchievementUseCase>((ref) {
  return CreateSharedAchievementUseCase(ref.watch(socialRepositoryProvider));
});

final getUserAchievementsUseCaseProvider = Provider<GetUserAchievementsUseCase>((ref) {
  return GetUserAchievementsUseCase(ref.watch(socialRepositoryProvider));
});

// Social Notifier
class SocialState {
  final List<Template> templates;
  final List<Template> featuredTemplates;
  final TemplateCategory? selectedCategory;
  final String? searchQuery;
  final bool isLoadingTemplates;
  final bool isLoadingFeatured;
  final String? templateError;

  final ReferralStats? referralStats;
  final String? referralCode;
  final String? referralLink;
  final bool isLoadingReferrals;
  final String? referralError;

  final List<SharedAchievement> achievements;
  final bool isLoadingAchievements;
  final String? achievementError;

  const SocialState({
    this.templates = const [],
    this.featuredTemplates = const [],
    this.selectedCategory,
    this.searchQuery,
    this.isLoadingTemplates = false,
    this.isLoadingFeatured = false,
    this.templateError,
    this.referralStats,
    this.referralCode,
    this.referralLink,
    this.isLoadingReferrals = false,
    this.referralError,
    this.achievements = const [],
    this.isLoadingAchievements = false,
    this.achievementError,
  });

  SocialState copyWith({
    List<Template>? templates,
    List<Template>? featuredTemplates,
    TemplateCategory? selectedCategory,
    String? searchQuery,
    bool? isLoadingTemplates,
    bool? isLoadingFeatured,
    String? templateError,
    ReferralStats? referralStats,
    String? referralCode,
    String? referralLink,
    bool? isLoadingReferrals,
    String? referralError,
    List<SharedAchievement>? achievements,
    bool? isLoadingAchievements,
    String? achievementError,
  }) {
    return SocialState(
      templates: templates ?? this.templates,
      featuredTemplates: featuredTemplates ?? this.featuredTemplates,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingTemplates: isLoadingTemplates ?? this.isLoadingTemplates,
      isLoadingFeatured: isLoadingFeatured ?? this.isLoadingFeatured,
      templateError: templateError,
      referralStats: referralStats ?? this.referralStats,
      referralCode: referralCode ?? this.referralCode,
      referralLink: referralLink ?? this.referralLink,
      isLoadingReferrals: isLoadingReferrals ?? this.isLoadingReferrals,
      referralError: referralError,
      achievements: achievements ?? this.achievements,
      isLoadingAchievements: isLoadingAchievements ?? this.isLoadingAchievements,
      achievementError: achievementError,
    );
  }
}

class SocialNotifier extends StateNotifier<SocialState> {
  final GetTemplatesUseCase _getTemplatesUseCase;
  final GetFeaturedTemplatesUseCase _getFeaturedTemplatesUseCase;
  final UseTemplateUseCase _useTemplateUseCase;
  final RateTemplateUseCase _rateTemplateUseCase;
  final GenerateReferralCodeUseCase _generateReferralCodeUseCase;
  final GetReferralStatsUseCase _getReferralStatsUseCase;
  final ApplyReferralCodeUseCase _applyReferralCodeUseCase;
  final GetShareMessageUseCase _getShareMessageUseCase;
  final CreateSharedAchievementUseCase _createSharedAchievementUseCase;
  final GetUserAchievementsUseCase _getUserAchievementsUseCase;

  SocialNotifier({
    required GetTemplatesUseCase getTemplatesUseCase,
    required GetFeaturedTemplatesUseCase getFeaturedTemplatesUseCase,
    required UseTemplateUseCase useTemplateUseCase,
    required RateTemplateUseCase rateTemplateUseCase,
    required GenerateReferralCodeUseCase generateReferralCodeUseCase,
    required GetReferralStatsUseCase getReferralStatsUseCase,
    required ApplyReferralCodeUseCase applyReferralCodeUseCase,
    required GetShareMessageUseCase getShareMessageUseCase,
    required CreateSharedAchievementUseCase createSharedAchievementUseCase,
    required GetUserAchievementsUseCase getUserAchievementsUseCase,
  })  : _getTemplatesUseCase = getTemplatesUseCase,
        _getFeaturedTemplatesUseCase = getFeaturedTemplatesUseCase,
        _useTemplateUseCase = useTemplateUseCase,
        _rateTemplateUseCase = rateTemplateUseCase,
        _generateReferralCodeUseCase = generateReferralCodeUseCase,
        _getReferralStatsUseCase = getReferralStatsUseCase,
        _applyReferralCodeUseCase = applyReferralCodeUseCase,
        _getShareMessageUseCase = getShareMessageUseCase,
        _createSharedAchievementUseCase = createSharedAchievementUseCase,
        _getUserAchievementsUseCase = getUserAchievementsUseCase,
        super(const SocialState());

  // Template Methods
  Future<void> loadTemplates({
    TemplateCategory? category,
    String? search,
    bool? isProOnly,
    String? sortBy,
  }) async {
    state = state.copyWith(isLoadingTemplates: true, templateError: null);

    try {
      final templates = await _getTemplatesUseCase(
        category: category,
        search: search,
        isProOnly: isProOnly,
        sortBy: sortBy,
      );

      state = state.copyWith(
        templates: templates,
        isLoadingTemplates: false,
        selectedCategory: category,
        searchQuery: search,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
        templateError: e.toString(),
      );
    }
  }

  Future<void> loadFeaturedTemplates() async {
    state = state.copyWith(isLoadingFeatured: true);

    try {
      final templates = await _getFeaturedTemplatesUseCase();
      state = state.copyWith(
        featuredTemplates: templates,
        isLoadingFeatured: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingFeatured: false);
    }
  }

  Future<void> selectCategory(TemplateCategory? category) async {
    state = state.copyWith(selectedCategory: category);
    await loadTemplates(category: category, search: state.searchQuery);
  }

  Future<void> searchTemplates(String query) async {
    state = state.copyWith(searchQuery: query);
    await loadTemplates(category: state.selectedCategory, search: query);
  }

  Future<Map<String, dynamic>> useTemplate(String templateId) async {
    try {
      return await _useTemplateUseCase(templateId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rateTemplate(String templateId, int rating) async {
    try {
      await _rateTemplateUseCase(templateId, rating);
      await loadTemplates(
        category: state.selectedCategory,
        search: state.searchQuery,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Referral Methods
  Future<void> loadReferralInfo() async {
    state = state.copyWith(isLoadingReferrals: true, referralError: null);

    try {
      final stats = await _getReferralStatsUseCase();
      final code = await _generateReferralCodeUseCase();
      final link = await _getShareMessageUseCase();

      state = state.copyWith(
        referralStats: stats,
        referralCode: code,
        referralLink: link,
        isLoadingReferrals: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingReferrals: false,
        referralError: e.toString(),
      );
    }
  }

  Future<void> applyReferralCode(String code) async {
    state = state.copyWith(isLoadingReferrals: true, referralError: null);

    try {
      await _applyReferralCodeUseCase(code);
      await loadReferralInfo();
    } catch (e) {
      state = state.copyWith(
        isLoadingReferrals: false,
        referralError: e.toString(),
      );
    }
  }

  // Achievement Methods
  Future<void> loadAchievements() async {
    state = state.copyWith(isLoadingAchievements: true, achievementError: null);

    try {
      final achievements = await _getUserAchievementsUseCase();
      state = state.copyWith(
        achievements: achievements,
        isLoadingAchievements: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingAchievements: false,
        achievementError: e.toString(),
      );
    }
  }

  Future<SharedAchievement> createAchievement({
    required AchievementType type,
    required String title,
    required String description,
    AchievementData? data,
  }) async {
    try {
      final achievement = await _createSharedAchievementUseCase(
        type: type,
        title: title,
        description: description,
        data: data,
      );

      state = state.copyWith(
        achievements: [achievement, ...state.achievements],
      );

      return achievement;
    } catch (e) {
      rethrow;
    }
  }
}

final socialProvider = StateNotifierProvider<SocialNotifier, SocialState>((ref) {
  return SocialNotifier(
    getTemplatesUseCase: ref.watch(getTemplatesUseCaseProvider),
    getFeaturedTemplatesUseCase: ref.watch(getFeaturedTemplatesUseCaseProvider),
    useTemplateUseCase: ref.watch(useTemplateUseCaseProvider),
    rateTemplateUseCase: ref.watch(rateTemplateUseCaseProvider),
    generateReferralCodeUseCase: ref.watch(generateReferralCodeUseCaseProvider),
    getReferralStatsUseCase: ref.watch(getReferralStatsUseCaseProvider),
    applyReferralCodeUseCase: ref.watch(applyReferralCodeUseCaseProvider),
    getShareMessageUseCase: ref.watch(getShareMessageUseCaseProvider),
    createSharedAchievementUseCase: ref.watch(createSharedAchievementUseCaseProvider),
    getUserAchievementsUseCase: ref.watch(getUserAchievementsUseCaseProvider),
  );
});
