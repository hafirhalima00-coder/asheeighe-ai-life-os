import '../repositories/subscription_repository.dart';

class SubscribeUseCase {
  final SubscriptionRepository repository;

  SubscribeUseCase(this.repository);

  Future<void> call(String planId, {String? paymentMethodId}) async {
    await repository.subscribe(planId, paymentMethodId: paymentMethodId);
  }
}
