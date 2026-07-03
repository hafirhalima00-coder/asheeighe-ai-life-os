import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/pinkz_colors.dart';

enum PinkzButtonVariant { primary, secondary, outline, text }

class PinkzButton extends StatelessWidget {
  final PinkzButtonVariant variant;
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expanded;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? color;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final bool animate;

  const PinkzButton({
    super.key,
    this.variant = PinkzButtonVariant.primary,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expanded = true,
    this.width,
    this.height,
    this.borderRadius = 14,
    this.color,
    this.foregroundColor,
    this.padding,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Widget button;

    switch (variant) {
      case PinkzButtonVariant.primary:
        button = _primary(theme, isDark);
      case PinkzButtonVariant.secondary:
        button = _secondary(theme, isDark);
      case PinkzButtonVariant.outline:
        button = _outline(theme, isDark);
      case PinkzButtonVariant.text:
        button = _text(theme);
    }

    Widget result = button;

    if (animate) {
      result = result
          .animate()
          .fadeIn(duration: 250.ms, curve: Curves.easeOut)
          .scale(
            begin: const Offset(0.97, 0.97),
            duration: 250.ms,
            curve: Curves.easeOut,
          );
    }

    return result;
  }

  Widget _primary(ThemeData theme, bool isDark) {
    return SizedBox(
      width: expanded ? width ?? double.infinity : null,
      height: height ?? 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.colorScheme.primary,
          foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ),
        child: _buttonContent(),
      ),
    );
  }

  Widget _secondary(ThemeData theme, bool isDark) {
    return SizedBox(
      width: expanded ? width ?? double.infinity : null,
      height: height ?? 52,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color ??
              (isDark ? PinkzColors.darkSoftLavender : PinkzColors.softLavender),
          foregroundColor: foregroundColor ?? Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: _buttonContent(),
      ),
    );
  }

  Widget _outline(ThemeData theme, bool isDark) {
    return SizedBox(
      width: expanded ? width ?? double.infinity : null,
      height: height ?? 52,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor:
              foregroundColor ?? theme.colorScheme.onSurface,
          side: BorderSide(
            color: color ?? theme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        child: _buttonContent(),
      ),
    );
  }

  Widget _text(ThemeData theme) {
    return SizedBox(
      width: expanded ? width ?? double.infinity : null,
      height: height ?? 48,
      child: TextButton(
        onPressed: loading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor:
              foregroundColor ?? theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: _buttonContent(),
      ),
    );
  }

  Widget _buttonContent() {
    if (loading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
