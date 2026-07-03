import 'package:dartz/dartz.dart';

import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/errors/failures.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase({required this.repository});

  Future<Either<Failure, DashboardData>> call({
    required String userId,
    required DateTime date,
  }) {
    return repository.getDashboardData(userId: userId, date: date);
  }
}
