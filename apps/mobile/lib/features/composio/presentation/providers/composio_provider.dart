import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/composio_integration.dart';
import '../../domain/entities/connected_account.dart';
import '../../domain/usecases/connect_integration_usecase.dart';
import '../../domain/usecases/disconnect_integration_usecase.dart';
import '../../domain/usecases/get_integrations_usecase.dart';

class ComposioNotifier extends StateNotifier<ComposioState> {
  final GetIntegrationsUseCase _getIntegrations;
  final ConnectIntegrationUseCase _connectIntegration;
  final DisconnectIntegrationUseCase _disconnectIntegration;

  ComposioNotifier({
    required GetIntegrationsUseCase getIntegrations,
    required ConnectIntegrationUseCase connectIntegration,
    required DisconnectIntegrationUseCase disconnectIntegration,
  })  : _getIntegrations = getIntegrations,
        _connectIntegration = connectIntegration,
        _disconnectIntegration = disconnectIntegration,
        super(ComposioState());

  Future<void> loadIntegrations() async {
    state = state.copyWith(isLoading: true);
    final result = await _getIntegrations();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (integrations) {
        state = state.copyWith(
          isLoading: false,
          integrations: integrations,
          connectedAccounts: integrations
              .where((i) => i.isConnected)
              .map((i) => ConnectedAccount(
                    id: i.id,
                    integrationId: i.id,
                    integrationName: i.name,
                    status: 'active',
                    connectedAt: i.connectedAt,
                  ))
              .toList(),
        );
      },
    );
  }

  Future<void> connect(String integrationId) async {
    state = state.copyWith(isConnecting: true);
    final result =
        await _connectIntegration(integrationId);
    result.fold(
      (failure) => state = state.copyWith(
        isConnecting: false,
        error: failure.message,
      ),
      (authUrl) {
        state = state.copyWith(
          isConnecting: false,
          authUrl: authUrl,
        );
        loadIntegrations();
      },
    );
  }

  Future<void> disconnect(String accountId) async {
    final result =
        await _disconnectIntegration(accountId);
    result.fold(
      (failure) => state =
          state.copyWith(error: failure.message),
      (_) => loadIntegrations(),
    );
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearError() => state = state.copyWith(error: null);

  void clearAuthUrl() =>
      state = state.copyWith(authUrl: null);
}

class ComposioState {
  final bool isLoading;
  final bool isConnecting;
  final String? error;
  final String? authUrl;
  final String searchQuery;
  final List<ComposioIntegration> integrations;
  final List<ConnectedAccount> connectedAccounts;

  const ComposioState({
    this.isLoading = false,
    this.isConnecting = false,
    this.error,
    this.authUrl,
    this.searchQuery = '',
    this.integrations = const [],
    this.connectedAccounts = const [],
  });

  ComposioState copyWith({
    bool? isLoading,
    bool? isConnecting,
    String? error,
    String? authUrl,
    String? searchQuery,
    List<ComposioIntegration>? integrations,
    List<ConnectedAccount>? connectedAccounts,
  }) {
    return ComposioState(
      isLoading: isLoading ?? this.isLoading,
      isConnecting: isConnecting ?? this.isConnecting,
      error: error,
      authUrl: authUrl,
      searchQuery: searchQuery ?? this.searchQuery,
      integrations: integrations ?? this.integrations,
      connectedAccounts:
          connectedAccounts ?? this.connectedAccounts,
    );
  }
}
