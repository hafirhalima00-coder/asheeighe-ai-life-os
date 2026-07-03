export interface TTSOptions {
  text: string;
  language: 'ar' | 'en' | 'fr';
  speed?: number;
  pitch?: number;
  voice?: 'male' | 'female';
  outputFormat?: 'mp3' | 'wav' | 'ogg';
}

export interface TTSResult {
  audioUrl: string;
  duration: number;
  format: string;
  language: string;
}

const VOICE_MAP: Record<string, Record<string, string>> = {
  en: {
    male: 'en-US-GuyNeural',
    female: 'en-US-JennyNeural',
  },
  ar: {
    male: 'ar-SA-HamedNeural',
    female: 'ar-SA-ZariyahNeural',
  },
  fr: {
    male: 'fr-FR-HenriNeural',
    female: 'fr-FR-DeniseNeural',
  },
};

const ARABIC_QURAN_READERS = {
  mishary: 'mishary-rashid-alafasy',
  sudais: 'abdul-rahman-al-sudais',
  minshawi: 'muhammad-siddiq-al-minshawi',
};

export async function synthesizeSpeech(options: TTSOptions): Promise<TTSResult> {
  const {
    text,
    language,
    speed = 1.0,
    pitch = 1.0,
    voice = 'female',
    outputFormat = 'mp3',
  } = options;

  const voiceName = VOICE_MAP[language]?.[voice] ?? VOICE_MAP.en.female;

  const rate = `${Math.round((speed - 1) * 100)}%`;
  const pitchValue = `${Math.round((pitch - 1) * 100)}%`;

  const ssml = `
    <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="${language}">
      <voice name="${voiceName}">
        <prosody rate="${rate}" pitch="${pitchValue}">
          ${escapeXml(text)}
        </prosody>
      </voice>
    </speak>
  `.trim();

  const response = await fetch(process.env.TTS_ENDPOINT!, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.TTS_API_KEY}`,
    },
    body: JSON.stringify({
      ssml,
      outputFormat,
      language,
    }),
  });

  if (!response.ok) {
    throw new Error(`TTS synthesis failed: ${response.statusText}`);
  }

  const result = await response.json();

  const estimatedDuration = estimateDuration(text, speed, language);

  return {
    audioUrl: result.audioUrl,
    duration: estimatedDuration,
    format: outputFormat,
    language,
  };
}

export async function synthesizeQuranAyah(
  ayahText: string,
  reader: keyof typeof ARABIC_QURAN_READERS = 'mishary'
): Promise<TTSResult> {
  return synthesizeSpeech({
    text: ayahText,
    language: 'ar',
    speed: 0.85,
    pitch: 1.0,
    voice: 'male',
    outputFormat: 'mp3',
  });
}

export async function synthesizeHadith(
  hadithText: string,
  language: 'ar' | 'en' = 'en'
): Promise<TTSResult> {
  return synthesizeSpeech({
    text: hadithText,
    language,
    speed: 0.95,
    voice: 'male',
    outputFormat: 'mp3',
  });
}

export async function synthesizeNote(
  noteText: string,
  language: 'ar' | 'en' | 'fr' = 'en'
): Promise<TTSResult> {
  return synthesizeSpeech({
    text: noteText,
    language,
    speed: 1.0,
    voice: 'female',
    outputFormat: 'mp3',
  });
}

export async function synthesizeSummary(
  summaryText: string,
  language: 'ar' | 'en' | 'fr' = 'en'
): Promise<TTSResult> {
  return synthesizeSpeech({
    text: summaryText,
    language,
    speed: 1.1,
    voice: 'female',
    outputFormat: 'mp3',
  });
}

export function getAvailableVoices(language: string): string[] {
  const voices = VOICE_MAP[language];
  if (!voices) return ['female'];
  return Object.keys(voices);
}

export function getQuranReaders(): Record<string, string> {
  return { ...ARABIC_QURAN_READERS };
}

function escapeXml(text: string): string {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

function estimateDuration(
  text: string,
  speed: number,
  language: string
): number {
  const wordsPerMinute: Record<string, number> = {
    en: 150,
    ar: 120,
    fr: 140,
  };
  const wpm = wordsPerMinute[language] ?? 150;
  const wordCount = text.split(/\s+/).length;
  const baseMinutes = wordCount / wpm;
  return Math.round((baseMinutes / speed) * 60 * 1000);
}
