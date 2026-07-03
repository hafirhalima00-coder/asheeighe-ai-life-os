import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/composio_integration.dart';
import '../providers/composio_provider.dart';
import '../widgets/connection_status_badge.dart';

class IntegrationDetailScreen
    extends ConsumerWidget {
  final ComposioIntegration integration;

  const IntegrationDetailScreen(
      {super.key, required this.integration});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier =
        ref.read(composioProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(integration.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
            AppConstants.paddingMd),
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getCategoryIcon(
                            integration.category),
                        color: AppTheme.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      integration.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      integration.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConnectionStatusBadge(
                      isConnected:
                          integration.isConnected,
                      large: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                        16, 16, 16, 8),
                    child: Align(
                      alignment:
                          Alignment.centerLeft,
                      child: Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  _buildDetailRow(
                      'Category', integration.category),
                  _buildDetailRow(
                      'Auth Type',
                      integration.authType
                          .toUpperCase()),
                  if (integration.connectedAt !=
                      null)
                    _buildDetailRow(
                      'Connected',
                      DateFormat('MMM dd, yyyy')
                          .format(integration.connectedAt!),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                        16, 16, 16, 8),
                    child: Text(
                      'Available Actions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  ..._getSampleActions(
                          integration.category)
                      .map((action) => ListTile(
                            leading: const Icon(
                                Icons.play_circle_outline,
                                color:
                                    AppTheme.primary),
                            title: Text(action),
                            dense: true,
                            contentPadding:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal: 16),
                          )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (integration.isConnected) {
                    _showDisconnectDialog(
                        context, notifier);
                  } else {
                    notifier
                        .connect(integration.id);
                  }
                },
                icon: Icon(integration.isConnected
                    ? Icons.link_off
                    : Icons.link),
                label: Text(integration.isConnected
                    ? 'Disconnect'
                    : 'Connect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      integration.isConnected
                          ? AppTheme.error
                          : AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14)),
          Text(value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.textPrimary,
              )),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return Icons.checklist;
      case 'communication':
        return Icons.chat;
      case 'storage':
        return Icons.cloud;
      case 'calendar':
        return Icons.calendar_month;
      case 'finance':
        return Icons.account_balance;
      case 'social':
        return Icons.people;
      case 'developer':
        return Icons.code;
      default:
        return Icons.integration_instructions;
    }
  }

  List<String> _getSampleActions(
      String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return [
          'Create Task',
          'List Tasks',
          'Update Task'
        ];
      case 'communication':
        return [
          'Send Message',
          'List Channels',
          'Create Channel'
        ];
      case 'storage':
        return [
          'List Files',
          'Upload File',
          'Create Folder'
        ];
      case 'calendar':
        return [
          'List Events',
          'Create Event',
          'Update Event'
        ];
      default:
        return [
          'Execute Action',
          'Get Status',
          'Fetch Data'
        ];
    }
  }

  void _showDisconnectDialog(BuildContext context,
      ComposioNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect Integration'),
        content: Text(
            'Are you sure you want to disconnect ${integration.name}?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx),
            child:
                const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.disconnect(
                  integration.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Disconnect',
                style: TextStyle(
                    color:
                        AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
