import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/composio_integration.dart';
import '../providers/composio_provider.dart';
import '../widgets/connection_status_badge.dart';
import '../widgets/integration_card.dart';

class ComposioScreen extends ConsumerStatefulWidget {
  const ComposioScreen({super.key});

  @override
  ConsumerState<ComposioScreen> createState() =>
      _ComposioScreenState();
}

class _ComposioScreenState
    extends ConsumerState<ComposioScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(composioProvider);
    final notifier = ref.read(composioProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations'),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primary))
          : RefreshIndicator(
              onRefresh: () =>
                  notifier.loadIntegrations(),
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(
                    AppConstants.paddingMd),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    if (state.connectedAccounts
                        .isNotEmpty) ...[
                      const Text(
                        'Connected Accounts',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.connectedAccounts
                          .map((account) => Card(
                                elevation: 0,
                                color: Colors.white,
                                margin: const EdgeInsets
                                    .only(bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                                child: ListTile(
                                  leading:
                                      ConnectionStatusBadge(
                                    isConnected:
                                        account.isActive,
                                  ),
                                  title: Text(
                                    account
                                        .integrationName,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    account.isActive
                                        ? 'Connected'
                                        : account.status,
                                    style: TextStyle(
                                      color: account
                                              .isActive
                                          ? AppTheme.success
                                          : AppTheme.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing:
                                      PopupMenuButton<String>(
                                    icon:
                                        const Icon(Icons.more_vert),
                                    onSelected: (v) {
                                      if (v ==
                                          'disconnect') {
                                        _showDisconnectDialog(
                                            account
                                                .integrationName,
                                            account.id);
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                        value:
                                            'disconnect',
                                        child: Text(
                                            'Disconnect'),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                      const SizedBox(height: 24),
                    ],
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            'Search integrations...',
                        prefixIcon:
                            const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16),
                      ),
                      onChanged: (v) =>
                          notifier.updateSearch(v),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Available Integrations',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._getFilteredIntegrations(state)
                        .map((integration) =>
                            IntegrationCard(
                              integration: integration,
                              onConnect: () => notifier
                                  .connect(
                                      integration.id),
                              onDisconnect: () =>
                                  _showDisconnectDialog(
                                integration.name,
                                integration.id,
                              ),
                            )),
                    if (_getFilteredIntegrations(state)
                        .isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 40),
                          child: Text(
                            'No integrations found',
                            style: TextStyle(
                              color:
                                  AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  List<ComposioIntegration>
      _getFilteredIntegrations(ComposioState state) {
    final query = state.searchQuery.toLowerCase();
    if (query.isEmpty) return state.integrations;
    return state.integrations
        .where((i) =>
            i.name.toLowerCase().contains(query) ||
            i.description.toLowerCase().contains(query) ||
            i.category.toLowerCase().contains(query))
        .toList();
  }

  void _showDisconnectDialog(
      String name, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect Integration'),
        content: Text(
            'Are you sure you want to disconnect $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(composioProvider.notifier)
                  .disconnect(id);
              Navigator.pop(ctx);
            },
            child: const Text('Disconnect',
                style:
                    TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
