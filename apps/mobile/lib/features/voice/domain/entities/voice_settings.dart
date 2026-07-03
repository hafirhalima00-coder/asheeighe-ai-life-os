class VoiceSettings {
  final String language;
  final double speed;
  final double pitch;
  final String voice;
  final bool isTTSEnabled;
  final bool isSTTEnabled;

  const VoiceSettings({
    this.language = 'en',
    this.speed = 1.0,
    this.pitch = 1.0,
    this.voice = 'female',
    this.isTTSEnabled = true,
    this.isSTTEnabled = true,
  });

  static const supportedLanguages = {
    'en': 'English',
    'ar': 'Arabic',
    'fr': 'French',
  };

  static const voiceTypes = ['male', 'female'];

  static const speedRange = RangeValues(0.5, 2.0);
  static const pitchRange = RangeValues(0.5, 2.0);

  VoiceSettings copyWith({
    String? language,
    double? speed,
    double? pitch,
    String? voice,
    bool? isTTSEnabled,
    bool? isSTTEnabled,
  }) {
    return VoiceSettings(
      language: language ?? this.language,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      voice: voice ?? this.voice,
      isTTSEnabled: isTTSEnabled ?? this.isTTSEnabled,
      isSTTEnabled: isSTTEnabled ?? this.isSTTEnabled,
    );
  }

  static const defaultSettings = VoiceSettings();
}

class RangeValues {
  final double min;
  final double max;

  const RangeValues(this.min, this.max);
}
