import '../entities/shared_achievement.dart';
import '../repositories/social_repository.dart';

class CreateSharedAchievementUseCase {
  final SocialRepository _repository;

  CreateSharedAchievementUseCase(this._repository);

  Future<SharedAchievement> call({
    required AchievementType type,
    required String title,
    required String description,
    AchievementData? data,
  }) {
    return _repository.createSharedAchievement(
      type: type,
      title: title,
      description: description,
      data: data,
    );
  }
}

class GetUserAchievementsUseCase {
  final SocialRepository _repository;

  GetUserAchievementsUseCase(this._repository);

  Future<List<SharedAchievement>> call({int limit = 20}) {
    return _repository.getUserAchievements(limit: limit);
  }
}

class GetAchievementUseCase {
  final SocialRepository _repository;

  GetAchievementUseCase(this._repository);

  Future<SharedAchievement?> call(String achievementId) {
    return _repository.getAchievement(achievementId);
  }
}

class IncrementShareCountUseCase {
  final SocialRepository _repository;

  IncrementShareCountUseCase(this._repository);

  Future<void> call(String achievementId) {
    return _repository.incrementShareCount(achievementId);
  }
}

class GetShareUrlUseCase {
  final SocialRepository _repository;

  GetShareUrlUseCase(this._repository);

  Future<String> call({String? achievementId}) {
    return _repository.getShareUrl(achievementId: achievementId);
  }
}
