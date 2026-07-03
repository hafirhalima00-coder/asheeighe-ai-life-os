import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/voice_provider.dart';

class HadithTTSButton extends ConsumerStatefulWidget {
  final String hadithText;
  final String language;
  final double size;

  const HadithTTSButton({
    super.key,
    required this.hadithText,
    this.language = 'en',
    this.size = 32,
  });

  @override
  ConsumerState<HadithTTSButton> createState() => _HadithTTSButtonState();
}

class _HadithTTSButtonState extends ConsumerState<HadithTTSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayback,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isPlaying
                  ? const Color(0xFFFF69B4).withOpacity(0.15)
                  : Colors.white.withOpacity(0.05),
              border: Border.all(
                color: _isPlaying
                    ? const Color(0xFFFF69B4).withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: CustomPaint(
              painter: _isPlaying
                  ? _SoundWavePainter(
                      color: const Color(0xFFFF69B4),
                      progress: _controller.value,
                    )
                  : null,
              child: Center(
                child: Icon(
                  _isPlaying ? Icons.stop : Icons.volume_up,
                  color: _isPlaying
                      ? const Color(0xFFFF69B4)
                      : Colors.white.withOpacity(0.5),
                  size: widget.size * 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _togglePlayback() {
    final voiceNotifier = ref.read(voiceProvider.notifier);

    if (_isPlaying) {
      voiceNotifier.stopSpeaking();
      _controller.stop();
      _controller.reset();
      setState(() => _isPlaying = false);
    } else {
      voiceNotifier.speak(widget.hadithText);
      _controller.repeat();
      setState(() => _isPlaying = true);

      _monitorPlayback();
    }
  }

  void _monitorPlayback() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final state = ref.read(voiceProvider);
      if (!state.isSpeaking && _isPlaying) {
        _controller.stop();
        _controller.reset();
        setState(() => _isPlaying = false);
      } else if (state.isSpeaking) {
        _monitorPlayback();
      }
    });
  }
}

class _SoundWavePainter extends CustomPainter {
  final Color color;
  final double progress;

  _SoundWavePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final barWidth = 2.0;
    final spacing = 3.0;
    final barCount = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing) + spacing;
      final amplitude =
          (progress * 3.14159 + i * 0.5).sin().abs();
      final barHeight = size.height * 0.3 * amplitude;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, centerY),
            width: barWidth,
            height: barHeight,
          ),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SoundWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
