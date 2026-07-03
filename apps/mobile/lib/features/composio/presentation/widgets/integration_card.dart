import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/composio_integration.dart';
import 'connection_status_badge.dart';

class IntegrationCard extends StatelessWidget {
  final ComposioIntegration integration;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  const IntegrationCard({
    super.key,
    required this.integration,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getCategoryColor(
                        integration.category)
                    .withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(
                    integration.category),
                color: _getCategoryColor(
                    integration.category),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          integration.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (integration.isConnected)
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.success
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                                    8),
                          ),
                          child: const Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(Icons.check,
                                  size: 12,
                                  color:
                                      AppTheme.success),
                              SizedBox(width: 4),
                              Text(
                                'Connected',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w500,
                                  color: AppTheme
                                      .success,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    integration.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color:
                          AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: integration.isConnected
                    ? onDisconnect
                    : onConnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      integration.isConnected
                          ? AppTheme.error
                              .withOpacity(0.1)
                          : AppTheme.primary,
                  foregroundColor:
                      integration.isConnected
                          ? AppTheme.error
                          : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets
                      .symmetric(horizontal: 14),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  integration.isConnected
                      ? 'Disconnect'
                      : 'Connect',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return const Color(0xFF6C63FF);
      case 'communication':
        return const Color(0xFF4CAF50);
      case 'storage':
        return const Color(0xFFFFA726);
      case 'calendar':
        return const Color(0xFFFF6B9D);
      case 'finance':
        return const Color(0xFF795548);
      case 'social':
        return const Color(0xFFE040FB);
      case 'developer':
        return const Color(0xFF2196F3);
      default:
        return AppTheme.primary;
    }
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
}
