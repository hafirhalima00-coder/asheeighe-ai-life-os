import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../domain/entities/voice_settings.dart';
import '../domain/entities/voice_command.dart';
import '../domain/repositories/voice_repository.dart';

class VoiceServiceImpl implements VoiceRepository {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  VoiceSettings _settings = VoiceSettings.defaultSettings;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioOptions.mixWithOthers,
      ],
    );

    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((message) {
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  @override
  Future<void> startListening({String? language}) async {
    if (_isListening) return;

    final hasPermission = await _checkPermission();
    if (!hasPermission) {
      throw Exception('Microphone permission denied');
    }

    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
      onError: (error) {
        _isListening = false;
      },
    );

    final langCode = language ?? _settings.language;
    await _speech.listen(
      onResult: (result) {},
      localeId: _mapLocale(langCode),
      listenMode: stt.ListenMode.dictation,
      cancelOnError: true,
      partialResults: true,
    );

    _isListening = true;
  }

  @override
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  @override
  Future<void> speak(String text, {VoiceSettings? settings}) async {
    if (_isSpeaking) {
      await stopSpeaking();
    }

    final s = settings ?? _settings;

    await _tts.setLanguage(_mapLanguageCode(s.language));
    await _tts.setSpeechRate(_mapSpeed(s.speed));
    await _tts.setVolume(1.0);
    await _tts.setPitch(s.pitch);

    final voices = await _tts.getVoices;
    final filtered = voices.where((v) {
      final name = (v['name'] as String?) ?? '';
      final locale = (v['locale'] as String?) ?? '';
      final isCorrectLocale = locale.startsWith(s.language);
      final isCorrectVoice =
          s.voice == 'male' ? name.contains('male') || name.contains('Guy') || name.contains('Hamed') : name.contains('female') || name.contains('Jenny') || name.contains('Zariyah');
      return isCorrectLocale && isCorrectVoice;
    }).toList();

    if (filtered.isNotEmpty) {
      await _tts.setVoice(filtered.first);
    }

    await _tts.speak(text);
    _isSpeaking = true;
  }

  @override
  Future<void> stopSpeaking() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  @override
  Future<void> pauseSpeaking() async {
    await _tts.pause();
  }

  @override
  Future<void> resumeSpeaking() async {
    await _tts.speak('');
  }

  @override
  Future<VoiceCommand> processVoiceInput(
      String audioData, String language) async {
    try {
      final result = await _speech.lastRecognizedWords;
      return _parseCommand(result);
    } catch (e) {
      return VoiceCommand.unknown(audioData);
    }
  }

  @override
  Future<VoiceSettings> getSettings() async {
    return _settings;
  }

  @override
  Future<void> saveSettings(VoiceSettings settings) async {
    _settings = settings;
  }

  @override
  Future<bool> isAvailable() async {
    return await _speech.initialize();
  }

  @override
  Future<List<String>> getAvailableLanguages() async {
    final locales = await _speech.locales();
    return locales
        .where((l) => ['en', 'ar', 'fr'].any((c) => l.localeId.startsWith(c)))
        .map((l) => l.localeId)
        .toList();
  }

  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  VoiceSettings get currentSettings => _settings;

  Future<bool> _checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  VoiceCommand _parseCommand(String text) {
    final normalized = text.toLowerCase().trim();

    final patterns = {
      VoiceCommandIntent.addTask: [
        RegExp(r'add\s+(?:a\s+)?task\s*(?:to\s+)?(.+)', caseSensitive: false),
        RegExp(r'create\s+(?:a\s+)?task\s*(?:to\s+)?(.+)', caseSensitive: false),
      ],
      VoiceCommandIntent.createReminder: [
        RegExp(r'remind\s+me\s+(?:to\s+)?(.+?)\s+(?:at|on|in)\s+(.+)',
            caseSensitive: false),
      ],
      VoiceCommandIntent.search: [
        RegExp(r'search\s+(?:for\s+)?(.+)', caseSensitive: false),
        RegExp(r'look\s+up\s+(.+)', caseSensitive: false),
      ],
      VoiceCommandIntent.playQuran: [
        RegExp(r'play\s+(?:surah\s+)?(.+)', caseSensitive: false),
        RegExp(r'recite\s+(?:surah\s+)?(.+)', caseSensitive: false),
      ],
      VoiceCommandIntent.readHadith: [
        RegExp(r'read\s+(?:me\s+)?(?:a\s+)?hadith', caseSensitive: false),
        RegExp(r'tell\s+me\s+(?:a\s+)?hadith', caseSensitive: false),
      ],
    };

    for (final entry in patterns.entries) {
      for (final pattern in entry.value) {
        final match = pattern.firstMatch(normalized);
        if (match != null) {
          final entities = <String, String>{};
          if (match.groupCount >= 1) entities['task'] = match.group(1) ?? '';
          if (match.groupCount >= 2) entities['time'] = match.group(2) ?? '';

          return VoiceCommand(
            intent: entry.key,
            entities: entities,
            rawText: text,
            confidence: 0.9,
          );
        }
      }
    }

    return VoiceCommand.unknown(text);
  }

  String _mapLanguageCode(String lang) {
    const map = {'en': 'en-US', 'ar': 'ar-SA', 'fr': 'fr-FR'};
    return map[lang] ?? 'en-US';
  }

  String _mapLocale(String lang) {
    const map = {'en': 'en-US', 'ar': 'ar-SA', 'fr': 'fr-FR'};
    return map[lang] ?? 'en-US';
  }

  double _mapSpeed(double speed) {
    return (speed * 0.5).clamp(0.0, 1.0);
  }
}
