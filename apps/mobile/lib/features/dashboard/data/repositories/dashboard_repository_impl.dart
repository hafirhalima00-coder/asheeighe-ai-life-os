import 'package:dartz/dartz.dart';

import '../../../dashboard/domain/entities/dashboard_data.dart';
import '../../../dashboard/domain/repositories/dashboard_repository.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../datasources/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final cached = await localDataSource.getCachedDashboardData();
      if (cached != null) {
        return Right(cached);
      }

      final remote = await remoteDataSource.getDashboardData(
        userId: userId,
        date: date,
      );

      await localDataSource.cacheDashboardData(remote);
      return Right(remote);
    } catch (e) {
      try {
        final cached = await localDataSource.getCachedDashboardData();
        if (cached != null) {
          return Right(cached);
        }
      } catch (_) {}

      return Left(
        ServerFailure(message: 'Failed to load dashboard data.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> refresh() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to refresh cache.'));
    }
  }
}
