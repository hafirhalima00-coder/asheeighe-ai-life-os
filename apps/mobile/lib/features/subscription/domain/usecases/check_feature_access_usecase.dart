import '../repositories/subscription_repository.dart';

class CheckFeatureAccessUseCase {
  final SubscriptionRepository repository;

  CheckFeatureAccessUseCase(this.repository);

  Future<bool> call(String feature) async {
    return await repository.checkFeatureAccess(feature);
  }
}
