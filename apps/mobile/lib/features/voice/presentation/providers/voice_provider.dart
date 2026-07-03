import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/voice_settings.dart';
import '../../domain/entities/voice_command.dart';
import '../../data/voice_service.dart';

class VoiceNotifier extends StateNotifier<VoiceState> {
  final VoiceServiceImpl _service;
  StreamSubscription? _listeningSubscription;

  VoiceNotifier(this._service) : super(const VoiceState());

  Future<void> initialize() async {
    await _service.initialize();
    final settings = await _service.getSettings();
    state = state.copyWith(settings: settings, isAvailable: true);
  }

  Future<void> startListening() async {
    try {
      state = state.copyWith(isListening: true, lastCommand: null, error: null);
      await _service.startListening(language: state.settings.language);

      _monitorListening();
    } catch (e) {
      state = state.copyWith(
        isListening: false,
        error: 'Failed to start listening: ${e.toString()}',
      );
    }
  }

  void _monitorListening() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_service.isListening) {
        timer.cancel();
        if (state.isListening) {
          final lastWords = _service.lastRecognizedWords;
          if (lastWords.isNotEmpty) {
            final command = _parseLocalCommand(lastWords);
            state = state.copyWith(
              isListening: false,
              lastCommand: command,
              transcript: lastWords,
            );
          } else {
            state = state.copyWith(isListening: false);
          }
        }
      }
    });
  }

  Future<void> stopListening() async {
    await _service.stopListening();
    state = state.copyWith(isListening: false);
  }

  Future<void> speak(String text) async {
    if (!state.settings.isTTSEnabled) return;

    try {
      state = state.copyWith(isSpeaking: true, error: null);
      await _service.speak(text, settings: state.settings);
    } catch (e) {
      state = state.copyWith(
        isSpeaking: false,
        error: 'Failed to speak: ${e.toString()}',
      );
    }
  }

  Future<void> stopSpeaking() async {
    await _service.stopSpeaking();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> updateSettings(VoiceSettings settings) async {
    await _service.saveSettings(settings);
    state = state.copyWith(settings: settings);
  }

  Future<void> updateLanguage(String language) async {
    final newSettings = state.settings.copyWith(language: language);
    await updateSettings(newSettings);
  }

  Future<void> updateSpeed(double speed) async {
    final newSettings = state.settings.copyWith(speed: speed);
    await updateSettings(newSettings);
  }

  Future<void> updatePitch(double pitch) async {
    final newSettings = state.settings.copyWith(pitch: pitch);
    await updateSettings(newSettings);
  }

  Future<void> updateVoice(String voice) async {
    final newSettings = state.settings.copyWith(voice: voice);
    await updateSettings(newSettings);
  }

  VoiceCommand _parseLocalCommand(String text) {
    final normalized = text.toLowerCase().trim();

    if (RegExp(r'add\s+(?:a\s+)?task', caseSensitive: false).hasMatch(normalized)) {
      final match = RegExp(r'add\s+(?:a\s+)?task\s*(?:to\s+)?(.+)',
              caseSensitive: false)
          .firstMatch(normalized);
      return VoiceCommand(
        intent: VoiceCommandIntent.addTask,
        entities: {'task': match?.group(1)?.trim() ?? ''},
        rawText: text,
        confidence: 0.9,
      );
    }

    if (RegExp(r'remind\s+me', caseSensitive: false).hasMatch(normalized)) {
      return VoiceCommand(
        intent: VoiceCommandIntent.createReminder,
        entities: {'task': text},
        rawText: text,
        confidence: 0.85,
      );
    }

    if (RegExp(r'search|look\s+up|find', caseSensitive: false)
        .hasMatch(normalized)) {
      final match = RegExp(r'(?:search|look\s+up|find)\s+(?:for\s+)?(.+)',
              caseSensitive: false)
          .firstMatch(normalized);
      return VoiceCommand(
        intent: VoiceCommandIntent.search,
        entities: {'query': match?.group(1)?.trim() ?? text},
        rawText: text,
        confidence: 0.88,
      );
    }

    if (RegExp(r'play|recite', caseSensitive: false).hasMatch(normalized)) {
      return VoiceCommand(
        intent: VoiceCommandIntent.playQuran,
        entities: {'surah': text},
        rawText: text,
        confidence: 0.82,
      );
    }

    return VoiceCommand.unknown(text);
  }

  @override
  void dispose() {
    _listeningSubscription?.cancel();
    super.dispose();
  }
}

class VoiceState {
  final bool isListening;
  final bool isSpeaking;
  final bool isAvailable;
  final VoiceSettings settings;
  final VoiceCommand? lastCommand;
  final String? transcript;
  final String? error;

  const VoiceState({
    this.isListening = false,
    this.isSpeaking = false,
    this.isAvailable = false,
    this.settings = VoiceSettings.defaultSettings,
    this.lastCommand,
    this.transcript,
    this.error,
  });

  VoiceState copyWith({
    bool? isListening,
    bool? isSpeaking,
    bool? isAvailable,
    VoiceSettings? settings,
    VoiceCommand? lastCommand,
    String? transcript,
    String? error,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isAvailable: isAvailable ?? this.isAvailable,
      settings: settings ?? this.settings,
      lastCommand: lastCommand ?? this.lastCommand,
      transcript: transcript ?? this.transcript,
      error: error,
    );
  }
}

final voiceServiceProvider = Provider<VoiceServiceImpl>((ref) {
  return VoiceServiceImpl();
});

final voiceProvider =
    StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  final service = ref.watch(voiceServiceProvider);
  return VoiceNotifier(service);
});
