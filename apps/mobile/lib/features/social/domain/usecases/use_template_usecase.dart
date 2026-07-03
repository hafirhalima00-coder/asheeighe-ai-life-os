import '../repositories/social_repository.dart';

class UseTemplateUseCase {
  final SocialRepository _repository;

  UseTemplateUseCase(this._repository);

  Future<Map<String, dynamic>> call(String templateId) {
    return _repository.useTemplate(templateId);
  }
}

class RateTemplateUseCase {
  final SocialRepository _repository;

  RateTemplateUseCase(this._repository);

  Future<void> call(String templateId, int rating) {
    return _repository.rateTemplate(templateId, rating);
  }
}
