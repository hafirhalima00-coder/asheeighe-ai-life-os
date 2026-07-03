import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/composio_repository.dart';

class ConnectIntegrationUseCase {
  final ComposioRepository _repository;

  ConnectIntegrationUseCase(this._repository);

  Future<Either<Failure, String>> call(
      String integrationId) {
    return _repository.connectIntegration(integrationId);
  }
}
