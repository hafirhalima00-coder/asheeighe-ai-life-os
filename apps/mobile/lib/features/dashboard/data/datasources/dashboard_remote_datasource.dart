import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_data_model.dart';

class DashboardRemoteDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<DashboardDataModel> getDashboardData({
    required String userId,
    required DateTime date,
  }) async {
    final response = await _apiClient.get(
      '${ApiConstants.profile}/$userId/dashboard',
      queryParameters: {
        'date': date.toIso8601String().split('T').first,
      },
    );
    return DashboardDataModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
