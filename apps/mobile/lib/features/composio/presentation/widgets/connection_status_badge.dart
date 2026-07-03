import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class ConnectionStatusBadge extends StatelessWidget {
  final bool isConnected;
  final bool large;

  const ConnectionStatusBadge({
    super.key,
    required this.isConnected,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 16.0 : 10.0;
    final fontSize = large ? 14.0 : 12.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isConnected
                ? AppTheme.success
                : AppTheme.textHint,
            shape: BoxShape.circle,
            boxShadow: isConnected
                ? [
                    BoxShadow(
                      color: AppTheme.success
                          .withOpacity(0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        ),
        SizedBox(width: large ? 8 : 6),
        Text(
          isConnected ? 'Connected' : 'Disconnected',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: isConnected
                ? AppTheme.success
                : AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
