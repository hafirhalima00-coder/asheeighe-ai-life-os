import '../entities/subscription_plan.dart';
import '../repositories/subscription_repository.dart';

class GetPlansUseCase {
  final SubscriptionRepository repository;

  GetPlansUseCase(this.repository);

  Future<List<SubscriptionPlan>> call() async {
    return await repository.getPlans();
  }
}
