import '../entities/referral.dart';
import '../repositories/social_repository.dart';

class GenerateReferralCodeUseCase {
  final SocialRepository _repository;

  GenerateReferralCodeUseCase(this._repository);

  Future<String> call() {
    return _repository.generateReferralCode();
  }
}

class GetReferralLinkUseCase {
  final SocialRepository _repository;

  GetReferralLinkUseCase(this._repository);

  Future<String> call() {
    return _repository.getReferralLink();
  }
}

class GetReferralStatsUseCase {
  final SocialRepository _repository;

  GetReferralStatsUseCase(this._repository);

  Future<ReferralStats> call() {
    return _repository.getReferralStats();
  }
}

class ValidateReferralCodeUseCase {
  final SocialRepository _repository;

  ValidateReferralCodeUseCase(this._repository);

  Future<bool> call(String code) {
    return _repository.validateReferralCode(code);
  }
}

class ApplyReferralCodeUseCase {
  final SocialRepository _repository;

  ApplyReferralCodeUseCase(this._repository);

  Future<void> call(String code) {
    return _repository.applyReferralCode(code);
  }
}

class GetShareMessageUseCase {
  final SocialRepository _repository;

  GetShareMessageUseCase(this._repository);

  Future<String> call() {
    return _repository.getShareMessage();
  }
}
