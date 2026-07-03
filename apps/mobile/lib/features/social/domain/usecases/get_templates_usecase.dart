import '../entities/template.dart';
import '../repositories/social_repository.dart';

class GetTemplatesUseCase {
  final SocialRepository _repository;

  GetTemplatesUseCase(this._repository);

  Future<List<Template>> call({
    TemplateCategory? category,
    String? search,
    bool? isProOnly,
    String? sortBy,
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.getTemplates(
      category: category,
      search: search,
      isProOnly: isProOnly,
      sortBy: sortBy,
      limit: limit,
      offset: offset,
    );
  }
}

class GetFeaturedTemplatesUseCase {
  final SocialRepository _repository;

  GetFeaturedTemplatesUseCase(this._repository);

  Future<List<Template>> call() {
    return _repository.getFeaturedTemplates();
  }
}

class GetTemplatesByCategoryUseCase {
  final SocialRepository _repository;

  GetTemplatesByCategoryUseCase(this._repository);

  Future<List<Template>> call(TemplateCategory category) {
    return _repository.getTemplatesByCategory(category);
  }
}

class GetPopularCategoriesUseCase {
  final SocialRepository _repository;

  GetPopularCategoriesUseCase(this._repository);

  Future<List<TemplateCategory>> call() {
    return _repository.getPopularCategories();
  }
}
