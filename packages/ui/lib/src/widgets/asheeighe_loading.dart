import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/asheeighe_colors.dart';

class AsheeigheLoadingShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AsheeigheLoadingShimmer({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class AsheeigheCardShimmer extends StatelessWidget {
  final int lines;
  final bool hasAvatar;

  const AsheeigheCardShimmer({
    super.key,
    this.lines = 3,
    this.hasAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasAvatar) ...[
            const AsheeigheLoadingShimmer(
              width: 48,
              height: 48,
              borderRadius: 24,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AsheeigheLoadingShimmer(width: 180),
                const SizedBox(height: 8),
                ...List.generate(
                  lines - 1,
                  (i) => const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: AsheeigheLoadingShimmer(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AsheeigheLoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const AsheeigheLoadingSpinner({
    super.key,
    this.size = 36,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: color ?? theme.colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ).animate().fadeIn(),
    );
  }
}

class AsheeighePageLoading extends StatelessWidget {
  final String? message;

  const AsheeighePageLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AsheeigheLoadingSpinner(),
    );
  }
}
