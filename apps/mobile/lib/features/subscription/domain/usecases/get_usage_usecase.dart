import '../repositories/subscription_repository.dart';

class GetUsageUseCase {
  final SubscriptionRepository repository;

  GetUsageUseCase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getUsage();
  }
}
