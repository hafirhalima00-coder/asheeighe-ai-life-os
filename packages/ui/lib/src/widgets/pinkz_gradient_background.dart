import 'package:flutter/material.dart';
import '../theme/pinkz_colors.dart';

class PinkzGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool animate;

  const PinkzGradientBackground({
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
      PinkzColors.creamWhite,
      PinkzColors.pastelPink.withOpacity(0.3),
      PinkzColors.softLavender.withOpacity(0.2),
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
