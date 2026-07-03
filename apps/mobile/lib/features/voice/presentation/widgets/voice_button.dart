import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voice_provider.dart';

class VoiceButton extends ConsumerStatefulWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const VoiceButton({
    super.key,
    this.onPressed,
    this.size = 56,
    this.activeColor = const Color(0xFFFF69B4),
    this.inactiveColor = Colors.white24,
  });

  @override
  ConsumerState<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends ConsumerState<VoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceProvider);

    if (voiceState.isListening) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }

    return GestureDetector(
      onTap: () {
        if (voiceState.isListening) {
          ref.read(voiceProvider.notifier).stopListening();
        } else {
          widget.onPressed?.call();
          ref.read(voiceProvider.notifier).startListening();
        }
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: voiceState.isListening
                  ? widget.activeColor
                  : widget.inactiveColor,
              boxShadow: voiceState.isListening
                  ? [
                      BoxShadow(
                        color: widget.activeColor.withOpacity(0.4),
                        blurRadius: 20 * _pulseAnimation.value,
                        spreadRadius: 5 * (_pulseAnimation.value - 1),
                      ),
                    ]
                  : null,
            ),
            child: CustomPaint(
              painter: voiceState.isListening
                  ? _WaveformPainter(
                      color: Colors.white.withOpacity(0.3),
                      progress: _pulseController.value,
                    )
                  : null,
              child: Center(
                child: Icon(
                  voiceState.isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: widget.size * 0.45,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  final double progress;

  _WaveformPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final waveRadius = radius * (0.6 + progress * 0.4 + i * 0.15);
      final opacity = (1.0 - i * 0.3).clamp(0.0, 1.0);
      paint.color = color.withOpacity(opacity * 0.3);

      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
