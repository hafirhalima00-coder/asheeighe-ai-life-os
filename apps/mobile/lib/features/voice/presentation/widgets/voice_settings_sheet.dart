import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voice_provider.dart';
import '../../domain/entities/voice_settings.dart';

class VoiceSettingsSheet extends ConsumerStatefulWidget {
  const VoiceSettingsSheet({super.key});

  @override
  ConsumerState<VoiceSettingsSheet> createState() => _VoiceSettingsSheetState();
}

class _VoiceSettingsSheetState extends ConsumerState<VoiceSettingsSheet> {
  late double _speed;
  late double _pitch;
  late String _language;
  late String _voice;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(voiceProvider).settings;
    _speed = settings.speed;
    _pitch = settings.pitch;
    _language = settings.language;
    _voice = settings.voice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1a1a1a),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
            'Voice Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Language', _buildLanguageSelector()),
          const SizedBox(height: 20),
          _buildSection('Voice', _buildVoiceSelector()),
          const SizedBox(height: 20),
          _buildSection('Speed', _buildSlider('Speed', _speed, (v) {
            setState(() => _speed = v);
            ref.read(voiceProvider.notifier).updateSpeed(v);
          })),
          const SizedBox(height: 20),
          _buildSection('Pitch', _buildSlider('Pitch', _pitch, (v) {
            setState(() => _pitch = v);
            ref.read(voiceProvider.notifier).updatePitch(v);
          })),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _testVoice(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Test Voice',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: _language,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: const Color(0xFF2a2a2a),
        style: const TextStyle(color: Colors.white),
        items: VoiceSettings.supportedLanguages.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) {
            setState(() => _language = v);
            ref.read(voiceProvider.notifier).updateLanguage(v);
          }
        },
      ),
    );
  }

  Widget _buildVoiceSelector() {
    return Row(
      children: VoiceSettings.voiceTypes
          .map((type) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _voice = type);
                    ref.read(voiceProvider.notifier).updateVoice(type);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _voice == type
                          ? const Color(0xFFFF69B4).withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _voice == type
                            ? const Color(0xFFFF69B4)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type == 'male' ? Icons.male : Icons.female,
                          color: _voice == type
                              ? const Color(0xFFFF69B4)
                              : Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          type[0].toUpperCase() + type.substring(1),
                          style: TextStyle(
                            color: _voice == type
                                ? const Color(0xFFFF69B4)
                                : Colors.white54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)}x',
              style: const TextStyle(
                color: Color(0xFFFF69B4),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFFF69B4),
            inactiveTrackColor: Colors.white.withOpacity(0.1),
            thumbColor: const Color(0xFFFF69B4),
            overlayColor: const Color(0xFFFF69B4).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _testVoice() {
    ref.read(voiceProvider.notifier).speak(
      _language == 'ar'
          ? 'بسم الله الرحمن الرحيم'
          : _language == 'fr'
              ? 'Bonjour, comment allez-vous?'
              : 'Hello, welcome to PINKZ!',
    );
  }
}
