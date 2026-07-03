import 'package:flutter/material.dart';

class PinkzAnimatedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Color? color;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Decoration? decoration;
  final bool animate;

  const PinkzAnimatedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.color,
    this.borderRadius = 12,
    this.boxShadow,
    this.decoration,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget container = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: height,
      width: width,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration ??
          BoxDecoration(
            color: color ?? theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: boxShadow,
          ),
      child: child,
    );

    return container;
  }
}
