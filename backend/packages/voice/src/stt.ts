export interface STTOptions {
  audioUrl?: string;
  audioBase64?: string;
  language: 'ar' | 'en' | 'fr';
  enablePunctuation?: boolean;
  enableCommands?: boolean;
}

export interface STTResult {
  transcript: string;
  confidence: number;
  language: string;
  words: Array<{
    word: string;
    startTime: number;
    endTime: number;
    confidence: number;
  }>;
}

export interface VoiceCommand {
  intent:
    | 'add_task'
    | 'create_reminder'
    | 'search'
    | 'set_alarm'
    | 'open_note'
    | 'play_quran'
    | 'read_hadith'
    | 'unknown';
  entities: Record<string, string>;
  rawText: string;
  confidence: number;
}

const COMMAND_PATTERNS: Record<string, RegExp[]> = {
  add_task: [
    /add\s+(?:a\s+)?task\s*(?:to\s+)?(.+)/i,
    /create\s+(?:a\s+)?task\s*(?:to\s+)?(.+)/i,
    /remind\s+me\s+to\s+(.+)/i,
    /set\s+(?:a\s+)?task\s*(?:to\s+)?(.+)/i,
  ],
  create_reminder: [
    /remind\s+me\s+(?:to\s+)?(.+?)\s+(?:at|on|in|for)\s+(.+)/i,
    /set\s+(?:a\s+)?reminder\s+(?:for\s+)?(.+?)\s+(?:at|on|in|for)\s+(.+)/i,
    /remember\s+to\s+(.+?)\s+(?:at|on|in|for)\s+(.+)/i,
  ],
  search: [
    /search\s+(?:for\s+)?(.+)/i,
    /look\s+up\s+(.+)/i,
    /find\s+(.+)/i,
  ],
  set_alarm: [
    /set\s+(?:an?\s+)?alarm\s+(?:for\s+)?(.+)/i,
    /wake\s+me\s+(?:up\s+)?(?:at\s+)?(.+)/i,
  ],
  open_note: [
    /open\s+(?:my\s+)?notes?/i,
    /show\s+(?:my\s+)?notes?/i,
    /read\s+(?:my\s+)?notes?/i,
  ],
  play_quran: [
    /play\s+(?:surah\s+|chapter\s+)?(.+)/i,
    /recite\s+(?:surah\s+)?(.+)/i,
    /listen\s+to\s+(?:surah\s+)?(.+)/i,
  ],
  read_hadith: [
    /read\s+(?:me\s+)?(?:a\s+)?hadith/i,
    /tell\s+me\s+(?:a\s+)?hadith/i,
    /what\s+(?:does|did)\s+(?:the\s+)?prophet\s+(?:\w+\s+)?say\s+(?:about\s+)?(.+)/i,
  ],
};

export async function transcribeAudio(options: STTOptions): Promise<STTResult> {
  const {
    audioUrl,
    audioBase64,
    language,
    enablePunctuation = true,
  } = options;

  if (!audioUrl && !audioBase64) {
    throw new Error('Either audioUrl or audioBase64 must be provided');
  }

  const requestBody: Record<string, any> = {
    config: {
      language: mapLanguageCode(language),
      enableAutomaticPunctuation: enablePunctuation,
      enableWordTimeOffsets: true,
      enableConfidence: true,
    },
  };

  if (audioUrl) {
    requestBody.audio = { uri: audioUrl };
  } else {
    requestBody.audio = { content: audioBase64 };
  }

  const response = await fetch(process.env.STT_ENDPOINT!, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.STT_API_KEY}`,
    },
    body: JSON.stringify(requestBody),
  });

  if (!response.ok) {
    throw new Error(`STT transcription failed: ${response.statusText}`);
  }

  const result = await response.json();

  return {
    transcript: result.transcript ?? '',
    confidence: result.confidence ?? 0.85,
    language,
    words: result.words ?? [],
  };
}

export function recognizeCommand(transcript: string): VoiceCommand {
  const normalizedText = transcript.toLowerCase().trim();

  for (const [intent, patterns] of Object.entries(COMMAND_PATTERNS)) {
    for (const pattern of patterns) {
      const match = normalizedText.match(pattern);
      if (match) {
        return {
          intent: intent as VoiceCommand['intent'],
          entities: extractEntities(intent, match),
          rawText: transcript,
          confidence: 0.9,
        };
      }
    }
  }

  return {
    intent: 'unknown',
    entities: {},
    rawText: transcript,
    confidence: 0.0,
  };
}

function extractEntities(
  intent: string,
  match: RegExpMatchArray
): Record<string, string> {
  const entities: Record<string, string> = {};

  switch (intent) {
    case 'add_task':
      entities['task'] = match[1]?.trim() ?? '';
      break;
    case 'create_reminder':
      entities['task'] = match[1]?.trim() ?? '';
      entities['time'] = match[2]?.trim() ?? '';
      break;
    case 'search':
      entities['query'] = match[1]?.trim() ?? '';
      break;
    case 'set_alarm':
      entities['time'] = match[1]?.trim() ?? '';
      break;
    case 'play_quran':
      entities['surah'] = match[1]?.trim() ?? '';
      break;
    case 'read_hadith':
      if (match[1]) entities['topic'] = match[1].trim();
      break;
  }

  return entities;
}

function mapLanguageCode(language: string): string {
  const map: Record<string, string> = {
    ar: 'ar-SA',
    en: 'en-US',
    fr: 'fr-FR',
  };
  return map[language] ?? 'en-US';
}
