import 'package:flutter/material.dart';
import '../theme/asheeighe_colors.dart';

class AsheeigheGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool animate;

  const AsheeigheGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColors = colors ?? [
      AsheeigheColors.creamWhite,
      AsheeigheColors.pastelPink.withOpacity(0.3),
      AsheeigheColors.softLavender.withOpacity(0.2),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: effectiveColors,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
