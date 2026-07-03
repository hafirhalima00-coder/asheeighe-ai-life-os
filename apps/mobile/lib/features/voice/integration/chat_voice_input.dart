import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/voice_provider.dart';

class ChatVoiceInput extends ConsumerStatefulWidget {
  final Function(String text) onVoiceResult;
  final bool isActive;

  const ChatVoiceInput({
    super.key,
    required this.onVoiceResult,
    this.isActive = false,
  });

  @override
  ConsumerState<ChatVoiceInput> createState() => _ChatVoiceInputState();
}

class _ChatVoiceInputState extends ConsumerState<ChatVoiceInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
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
    final voiceState = ref.watch(voiceProvider);

    if (voiceState.isListening) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: voiceState.isListening ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: voiceState.isListening
                    ? const Color(0xFFFF69B4)
                    : Colors.white.withOpacity(0.1),
                boxShadow: voiceState.isListening
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF69B4).withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                voiceState.isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleListening() {
    final voiceState = ref.read(voiceProvider);
    if (voiceState.isListening) {
      ref.read(voiceProvider.notifier).stopListening();
    } else {
      ref.read(voiceProvider.notifier).startListening();

      _monitorForResult();
    }
  }

  void _monitorForResult() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final state = ref.read(voiceProvider);
      if (state.lastCommand != null && state.lastCommand!.rawText.isNotEmpty) {
        widget.onVoiceResult(state.lastCommand!.rawText);
        ref.read(voiceProvider.notifier).stopListening();
      } else if (state.isListening) {
        _monitorForResult();
      }
    });
  }
}
