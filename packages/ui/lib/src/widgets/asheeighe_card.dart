import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/asheeighe_colors.dart';

class AsheeigheCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;
  final bool glassmorphism;
  final bool animate;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const AsheeigheCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius = 20,
    this.color,
    this.borderColor,
    this.glassmorphism = false,
    this.animate = true,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = color ??
        (glassmorphism
            ? (isDark ? AsheeigheColors.glassDark : AsheeigheColors.glassLight)
            : theme.cardTheme.color);

    final effectiveElevation =
        glassmorphism ? (elevation ?? 0) : (elevation ?? theme.cardTheme.elevation ?? 1);

    Widget card = Material(
      elevation: effectiveElevation,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: clipBehavior,
      color: effectiveColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: glassmorphism ? Colors.transparent : theme.shadowColor,
      child: Container(
        decoration: glassmorphism
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor ?? theme.glassStroke,
                  width: 0.5,
                ),
              )
            : (borderColor != null
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: borderColor!, width: 0.5),
                  )
                : null),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    if (animate) {
      card = card
          .animate()
          .fadeIn(duration: 300.ms, curve: Curves.easeOut)
          .slideX(begin: 0.05, duration: 300.ms, curve: Curves.easeOut);
    }

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}
