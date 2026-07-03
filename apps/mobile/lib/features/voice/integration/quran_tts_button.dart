import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/voice_provider.dart';

class QuranTTSButton extends ConsumerStatefulWidget {
  final String ayahText;
  final int? ayahNumber;
  final String? surahName;
  final double size;

  const QuranTTSButton({
    super.key,
    required this.ayahText,
    this.ayahNumber,
    this.surahName,
    this.size = 36,
  });

  @override
  ConsumerState<QuranTTSButton> createState() => _QuranTTSButtonState();
}

class _QuranTTSButtonState extends ConsumerState<QuranTTSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      onLongPress: _showOptions,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _isPlaying
                  ? RadialGradient(
                      colors: [
                        const Color(0xFF4CAF50).withOpacity(0.3),
                        const Color(0xFF4CAF50).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    )
                  : null,
              color: _isPlaying ? null : Colors.white.withOpacity(0.05),
              border: Border.all(
                color: _isPlaying
                    ? const Color(0xFF4CAF50).withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: CustomPaint(
              painter: _isPlaying
                  ? _QuranWavePainter(
                      color: const Color(0xFF4CAF50),
                      progress: _controller.value,
                    )
                  : null,
              child: Center(
                child: Icon(
                  _isPlaying ? Icons.stop : Icons.play_arrow,
                  color: _isPlaying
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF4CAF50).withOpacity(0.7),
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
      final settings = ref.read(voiceProvider).settings;
      voiceNotifier.speak(widget.ayahText);
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

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Listen Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildOption(
              Icons.play_arrow,
              'Play Ayah',
              'Read this ayah aloud',
              () {
                Navigator.pop(context);
                _togglePlayback();
              },
            ),
            _buildOption(
              Icons.playlist_play,
              'Play Surah',
              'Read the entire surah',
              () {
                Navigator.pop(context);
              },
            ),
            _buildOption(
              Icons.speed,
              'Adjust Speed',
              'Change reading speed',
              () {
                Navigator.pop(context);
                _showSpeedDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
      onTap: onTap,
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        title: const Text('Reading Speed',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Slow', 'Normal', 'Fast'].map((speed) {
            return ListTile(
              title: Text(speed, style: const TextStyle(color: Colors.white70)),
              onTap: () {
                final speedValue = speed == 'Slow'
                    ? 0.7
                    : speed == 'Fast'
                        ? 1.3
                        : 0.85;
                ref.read(voiceProvider.notifier).updateSpeed(speedValue);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _QuranWavePainter extends CustomPainter {
  final Color color;
  final double progress;

  _QuranWavePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final radius = size.width * 0.3 + i * 4.0;
      final opacity = (1.0 - i * 0.3).clamp(0.0, 1.0);
      paint.color = color.withOpacity(opacity * 0.2);

      final startAngle = progress * 3.14159 * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        3.14159,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _QuranWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
