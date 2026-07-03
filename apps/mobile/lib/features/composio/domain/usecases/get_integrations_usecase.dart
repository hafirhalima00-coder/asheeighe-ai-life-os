import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/composio_integration.dart';
import '../repositories/composio_repository.dart';

class GetIntegrationsUseCase {
  final ComposioRepository _repository;

  GetIntegrationsUseCase(this._repository);

  Future<Either<Failure, List<ComposioIntegration>>> call() {
    return _repository.getIntegrations();
  }
}
