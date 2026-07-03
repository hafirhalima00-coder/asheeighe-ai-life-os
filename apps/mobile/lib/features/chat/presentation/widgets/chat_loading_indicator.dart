import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class ChatLoadingIndicator extends StatelessWidget {
  const ChatLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: AppTheme.primaryLight,
            shape: BoxShape.circle,
          ),
        ).animate(
          onComplete: (controller) => controller.repeat(),
        ).fadeIn(
          duration: 400.ms,
          delay: (index * 200).ms,
        ).then().moveY(
          begin: 0,
          end: -6,
          duration: 400.ms,
          delay: (index * 200).ms,
          curve: Curves.easeInOutSine,
        ).then().moveY(
          begin: -6,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeInOutSine,
        );
      }),
    );
  }
}
