import 'package:flutter/material.dart';

class AudioPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final String selectedReciter;
  final ValueChanged<String> onReciterChanged;

  const AudioPlayerControls({
    super.key,
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
    required this.selectedReciter,
    required this.onReciterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedReciter,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'mishary',
                      child: Text('Mishary Al-Afasy'),
                    ),
                    DropdownMenuItem(
                      value: 'abdulbasit',
                      child: Text('Abdul Basit'),
                    ),
                    DropdownMenuItem(
                      value: 'sudais',
                      child: Text('Al-Sudais'),
                    ),
                    DropdownMenuItem(
                      value: 'minshawi',
                      child: Text('El-Minshawi'),
                    ),
                    DropdownMenuItem(
                      value: 'husary',
                      child: Text('Al-Husary'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onReciterChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 32),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: isPlaying ? onPause : onPlay,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 32),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
