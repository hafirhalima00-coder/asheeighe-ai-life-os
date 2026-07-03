import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/composio_integration.dart';
import '../../domain/entities/connected_account.dart';
import '../../domain/repositories/composio_repository.dart';
import '../datasources/composio_remote_datasource.dart';

class ComposioRepositoryImpl implements ComposioRepository {
  final ComposioRemoteDataSource _remoteDataSource;

  ComposioRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ComposioIntegration>>>
      getIntegrations() async {
    try {
      final models =
          await _remoteDataSource.getIntegrations();
      return Right(
          models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConnectedAccount>>>
      getConnectedAccounts() async {
    try {
      final models =
          await _remoteDataSource.getConnectedAccounts();
      return Right(
          models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> connectIntegration(
      String integrationId) async {
    try {
      final authUrl = await _remoteDataSource
          .connectIntegration(integrationId);
      return Right(authUrl);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectIntegration(
      String accountId) async {
    try {
      await _remoteDataSource
          .disconnectIntegration(accountId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>>
      executeAction(
    String accountId,
    String action, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await _remoteDataSource.executeAction(
        accountId,
        action,
        params: params,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getConnectionStatus(
      String accountId) async {
    try {
      final status = await _remoteDataSource
          .getConnectionStatus(accountId);
      return Right(status);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
