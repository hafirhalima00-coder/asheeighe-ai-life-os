import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/composio_repository.dart';

class DisconnectIntegrationUseCase {
  final ComposioRepository _repository;

  DisconnectIntegrationUseCase(this._repository);

  Future<Either<Failure, void>> call(String accountId) {
    return _repository.disconnectIntegration(accountId);
  }
}
