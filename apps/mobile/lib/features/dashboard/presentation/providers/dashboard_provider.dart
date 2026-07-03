import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_config.dart';
import '../../data/datasources/dashboard_local_datasource.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../../../core/network/api_client.dart';

final dashboardRemoteDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardRemoteDataSource(apiClient: apiClient);
});

final dashboardLocalDataSourceProvider =
    Provider<DashboardLocalDataSource>((ref) {
  return DashboardLocalDataSource();
});

final dashboardRepositoryProvider = Provider<DashboardRepositoryImpl>((ref) {
  final remote = ref.watch(dashboardRemoteDataSourceProvider);
  final local = ref.watch(dashboardLocalDataSourceProvider);
  return DashboardRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

final getDashboardDataUseCaseProvider =
    Provider<GetDashboardDataUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetDashboardDataUseCase(repository: repository);
});

enum DashboardStatus { initial, loading, loaded, error, refreshing }

class DashboardState {
  final DashboardStatus status;
  final DashboardData? data;
  final String? errorMessage;
  final String userName;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.data,
    this.errorMessage,
    this.userName = 'there',
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? data,
    String? errorMessage,
    String? userName,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
      userName: userName ?? this.userName,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardDataUseCase _getDashboardData;

  DashboardNotifier({required GetDashboardDataUseCase getDashboardData})
      : _getDashboardData = getDashboardData,
        super(const DashboardState());

  Future<void> loadDashboard() async {
    state = state.copyWith(status: DashboardStatus.loading);

    final result = await _getDashboardData(
      userId: AppConfig.defaultUserId,
      date: DateTime.now(),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          status: DashboardStatus.loaded,
          data: data,
        );
      },
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(status: DashboardStatus.refreshing);

    final result = await _getDashboardData(
      userId: AppConfig.defaultUserId,
      date: DateTime.now(),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          status: DashboardStatus.loaded,
          data: data,
        );
      },
    );
  }

  void updateUserName(String name) {
    state = state.copyWith(userName: name);
  }

  void updateTaskStatus(String taskId, bool isCompleted) {
    if (state.data == null) return;
    final tasks = state.data!.pendingTasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isCompleted: isCompleted);
      }
      return task;
    }).toList();
    state = state.copyWith(
      data: state.data!.copyWith(pendingTasks: tasks),
    );
  }
}
