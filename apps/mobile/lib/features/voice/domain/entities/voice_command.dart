enum VoiceCommandIntent {
  addTask,
  createReminder,
  search,
  setAlarm,
  openNote,
  playQuran,
  readHadith,
  unknown,
}

class VoiceCommand {
  final VoiceCommandIntent intent;
  final Map<String, String> entities;
  final String rawText;
  final double confidence;

  const VoiceCommand({
    required this.intent,
    required this.entities,
    required this.rawText,
    required this.confidence,
  });

  bool get isUnderstood => intent != VoiceCommandIntent.unknown;
  bool get isHighConfidence => confidence >= 0.8;

  String? get taskText => entities['task'];
  String? get timeText => entities['time'];
  String? get queryText => entities['query'];
  String? get surahText => entities['surah'];
  String? get topicText => entities['topic'];

  factory VoiceCommand.unknown(String text) {
    return VoiceCommand(
      intent: VoiceCommandIntent.unknown,
      entities: {},
      rawText: text,
      confidence: 0.0,
    );
  }

  factory VoiceCommand.fromJson(Map<String, dynamic> json) {
    return VoiceCommand(
      intent: VoiceCommandIntent.values.firstWhere(
        (e) => e.name == json['intent'],
        orElse: () => VoiceCommandIntent.unknown,
      ),
      entities: Map<String, String>.from(json['entities'] ?? {}),
      rawText: json['rawText'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intent': intent.name,
      'entities': entities,
      'rawText': rawText,
      'confidence': confidence,
    };
  }

  String get displayIntent {
    switch (intent) {
      case VoiceCommandIntent.addTask:
        return 'Add Task';
      case VoiceCommandIntent.createReminder:
        return 'Create Reminder';
      case VoiceCommandIntent.search:
        return 'Search';
      case VoiceCommandIntent.setAlarm:
        return 'Set Alarm';
      case VoiceCommandIntent.openNote:
        return 'Open Notes';
      case VoiceCommandIntent.playQuran:
        return 'Play Quran';
      case VoiceCommandIntent.readHadith:
        return 'Read Hadith';
      case VoiceCommandIntent.unknown:
        return 'Unknown Command';
    }
  }
}
