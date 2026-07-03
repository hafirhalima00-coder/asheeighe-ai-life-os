import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/composio_integration.dart';
import '../entities/connected_account.dart';

abstract class ComposioRepository {
  Future<Either<Failure, List<ComposioIntegration>>>
      getIntegrations();
  Future<Either<Failure, List<ConnectedAccount>>>
      getConnectedAccounts();
  Future<Either<Failure, String>> connectIntegration(
      String integrationId);
  Future<Either<Failure, void>> disconnectIntegration(
      String accountId);
  Future<Either<Failure, Map<String, dynamic>>> executeAction(
      String accountId, String action,
      {Map<String, dynamic>? params});
  Future<Either<Failure, bool>> getConnectionStatus(
      String accountId);
}
