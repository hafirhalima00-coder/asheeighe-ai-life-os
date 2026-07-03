import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voice_provider.dart';

class VoiceOverlay extends ConsumerStatefulWidget {
  final Function(String text)? onResult;
  final VoidCallback? onClose;

  const VoiceOverlay({
    super.key,
    this.onResult,
    this.onClose,
  });

  @override
  ConsumerState<VoiceOverlay> createState() => _VoiceOverlayState();
}

class _VoiceOverlayState extends ConsumerState<VoiceOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    ref.read(voiceProvider.notifier).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceProvider);

    if (voiceState.lastCommand != null && voiceState.lastCommand!.isUnderstood) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onResult?.call(voiceState.lastCommand!.rawText);
      });
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.95),
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () {
                    ref.read(voiceProvider.notifier).stopListening();
                    widget.onClose?.call();
                    Navigator.pop(context);
                  },
                ),
              ),
              const Spacer(),
              _buildWaveform(voiceState),
              const SizedBox(height: 40),
              _buildTranscript(voiceState),
              const SizedBox(height: 24),
              _buildStatus(voiceState),
              const Spacer(),
              _buildMicButton(voiceState),
              const SizedBox(height: 40),
              _buildQuickActions(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform(VoiceState voiceState) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(30, (index) {
          final height = voiceState.isListening
              ? (20 + (index % 5) * 8 + (DateTime.now().millisecond % 30))
              : 4.0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            width: 3,
            height: height.toDouble(),
            decoration: BoxDecoration(
              color: voiceState.isListening
                  ? const Color(0xFFFF69B4)
                      .withOpacity(0.3 + (index % 3) * 0.2)
                  : Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTranscript(VoiceState voiceState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        voiceState.transcript ??
            (voiceState.isListening ? 'Listening...' : 'Tap to speak'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: voiceState.isListening ? Colors.white : Colors.white38,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatus(VoiceState voiceState) {
    if (voiceState.lastCommand != null &&
        voiceState.lastCommand!.isUnderstood) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 16),
            const SizedBox(width: 6),
            Text(
              voiceState.lastCommand!.displayIntent,
              style: const TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (voiceState.error != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          voiceState.error!,
          style: const TextStyle(
            color: Color(0xFFFF6B6B),
            fontSize: 14,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMicButton(VoiceState voiceState) {
    return GestureDetector(
      onTap: () {
        if (voiceState.isListening) {
          ref.read(voiceProvider.notifier).stopListening();
        } else {
          ref.read(voiceProvider.notifier).startListening();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: voiceState.isListening
                ? [const Color(0xFFFF69B4), const Color(0xFFFF1493)]
                : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: voiceState.isListening
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF69B4).withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Icon(
          voiceState.isListening ? Icons.mic : Icons.mic_none,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.add_task, 'label': 'Add Task'},
      {'icon': Icons.alarm, 'label': 'Reminder'},
      {'icon': Icons.search, 'label': 'Search'},
      {'icon': Icons.book, 'label': 'Quran'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions
          .map((action) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action['label'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}
