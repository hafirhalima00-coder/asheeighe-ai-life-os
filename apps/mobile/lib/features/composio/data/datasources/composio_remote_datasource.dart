import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/composio_integration_model.dart';
import '../models/connected_account_model.dart';

class ComposioRemoteDataSource {
  final ApiClient _apiClient;

  ComposioRemoteDataSource(this._apiClient);

  Future<List<ComposioIntegrationModel>>
      getIntegrations() async {
    final response =
        await _apiClient.get(ApiConstants.composio);
    return (response.data as List)
        .map((e) => ComposioIntegrationModel.fromJson(
            e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ConnectedAccountModel>>
      getConnectedAccounts() async {
    final response = await _apiClient.get(
        '${ApiConstants.composio}/accounts');
    return (response.data as List)
        .map((e) => ConnectedAccountModel.fromJson(
            e as Map<String, dynamic>))
        .toList();
  }

  Future<String> connectIntegration(
      String integrationId) async {
    final response = await _apiClient.post(
      ApiConstants.composioConnect,
      data: {'integrationId': integrationId},
    );
    return response.data['authUrl'] as String;
  }

  Future<void> disconnectIntegration(
      String accountId) async {
    await _apiClient.post(
      ApiConstants.composioDisconnect,
      data: {'accountId': accountId},
    );
  }

  Future<Map<String, dynamic>> executeAction(
    String accountId,
    String action, {
    Map<String, dynamic>? params,
  }) async {
    final response = await _apiClient.post(
      '${ApiConstants.composio}/action',
      data: {
        'accountId': accountId,
        'action': action,
        'params': params ?? {},
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<bool> getConnectionStatus(
      String accountId) async {
    final response = await _apiClient.get(
      '${ApiConstants.composioStatus}/$accountId',
    );
    return response.data['connected'] as bool;
  }
}
