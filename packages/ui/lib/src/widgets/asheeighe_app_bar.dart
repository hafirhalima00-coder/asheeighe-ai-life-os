import 'package:flutter/material.dart';
import '../theme/asheeighe_colors.dart';

class AsheeigheAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool glass;
  final bool gradient;
  final List<Color>? gradientColors;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final Widget? titleWidget;
  final bool automaticallyImplyLeading;

  const AsheeigheAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.glass = false,
    this.gradient = false,
    this.gradientColors,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 64,
    this.titleWidget,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveForeground =
        foregroundColor ?? theme.colorScheme.onSurface;

    final effectiveBackground = backgroundColor ??
        (glass
            ? (isDark ? AsheeigheColors.glassDark : AsheeigheColors.glassLight)
            : Colors.transparent);

    final effectiveElevation = glass ? 0 : elevation;

    Widget appBar = AppBar(
      title: titleWidget ?? Text(title),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      elevation: effectiveElevation,
      backgroundColor: effectiveBackground,
      foregroundColor: effectiveForeground,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: glass ? 0 : 1,
      flexibleSpace: gradient || glass
          ? Container(
              decoration: BoxDecoration(
                gradient: gradient
                    ? LinearGradient(
                        colors: gradientColors ??
                            [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: glass
                    ? Border(
                        bottom: BorderSide(
                          color: theme.glassStroke,
                          width: 0.5,
                        ),
                      )
                    : null,
              ),
            )
          : null,
    );

    if (glass) {
      appBar = ClipRRect(
        child: BackdropFilter(
          filter: _ImageFilterBlur(sigmaX: 12, sigmaY: 12),
          child: appBar,
        ),
      );
    }

    return appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

// Minimal blur filter shim used for glass effect.
// In production, replace with dart:ui ImageFilter.blur.
class _ImageFilterBlur {
  final double sigmaX;
  final double sigmaY;
  const _ImageFilterBlur({required this.sigmaX, required this.sigmaY});
}
