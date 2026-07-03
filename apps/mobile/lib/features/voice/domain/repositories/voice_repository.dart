import '../entities/voice_settings.dart';
import '../entities/voice_command.dart';

abstract class VoiceRepository {
  Future<void> initialize();
  Future<void> startListening({String? language});
  Future<void> stopListening();
  Future<void> speak(String text, {VoiceSettings? settings});
  Future<void> stopSpeaking();
  Future<void> pauseSpeaking();
  Future<void> resumeSpeaking();
  Future<VoiceCommand> processVoiceInput(String audioData, String language);
  Future<VoiceSettings> getSettings();
  Future<void> saveSettings(VoiceSettings settings);
  Future<bool> isAvailable();
  Future<List<String>> getAvailableLanguages();
}
