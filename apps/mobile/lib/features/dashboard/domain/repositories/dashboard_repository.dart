import 'package:dartz/dartz.dart';

import '../entities/dashboard_data.dart';
import '../../../../core/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String userId,
    required DateTime date,
  });

  Future<Either<Failure, void>> refresh();
}
