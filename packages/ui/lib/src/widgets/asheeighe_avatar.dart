import 'package:flutter/material.dart';
import '../theme/asheeighe_colors.dart';

class AsheeigheAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final bool showOnlineIndicator;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;

  const AsheeigheAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 48,
    this.showOnlineIndicator = false,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBg = backgroundColor ??
        (isDark ? AsheeigheColors.darkPastelPink : AsheeigheColors.pastelPink);

    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: hasImage ? null : effectiveBg,
      foregroundColor: foregroundColor ?? Colors.black87,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: hasImage
          ? null
          : Text(
              _computeInitials(),
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w600,
              ),
            ),
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    if (!showOnlineIndicator) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 1,
          bottom: 1,
          child: Container(
            width: size * 0.28,
            height: size * 0.28,
            decoration: BoxDecoration(
              color: AsheeigheColors.success,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _computeInitials() {
    if (initials != null && initials!.isNotEmpty) return initials!;
    return '?';
  }
}
