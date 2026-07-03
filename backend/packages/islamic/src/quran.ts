export interface Surah {
  id: number;
  nameArabic: string;
  nameEnglish: string;
  nameTransliteration: string;
  revelationType: 'Meccan' | 'Medinan';
  totalAyahs: number;
  description: string;
  juzStart?: number;
  pageStart?: number;
}

export interface Ayah {
  id: string;
  surahId: number;
  numberInSurah: number;
  arabicText: string;
  englishTranslation: string;
  frenchTranslation: string;
  transliteration: string;
  tafsir: string;
  juzNumber: number;
  page: number;
}

export interface AudioReciter {
  id: string;
  name: string;
  baseUrl: string;
  format: 'mp3' | 'wav';
}

export interface QuranSearchResult {
  surah: Surah;
  ayah?: Ayah;
  matchType: 'surah_name' | 'arabic_text' | 'english_text';
}

export interface Bookmark {
  id: string;
  surahId: number;
  ayahNumber: number;
  timestamp: Date;
  note?: string;
}

export interface ReadingProgress {
  surahId: number;
  lastAyahRead: number;
  totalAyahs: number;
  percentage: number;
  lastReadAt: Date;
}

const RECITERS: AudioReciter[] = [
  { id: 'mishary', name: 'Mishary Rashid Al-Afasy', baseUrl: 'https://server8.mp3quran.net/afs/', format: 'mp3' },
  { id: 'abdulbasit', name: 'Abdul Basit Abdul Samad', baseUrl: 'https://server7.mp3quran.net/basit/', format: 'mp3' },
  { id: 'sudais', name: 'Abdul Rahman Al-Sudais', baseUrl: 'https://server12.mp3quran.net/sds/', format: 'mp3' },
  { id: 'minshawi', name: 'Mohamed Siddiq El-Minshawi', baseUrl: 'https://server11.mp3quran.net/min/', format: 'mp3' },
  { id: 'husary', name: 'Mahmoud Khalil Al-Husary', baseUrl: 'https://server13.mp3quran.net/husary/', format: 'mp3' },
];

const ALL_SURAHS: Surah[] = [
  { id: 1, nameArabic: 'الفاتحة', nameEnglish: 'The Opening', nameTransliteration: 'Al-Fatiha', revelationType: 'Meccan', totalAyahs: 7, description: 'The Opening - recited in every unit of prayer', juzStart: 1, pageStart: 1 },
  { id: 2, nameArabic: 'البقرة', nameEnglish: 'The Cow', nameTransliteration: 'Al-Baqarah', revelationType: 'Medinan', totalAyahs: 286, description: 'The longest Surah, deals with law and legislation', juzStart: 1, pageStart: 1 },
  { id: 3, nameArabic: 'آل عمران', nameEnglish: 'The Family of Imran', nameTransliteration: 'Ali-Imran', revelationType: 'Medinan', totalAyahs: 200, description: 'Named after the family of Imran', juzStart: 3, pageStart: 50 },
  { id: 4, nameArabic: 'النساء', nameEnglish: 'The Women', nameTransliteration: 'An-Nisa', revelationType: 'Medinan', totalAyahs: 176, description: 'Discusses women\'s rights and family law', juzStart: 4, pageStart: 77 },
  { id: 5, nameArabic: 'المائدة', nameEnglish: 'The Table Spread', nameTransliteration: 'Al-Maidah', revelationType: 'Medinan', totalAyahs: 120, description: 'The Table Spread with food and provisions', juzStart: 6, pageStart: 106 },
  { id: 6, nameArabic: 'الأنعام', nameEnglish: 'The Cattle', nameTransliteration: 'Al-Anam', revelationType: 'Meccan', totalAyahs: 165, description: 'Discusses livestock and monotheism', juzStart: 7, pageStart: 128 },
  { id: 7, nameArabic: 'الأعراف', nameEnglish: 'The Heights', nameTransliteration: 'Al-Araf', revelationType: 'Meccan', totalAyahs: 206, description: 'The Heights between Heaven and Hell', juzStart: 8, pageStart: 151 },
  { id: 8, nameArabic: 'الأنفال', nameEnglish: 'The Spoils of War', nameTransliteration: 'Al-Anfal', revelationType: 'Medinan', totalAyahs: 75, description: 'Rules regarding spoils of war', juzStart: 9, pageStart: 177 },
  { id: 9, nameArabic: 'التوبة', nameEnglish: 'The Repentance', nameTransliteration: 'At-Tawbah', revelationType: 'Medinan', totalAyahs: 129, description: 'The repentance and forgiveness', juzStart: 10, pageStart: 187 },
  { id: 10, nameArabic: 'يونس', nameEnglish: 'Jonah', nameTransliteration: 'Yunus', revelationType: 'Meccan', totalAyahs: 109, description: 'Named after Prophet Yunus (Jonah)', juzStart: 11, pageStart: 208 },
  { id: 11, nameArabic: 'هود', nameEnglish: 'Hud', nameTransliteration: 'Hud', revelationType: 'Meccan', totalAyahs: 123, description: 'Named after Prophet Hud', juzStart: 11, pageStart: 221 },
  { id: 12, nameArabic: 'يوسف', nameEnglish: 'Joseph', nameTransliteration: 'Yusuf', revelationType: 'Meccan', totalAyahs: 111, description: 'The story of Prophet Yusuf (Joseph)', juzStart: 12, pageStart: 235 },
  { id: 13, nameArabic: 'الرعد', nameEnglish: 'The Thunder', nameTransliteration: 'Ar-Ra\'d', revelationType: 'Medinan', totalAyahs: 43, description: 'The Thunder - named after thunderbolts', juzStart: 13, pageStart: 249 },
  { id: 14, nameArabic: 'إبراهيم', nameEnglish: 'Abraham', nameTransliteration: 'Ibrahim', revelationType: 'Meccan', totalAyahs: 52, description: 'Named after Prophet Ibrahim (Abraham)', juzStart: 13, pageStart: 255 },
  { id: 15, nameArabic: 'الحجر', nameEnglish: 'The Rocky Tract', nameTransliteration: 'Al-Hijr', revelationType: 'Meccan', totalAyahs: 99, description: 'The Rocky Tract - where Thamud lived', juzStart: 14, pageStart: 262 },
  { id: 16, nameArabic: 'النحل', nameEnglish: 'The Bee', nameTransliteration: 'An-Nahl', revelationType: 'Meccan', totalAyahs: 128, description: 'The Bee - blessings of creation', juzStart: 14, pageStart: 267 },
  { id: 17, nameArabic: 'الإسراء', nameEnglish: 'The Night Journey', nameTransliteration: 'Al-Isra', revelationType: 'Meccan', totalAyahs: 111, description: 'The Night Journey of Prophet Muhammad', juzStart: 15, pageStart: 282 },
  { id: 18, nameArabic: 'الكهف', nameEnglish: 'The Cave', nameTransliteration: 'Al-Kahf', revelationType: 'Meccan', totalAyahs: 110, description: 'The People of the Cave', juzStart: 15, pageStart: 293 },
  { id: 19, nameArabic: 'مريم', nameEnglish: 'Mary', nameTransliteration: 'Maryam', revelationType: 'Meccan', totalAyahs: 98, description: 'Named after Maryam (Mary), mother of Jesus', juzStart: 16, pageStart: 305 },
  { id: 20, nameArabic: 'طه', nameEnglish: 'Ta-Ha', nameTransliteration: 'Taha', revelationType: 'Meccan', totalAyahs: 135, description: 'Named with letters from the beginning', juzStart: 16, pageStart: 312 },
  { id: 21, nameArabic: 'الأنبياء', nameEnglish: 'The Prophets', nameTransliteration: 'Al-Anbiya', revelationType: 'Meccan', totalAyahs: 112, description: 'Stories of various prophets', juzStart: 17, pageStart: 322 },
  { id: 22, nameArabic: 'الحج', nameEnglish: 'The Pilgrimage', nameTransliteration: 'Al-Hajj', revelationType: 'Medinan', totalAyahs: 78, description: 'The Hajj pilgrimage rituals', juzStart: 17, pageStart: 331 },
  { id: 23, nameArabic: 'المؤمنون', nameEnglish: 'The Believers', nameTransliteration: 'Al-Muminun', revelationType: 'Meccan', totalAyahs: 118, description: 'The characteristics of true believers', juzStart: 18, pageStart: 342 },
  { id: 24, nameArabic: 'النور', nameEnglish: 'The Light', nameTransliteration: 'An-Nur', revelationType: 'Medinan', totalAyahs: 64, description: 'The Light of guidance', juzStart: 18, pageStart: 350 },
  { id: 25, nameArabic: 'الفرقان', nameEnglish: 'The Criterion', nameTransliteration: 'Al-Furqan', revelationType: 'Meccan', totalAyahs: 77, description: 'The Criterion between truth and falsehood', juzStart: 18, pageStart: 359 },
  { id: 26, nameArabic: 'الشعراء', nameEnglish: 'The Poets', nameTransliteration: 'Ash-Shuara', revelationType: 'Meccan', totalAyahs: 227, description: 'The Poets - warned against following them', juzStart: 19, pageStart: 367 },
  { id: 27, nameArabic: 'النمل', nameEnglish: 'The Ant', nameTransliteration: 'An-Naml', revelationType: 'Meccan', totalAyahs: 93, description: 'The story of Solomon and the Ant', juzStart: 19, pageStart: 377 },
  { id: 28, nameArabic: 'القصص', nameEnglish: 'The Stories', nameTransliteration: 'Al-Qasas', revelationType: 'Meccan', totalAyahs: 88, description: 'Stories from the past', juzStart: 20, pageStart: 385 },
  { id: 29, nameArabic: 'العنكبوت', nameEnglish: 'The Spider', nameTransliteration: 'Al-Ankabut', revelationType: 'Meccan', totalAyahs: 69, description: 'The Spider - fragile web of disbelievers', juzStart: 20, pageStart: 396 },
  { id: 30, nameArabic: 'الروم', nameEnglish: 'The Romans', nameTransliteration: 'Ar-Rum', revelationType: 'Meccan', totalAyahs: 60, description: 'The victory of the Romans', juzStart: 21, pageStart: 404 },
  { id: 31, nameArabic: 'لقمان', nameEnglish: 'Luqman', nameTransliteration: 'Luqman', revelationType: 'Meccan', totalAyahs: 34, description: 'Wisdom of Luqman', juzStart: 21, pageStart: 411 },
  { id: 32, nameArabic: 'السجدة', nameEnglish: 'The Prostration', nameTransliteration: 'As-Sajdah', revelationType: 'Meccan', totalAyahs: 30, description: 'The prostration in prayer', juzStart: 21, pageStart: 415 },
  { id: 33, nameArabic: 'الأحزاب', nameEnglish: 'The Combined Forces', nameTransliteration: 'Al-Ahzab', revelationType: 'Medinan', totalAyahs: 73, description: 'The Combined Forces against Muslims', juzStart: 21, pageStart: 418 },
  { id: 34, nameArabic: 'سبأ', nameEnglish: 'Sheba', nameTransliteration: 'Saba', revelationType: 'Meccan', totalAyahs: 54, description: 'The people of Sheba', juzStart: 22, pageStart: 428 },
  { id: 35, nameArabic: 'فاطر', nameEnglish: 'The Originator', nameTransliteration: 'Fatir', revelationType: 'Meccan', totalAyahs: 45, description: 'The Originator of creation', juzStart: 22, pageStart: 434 },
  { id: 36, nameArabic: 'يس', nameEnglish: 'Ya-Sin', nameTransliteration: 'Ya-Sin', revelationType: 'Meccan', totalAyahs: 83, description: 'The heart of the Quran', juzStart: 22, pageStart: 440 },
  { id: 37, nameArabic: 'الصافات', nameEnglish: 'Those Who Set The Ranks', nameTransliteration: 'As-Saffat', revelationType: 'Meccan', totalAyahs: 182, description: 'Those who set the ranks in rows', juzStart: 23, pageStart: 445 },
  { id: 38, nameArabic: 'ص', nameEnglish: 'Sad', nameTransliteration: 'Sad', revelationType: 'Meccan', totalAyahs: 88, description: 'Named with the letter Sad', juzStart: 23, pageStart: 453 },
  { id: 39, nameArabic: 'الزمر', nameEnglish: 'The Troops', nameTransliteration: 'Az-Zumar', revelationType: 'Meccan', totalAyahs: 75, description: 'The Troops - groups of people', juzStart: 23, pageStart: 458 },
  { id: 40, nameArabic: 'غافر', nameEnglish: 'The Forgiver', nameTransliteration: 'Ghafir', revelationType: 'Meccan', totalAyahs: 85, description: 'The Forgiver of sins', juzStart: 24, pageStart: 467 },
  { id: 41, nameArabic: 'فصلت', nameEnglish: 'Explained in Detail', nameTransliteration: 'Fussilat', revelationType: 'Meccan', totalAyahs: 54, description: 'Explained in detail the Quran', juzStart: 24, pageStart: 477 },
  { id: 42, nameArabic: 'الشورى', nameEnglish: 'The Consultation', nameTransliteration: 'Ash-Shura', revelationType: 'Meccan', totalAyahs: 53, description: 'The Consultation in matters', juzStart: 25, pageStart: 483 },
  { id: 43, nameArabic: 'الزخرف', nameEnglish: 'The Ornaments of Gold', nameTransliteration: 'Az-Zukhruf', revelationType: 'Meccan', totalAyahs: 89, description: 'The Ornaments of Gold', juzStart: 25, pageStart: 489 },
  { id: 44, nameArabic: 'الدخان', nameEnglish: 'The Smoke', nameTransliteration: 'Ad-Dukhan', revelationType: 'Meccan', totalAyahs: 59, description: 'The Smoke that appeared', juzStart: 25, pageStart: 496 },
  { id: 45, nameArabic: 'الجاثية', nameEnglish: 'The Crouching', nameTransliteration: 'Al-Jathiyah', revelationType: 'Meccan', totalAyahs: 37, description: 'The Crouching on the Day of Judgment', juzStart: 25, pageStart: 499 },
  { id: 46, nameArabic: 'الأحقاف', nameEnglish: 'The Wind-Curved Sandhills', nameTransliteration: 'Al-Ahqaf', revelationType: 'Meccan', totalAyahs: 35, description: 'The curved sandhills of Aad', juzStart: 26, pageStart: 502 },
  { id: 47, nameArabic: 'محمد', nameEnglish: 'Muhammad', nameTransliteration: 'Muhammad', revelationType: 'Medinan', totalAyahs: 38, description: 'Named after Prophet Muhammad', juzStart: 26, pageStart: 507 },
  { id: 48, nameArabic: 'الفتح', nameEnglish: 'The Victory', nameTransliteration: 'Al-Fath', revelationType: 'Medinan', totalAyahs: 29, description: 'The Victory of Makkah', juzStart: 26, pageStart: 511 },
  { id: 49, nameArabic: 'الحجرات', nameEnglish: 'The Rooms', nameTransliteration: 'Al-Hujurat', revelationType: 'Medinan', totalAyahs: 18, description: 'The Rooms - etiquette of behavior', juzStart: 26, pageStart: 515 },
  { id: 50, nameArabic: 'ق', nameEnglish: 'Qaf', nameTransliteration: 'Qaf', revelationType: 'Meccan', totalAyahs: 45, description: 'Named with the letter Qaf', juzStart: 26, pageStart: 518 },
  { id: 51, nameArabic: 'الذاريات', nameEnglish: 'The Winnowing Winds', nameTransliteration: 'Adh-Dhariyat', revelationType: 'Meccan', totalAyahs: 60, description: 'The Winnowing Winds', juzStart: 26, pageStart: 520 },
  { id: 52, nameArabic: 'الطور', nameEnglish: 'The Mount', nameTransliteration: 'At-Tur', revelationType: 'Meccan', totalAyahs: 49, description: 'The Mount of Sinai', juzStart: 27, pageStart: 523 },
  { id: 53, nameArabic: 'النجم', nameEnglish: 'The Star', nameTransliteration: 'An-Najm', revelationType: 'Meccan', totalAyahs: 62, description: 'The Star - guidance', juzStart: 27, pageStart: 526 },
  { id: 54, nameArabic: 'القمر', nameEnglish: 'The Moon', nameTransliteration: 'Al-Qamar', revelationType: 'Meccan', totalAyahs: 55, description: 'The Moon - split miracle', juzStart: 27, pageStart: 528 },
  { id: 55, nameArabic: 'الرحمن', nameEnglish: 'The Most Merciful', nameTransliteration: 'Ar-Rahman', revelationType: 'Medinan', totalAyahs: 78, description: 'The Most Merciful - repeated blessings', juzStart: 27, pageStart: 531 },
  { id: 56, nameArabic: 'الواقعة', nameEnglish: 'The Inevitable', nameTransliteration: 'Al-Waqiah', revelationType: 'Meccan', totalAyahs: 96, description: 'The Inevitable Day of Judgment', juzStart: 27, pageStart: 534 },
  { id: 57, nameArabic: 'الحديد', nameEnglish: 'The Iron', nameTransliteration: 'Al-Hadid', revelationType: 'Medinan', totalAyahs: 29, description: 'The Iron - strength of faith', juzStart: 27, pageStart: 537 },
  { id: 58, nameArabic: 'المجادلة', nameEnglish: 'The Pleading Woman', nameTransliteration: 'Al-Mujadilah', revelationType: 'Medinan', totalAyahs: 22, description: 'The Pleading Woman', juzStart: 28, pageStart: 542 },
  { id: 59, nameArabic: 'الحشر', nameEnglish: 'The Exile', nameTransliteration: 'Al-Hashr', revelationType: 'Medinan', totalAyahs: 24, description: 'The Exile from Medina', juzStart: 28, pageStart: 545 },
  { id: 60, nameArabic: 'الممتحنة', nameEnglish: 'She That Is Examined', nameTransliteration: 'Al-Mumtahanah', revelationType: 'Medinan', totalAyahs: 13, description: 'The woman tested in faith', juzStart: 28, pageStart: 549 },
  { id: 61, nameArabic: 'الصف', nameEnglish: 'The Ranks', nameTransliteration: 'As-Saff', revelationType: 'Medinan', totalAyahs: 14, description: 'The Ranks in battle and prayer', juzStart: 28, pageStart: 551 },
  { id: 62, nameArabic: 'الجمعة', nameEnglish: 'The Congregation', nameTransliteration: 'Al-Jumu\'ah', revelationType: 'Medinan', totalAyahs: 11, description: 'The Friday Congregation', juzStart: 28, pageStart: 553 },
  { id: 63, nameArabic: 'المنافقون', nameEnglish: 'The Hypocrites', nameTransliteration: 'Al-Munafiqun', revelationType: 'Medinan', totalAyahs: 11, description: 'The Hypocrites - signs of hypocrisy', juzStart: 28, pageStart: 554 },
  { id: 64, nameArabic: 'التغابن', nameEnglish: 'The Mutual Disillusion', nameTransliteration: 'At-Taghabun', revelationType: 'Medinan', totalAyahs: 18, description: 'Mutual Disillusion on Judgment Day', juzStart: 28, pageStart: 556 },
  { id: 65, nameArabic: 'الطلاق', nameEnglish: 'The Divorce', nameTransliteration: 'At-Talaq', revelationType: 'Medinan', totalAyahs: 12, description: 'Rules of divorce', juzStart: 28, pageStart: 558 },
  { id: 66, nameArabic: 'التحريم', nameEnglish: 'The Prohibition', nameTransliteration: 'At-Tahrim', revelationType: 'Medinan', totalAyahs: 12, description: 'The Prohibition', juzStart: 28, pageStart: 560 },
  { id: 67, nameArabic: 'الملك', nameEnglish: 'The Sovereignty', nameTransliteration: 'Al-Mulk', revelationType: 'Meccan', totalAyahs: 30, description: 'The Sovereignty of Allah', juzStart: 29, pageStart: 562 },
  { id: 68, nameArabic: 'القلم', nameEnglish: 'The Pen', nameTransliteration: 'Al-Qalam', revelationType: 'Meccan', totalAyahs: 52, description: 'The Pen - writing of deeds', juzStart: 29, pageStart: 564 },
  { id: 69, nameArabic: 'الحاقة', nameEnglish: 'The Reality', nameTransliteration: 'Al-Haqqah', revelationType: 'Meccan', totalAyahs: 52, description: 'The Reality of the Hereafter', juzStart: 29, pageStart: 566 },
  { id: 70, nameArabic: 'المعارج', nameEnglish: 'The Ascending Stairways', nameTransliteration: 'Al-Ma\'arij', revelationType: 'Meccan', totalAyahs: 44, description: 'The Ascending Stairways to Heaven', juzStart: 29, pageStart: 568 },
  { id: 71, nameArabic: 'نوح', nameEnglish: 'Noah', nameTransliteration: 'Nuh', revelationType: 'Meccan', totalAyahs: 28, description: 'The story of Prophet Nuh (Noah)', juzStart: 29, pageStart: 570 },
  { id: 72, nameArabic: 'الجن', nameEnglish: 'The Jinn', nameTransliteration: 'Al-Jinn', revelationType: 'Meccan', totalAyahs: 28, description: 'The story of the Jinn', juzStart: 29, pageStart: 572 },
  { id: 73, nameArabic: 'المزمل', nameEnglish: 'The Enshrouded One', nameTransliteration: 'Al-Muzzammil', revelationType: 'Meccan', totalAyahs: 20, description: 'The Enshrouded One - night prayer', juzStart: 29, pageStart: 574 },
  { id: 74, nameArabic: 'المدثر', nameEnglish: 'The Cloaked One', nameTransliteration: 'Al-Muddathir', revelationType: 'Meccan', totalAyahs: 56, description: 'The Cloaked One - first revelation', juzStart: 29, pageStart: 575 },
  { id: 75, nameArabic: 'القيامة', nameEnglish: 'The Resurrection', nameTransliteration: 'Al-Qiyamah', revelationType: 'Meccan', totalAyahs: 40, description: 'The Day of Resurrection', juzStart: 29, pageStart: 577 },
  { id: 76, nameArabic: 'الإنسان', nameEnglish: 'The Man', nameTransliteration: 'Al-Insan', revelationType: 'Medinan', totalAyahs: 31, description: 'The creation of mankind', juzStart: 29, pageStart: 578 },
  { id: 77, nameArabic: 'المرسلات', nameEnglish: 'The Emissaries', nameTransliteration: 'Al-Mursalat', revelationType: 'Meccan', totalAyahs: 50, description: 'The Emissaries - winds and angels', juzStart: 29, pageStart: 580 },
  { id: 78, nameArabic: 'النبأ', nameEnglish: 'The Tidings', nameTransliteration: 'An-Naba', revelationType: 'Meccan', totalAyahs: 40, description: 'The Tidings of the Hereafter', juzStart: 30, pageStart: 582 },
  { id: 79, nameArabic: 'النازعات', nameEnglish: 'Those Who Drag Forth', nameTransliteration: 'An-Naziat', revelationType: 'Meccan', totalAyahs: 46, description: 'Those Who Drag Forth souls', juzStart: 30, pageStart: 583 },
  { id: 80, nameArabic: 'عبس', nameEnglish: 'He Frowned', nameTransliteration: 'Abasa', revelationType: 'Meccan', totalAyahs: 42, description: 'He Frowned - Prophet\'s interaction', juzStart: 30, pageStart: 585 },
  { id: 81, nameArabic: 'التكوير', nameEnglish: 'The Overthrowing', nameTransliteration: 'At-Takwir', revelationType: 'Meccan', totalAyahs: 29, description: 'The Overthrowing of stars', juzStart: 30, pageStart: 586 },
  { id: 82, nameArabic: 'الانفطار', nameEnglish: 'The Cleaving', nameTransliteration: 'Al-Infitar', revelationType: 'Meccan', totalAyahs: 19, description: 'The Cleaving of the sky', juzStart: 30, pageStart: 587 },
  { id: 83, nameArabic: 'المطففين', nameEnglish: 'The Defrauding', nameTransliteration: 'Al-Mutaffifin', revelationType: 'Meccan', totalAyahs: 36, description: 'The Defrauding in measurement', juzStart: 30, pageStart: 587 },
  { id: 84, nameArabic: 'الانشقاق', nameEnglish: 'The Sundering', nameTransliteration: 'Al-Inshiqaq', revelationType: 'Meccan', totalAyahs: 25, description: 'The Sundering of the sky', juzStart: 30, pageStart: 589 },
  { id: 85, nameArabic: 'البروج', nameEnglish: 'The Mansions of the Stars', nameTransliteration: 'Al-Buruj', revelationType: 'Meccan', totalAyahs: 22, description: 'The Mansions of the Stars', juzStart: 30, pageStart: 590 },
  { id: 86, nameArabic: 'الطارق', nameEnglish: 'The Morning Star', nameTransliteration: 'At-Tariq', revelationType: 'Meccan', totalAyahs: 17, description: 'The Morning Star - night visitor', juzStart: 30, pageStart: 591 },
  { id: 87, nameArabic: 'الأعلى', nameEnglish: 'The Most High', nameTransliteration: 'Al-A\'la', revelationType: 'Meccan', totalAyahs: 19, description: 'The Most High - glorify Allah', juzStart: 30, pageStart: 591 },
  { id: 88, nameArabic: 'الغاشية', nameEnglish: 'The Overwhelming', nameTransliteration: 'Al-Ghashiyah', revelationType: 'Meccan', totalAyahs: 26, description: 'The Overwhelming Event', juzStart: 30, pageStart: 592 },
  { id: 89, nameArabic: 'الفجر', nameEnglish: 'The Dawn', nameTransliteration: 'Al-Fajr', revelationType: 'Meccan', totalAyahs: 30, description: 'The Dawn - oath by morning', juzStart: 30, pageStart: 593 },
  { id: 90, nameArabic: 'البلد', nameEnglish: 'The City', nameTransliteration: 'Al-Balad', revelationType: 'Meccan', totalAyahs: 20, description: 'The City - Makkah', juzStart: 30, pageStart: 594 },
  { id: 91, nameArabic: 'الشمس', nameEnglish: 'The Sun', nameTransliteration: 'Ash-Shams', revelationType: 'Meccan', totalAyahs: 15, description: 'The Sun - oath by celestial bodies', juzStart: 30, pageStart: 595 },
  { id: 92, nameArabic: 'الليل', nameEnglish: 'The Night', nameTransliteration: 'Al-Layl', revelationType: 'Meccan', totalAyahs: 21, description: 'The Night - contrast with day', juzStart: 30, pageStart: 595 },
  { id: 93, nameArabic: 'الضحى', nameEnglish: 'The Morning Hours', nameTransliteration: 'Ad-Duha', revelationType: 'Meccan', totalAyahs: 11, description: 'The Morning Hours - comfort', juzStart: 30, pageStart: 596 },
  { id: 94, nameArabic: 'الشرح', nameEnglish: 'The Relief', nameTransliteration: 'Ash-Sharh', revelationType: 'Meccan', totalAyahs: 8, description: 'The Relief of the heart', juzStart: 30, pageStart: 596 },
  { id: 95, nameArabic: 'التين', nameEnglish: 'The Fig', nameTransliteration: 'At-Tin', revelationType: 'Meccan', totalAyahs: 8, description: 'The Fig - oath by fruits', juzStart: 30, pageStart: 597 },
  { id: 96, nameArabic: 'العلق', nameEnglish: 'The Clot', nameTransliteration: 'Al-Alaq', revelationType: 'Meccan', totalAyahs: 19, description: 'The Clot - first revelation', juzStart: 30, pageStart: 597 },
  { id: 97, nameArabic: 'القدر', nameEnglish: 'The Power', nameTransliteration: 'Al-Qadr', revelationType: 'Meccan', totalAyahs: 5, description: 'The Power - Night of Decree', juzStart: 30, pageStart: 598 },
  { id: 98, nameArabic: 'البينة', nameEnglish: 'The Clear Proof', nameTransliteration: 'Al-Bayyinah', revelationType: 'Medinan', totalAyahs: 8, description: 'The Clear Proof of the Quran', juzStart: 30, pageStart: 598 },
  { id: 99, nameArabic: 'الزلزلة', nameEnglish: 'The Earthquake', nameTransliteration: 'Az-Zalzalah', revelationType: 'Medinan', totalAyahs: 8, description: 'The Earthquake of the Last Day', juzStart: 30, pageStart: 599 },
  { id: 100, nameArabic: 'العاديات', nameEnglish: 'The Courser', nameTransliteration: 'Al-Adiyat', revelationType: 'Meccan', totalAyahs: 11, description: 'The Courser - galloping horses', juzStart: 30, pageStart: 599 },
  { id: 101, nameArabic: 'القارعة', nameEnglish: 'The Calamity', nameTransliteration: 'Al-Qari\'ah', revelationType: 'Meccan', totalAyahs: 11, description: 'The Calamity of Judgment Day', juzStart: 30, pageStart: 600 },
  { id: 102, nameArabic: 'التكاثر', nameEnglish: 'The Rivalry in Worldly Increase', nameTransliteration: 'At-Takathur', revelationType: 'Meccan', totalAyahs: 8, description: 'The Rivalry in wealth', juzStart: 30, pageStart: 600 },
  { id: 103, nameArabic: 'العصر', nameEnglish: 'The Declining Day', nameTransliteration: 'Al-Asr', revelationType: 'Meccan', totalAyahs: 3, description: 'The Declining Day - time', juzStart: 30, pageStart: 601 },
  { id: 104, nameArabic: 'الهمزة', nameEnglish: 'The Traducer', nameTransliteration: 'Al-Humazah', revelationType: 'Meccan', totalAyahs: 9, description: 'The Traducer - backbiting', juzStart: 30, pageStart: 601 },
  { id: 105, nameArabic: 'الفيل', nameEnglish: 'The Elephant', nameTransliteration: 'Al-Fil', revelationType: 'Meccan', totalAyahs: 5, description: 'The Elephant - year of the elephant', juzStart: 30, pageStart: 601 },
  { id: 106, nameArabic: 'قريش', nameEnglish: 'Quraysh', nameTransliteration: 'Quraysh', revelationType: 'Meccan', totalAyahs: 4, description: 'The Quraysh tribe', juzStart: 30, pageStart: 602 },
  { id: 107, nameArabic: 'الماعون', nameEnglish: 'The Small Kindnesses', nameTransliteration: 'Al-Ma\'un', revelationType: 'Meccan', totalAyahs: 7, description: 'The Small Kindnesses', juzStart: 30, pageStart: 602 },
  { id: 108, nameArabic: 'الكوثر', nameEnglish: 'The Abundance', nameTransliteration: 'Al-Kawthar', revelationType: 'Meccan', totalAyahs: 3, description: 'The Abundance - gift to Prophet', juzStart: 30, pageStart: 602 },
  { id: 109, nameArabic: 'الكافرون', nameEnglish: 'The Disbelievers', nameTransliteration: 'Al-Kafirun', revelationType: 'Meccan', totalAyahs: 6, description: 'The Disbelievers - declaration', juzStart: 30, pageStart: 603 },
  { id: 110, nameArabic: 'النصر', nameEnglish: 'The Divine Support', nameTransliteration: 'An-Nasr', revelationType: 'Medinan', totalAyahs: 3, description: 'The Divine Support - victory', juzStart: 30, pageStart: 603 },
  { id: 111, nameArabic: 'المسد', nameEnglish: 'The Palm Fiber', nameTransliteration: 'Al-Masad', revelationType: 'Meccan', totalAyahs: 5, description: 'The Palm Fiber - Abu Lahab', juzStart: 30, pageStart: 603 },
  { id: 112, nameArabic: 'الإخلاص', nameEnglish: 'The Sincerity', nameTransliteration: 'Al-Ikhlas', revelationType: 'Meccan', totalAyahs: 4, description: 'The Sincerity - pure monotheism', juzStart: 30, pageStart: 604 },
  { id: 113, nameArabic: 'الفلق', nameEnglish: 'The Daybreak', nameTransliteration: 'Al-Falaq', revelationType: 'Meccan', totalAyahs: 5, description: 'The Daybreak - seeking refuge', juzStart: 30, pageStart: 604 },
  { id: 114, nameArabic: 'الناس', nameEnglish: 'Mankind', nameTransliteration: 'An-Nas', revelationType: 'Meccan', totalAyahs: 6, description: 'Mankind - seeking refuge from evil', juzStart: 30, pageStart: 604 },
];

const AL_FATIHA: Ayah[] = [
  { id: '1:1', surahId: 1, numberInSurah: 1, arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', englishTranslation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.', frenchTranslation: 'Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux.', transliteration: 'Bismillāhi r-raḥmāni r-raḥīm.', tafsir: 'This is the Basmalah, the opening phrase of every Surah except At-Tawbah. It establishes that all actions should begin with the remembrance of Allah.', juzNumber: 1, page: 1 },
  { id: '1:2', surahId: 1, numberInSurah: 2, arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', englishTranslation: 'All praise is due to Allah, Lord of the worlds.', frenchTranslation: 'Louange à Allah, Seigneur de l\'univers.', transliteration: 'Al-ḥamdu lillāhi rabbi l-ʿālamīn.', tafsir: 'Praise belongs exclusively to Allah who is the Creator, Sustainer, and Sovereign Lord of all existence.', juzNumber: 1, page: 1 },
  { id: '1:3', surahId: 1, numberInSurah: 3, arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ', englishTranslation: 'The Entirely Merciful, the Especially Merciful.', frenchTranslation: 'Le Tout Miséricordieux, le Très Miséricordieux.', transliteration: 'Ar-raḥmāni r-raḥīm.', tafsir: 'Ar-Rahman is the One whose mercy encompasses all creation, and Ar-Rahim is especially merciful to the believers.', juzNumber: 1, page: 1 },
  { id: '1:4', surahId: 1, numberInSurah: 4, arabicText: 'مَالِكِ يَوْمِ الدِّينِ', englishTranslation: 'Sovereign of the Day of Recompense.', frenchTranslation: 'Maître du Jour de la Rétribution.', transliteration: 'Māliki yawmi d-dīn.', tafsir: 'Allah alone is the King and Judge on the Day when all deeds will be accounted for.', juzNumber: 1, page: 1 },
  { id: '1:5', surahId: 1, numberInSurah: 5, arabicText: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', englishTranslation: 'It is You we worship and You we ask for help.', frenchTranslation: 'C\'est Toi [Seul] que nous adorons, et c\'est Toi [Seul] dont nous implorons secours.', transliteration: 'Iyyāka naʿbudu wa iyyāka nastaʿīn.', tafsir: 'The essence of worship - exclusive devotion to Allah and seeking help only from Him.', juzNumber: 1, page: 1 },
  { id: '1:6', surahId: 1, numberInSurah: 6, arabicText: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', englishTranslation: 'Guide us to the straight path.', frenchTranslation: 'Guide-nous dans le droit chemin.', transliteration: 'Ihdinā ṣ-ṣirāṭa l-mustaqīm.', tafsir: 'A supplication to Allah for guidance to the straight path that leads to His pleasure and Paradise.', juzNumber: 1, page: 1 },
  { id: '1:7', surahId: 1, numberInSurah: 7, arabicText: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', englishTranslation: 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.', frenchTranslation: 'Le chemin de ceux que Tu as comblés de faveurs, non pas de ceux qui ont encouru Ta colère, ni des égarés.', transliteration: 'Ṣirāṭa l-ladhīna anʿamta ʿalayhim ghayri l-maghḍūbi ʿalayhim wa lā ḍ-d-dāllīn.', tafsir: 'The straight path is that of the prophets, truthful, martyrs, and righteous. Avoiding the path of those who earned Allah\'s anger and those who went astray.', juzNumber: 1, page: 1 },
];

const AL_BAQARAH_FIRST5: Ayah[] = [
  { id: '2:1', surahId: 2, numberInSurah: 1, arabicText: 'الم', englishTranslation: 'Alif, Lam, Meem.', frenchTranslation: 'Alif Lam Mim.', transliteration: 'Alif Lām Mīm.', tafsir: 'These are disjointed letters whose exact meaning is known only to Allah. They are one of the miracles of the Quran.', juzNumber: 1, page: 1 },
  { id: '2:2', surahId: 2, numberInSurah: 2, arabicText: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ ۚ هُدًى لِّلْمُتَّقِينَ', englishTranslation: 'This is the Book about which there is no doubt, a guidance for those conscious of Allah.', frenchTranslation: 'Ceci est le Livre au sujet duquel il n\'y a aucun doute, un guide pour les pieux.', transliteration: 'Dhālika l-kitābu lā rayba fīh, hudan lil-muttaqīn.', tafsir: 'The Quran is the criterion of truth with no room for doubt. It is guidance specifically for those who have taqwa (God-consciousness).', juzNumber: 1, page: 2 },
  { id: '2:3', surahId: 2, numberInSurah: 3, arabicText: 'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ', englishTranslation: 'Who believe in the unseen, establish prayer, and spend out of what We have provided for them.', frenchTranslation: 'Ceux qui croient en l\'invisible, accomplissent la prière et dépensent de ce que Nous leur avons attribué.', transliteration: 'Alladhīna yu\'minūna bil-ghaybi wa yuqīmūna ṣ-ṣalāta wa mimmā razaqnāhum yunfiqūn.', tafsir: 'Three qualities of the righteous: belief in the unseen (angels,天堂, etc.), establishing regular prayer, and spending in charity.', juzNumber: 1, page: 2 },
  { id: '2:4', surahId: 2, numberInSurah: 4, arabicText: 'وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ', englishTranslation: 'And who believe in what has been revealed to you, [O Muhammad], and what was revealed before you, and of the Hereafter they are certain [in faith].', frenchTranslation: 'Et ceux qui croient à ce qui t\'a été révélé à toi et à ce qui a été révélé avant toi, et qui sont convaincus de l\'au-delà.', transliteration: 'Walladhīna yu\'minūna bimā unzila ilayka wa mā unzila min qablika wa bil-ākhirati hum yūqinūn.', tafsir: 'Complete faith requires believing in all divine revelation - the Quran and previous scriptures, and having certainty in the Hereafter.', juzNumber: 1, page: 2 },
  { id: '2:5', surahId: 2, numberInSurah: 5, arabicText: 'أُولَٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ', englishTranslation: 'Those are upon [right] guidance from their Lord, and it is those who are the successful.', frenchTranslation: 'Ceux-là sont sur la bonne direction de la part de leur Seigneur, et ce sont eux qui réussiront.', transliteration: 'Ulā\'ika ʿalā hudan min rabbihim wa ulā\'ika humu l-mufliḥūn.', tafsir: 'Those who combine these qualities are upon true guidance and will be the successful ones in this life and the Hereafter.', juzNumber: 1, page: 2 },
];

const AL_IMRAN_FIRST5: Ayah[] = [
  { id: '3:1', surahId: 3, numberInSurah: 1, arabicText: 'الم', englishTranslation: 'Alif, Lam, Meem.', frenchTranslation: 'Alif Lam Mim.', transliteration: 'Alif Lām Mīm.', tafsir: 'Disjointed letters at the beginning of the Surah, their precise meaning is known only to Allah.', juzNumber: 3, page: 50 },
  { id: '3:2', surahId: 3, numberInSurah: 2, arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ', englishTranslation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.', frenchTranslation: 'Allah! Point de divinité à part Lui, le Vivant, Celui qui subsiste par Lui-même.', transliteration: 'Allāhu lā ilāha illā huwa l-ḥayyu l-qayyūm.', tafsir: 'Allah is the only true God, the One who eternally lives and sustains all creation without any need.', juzNumber: 3, page: 50 },
  { id: '3:3', surahId: 3, numberInSurah: 3, arabicText: 'نَزَّلَ عَلَيْكَ الْكِتَابَ بِالْحَقِّ مُصَدِّقًا لِّمَا بَيْنَ يَدَيْهِ وَأَنزَلَ التَّوْرَاةَ وَالْإِنجِيلَ', englishTranslation: 'He has sent down upon you, [O Muhammad], the Book in truth, confirming what was before it. And He revealed the Torah and the Gospel.', frenchTranslation: 'Il a fait descendre sur toi le Livre avec la vérité, confirmant les Écritures qui l\'ont précédé. Et Il a fait descendre la Torate et l\'Évangile.', transliteration: 'Nazzala ʿalayka l-kitāba bil-ḥaqqi muṣaddiqan limā bayna yadayhi wa anzala t-tawrāta wal-injīl.', tafsir: 'The Quran confirms the previous scriptures and is itself confirmation of the truth contained in the Torah and Gospel.', juzNumber: 3, page: 50 },
  { id: '3:4', surahId: 3, numberInSurah: 4, arabicText: 'مِن قَبْلُ هُدًى لِّلنَّاسِ وَأَنزَلَ الْفُرْقَانَ ۚ إِنَّ الَّذِينَ كَفَرُوا بِآيَاتِ اللَّهِ لَهُمْ عَذَابٌ شَدِيدٌ ۗ وَاللَّهُ عَزِيزٌ ذُو انتِقَامٍ', englishTranslation: 'Before, as guidance for the people. And He revealed the Criterion. Indeed, those who disbelieve in the verses of Allah will have a severe punishment. And Allah is Exalted in Might, the Owner of Retribution.', frenchTranslation: 'Auparavant, en guise de guide pour les gens. Et Il a fait descendre la distinction (le Coran). Ceux qui mécroient aux revelations d\'Allah auront un châtiment sévère. Allah est Puissant, Maître du châtiment.', transliteration: 'Min qablu hudan lil-nāsi wa anzala l-furqān. Inna l-ladhīna kafarū bi-āyāti l-lāhi lahum ʿadhābun shadīd. Wallāhu ʿazīzun dhū intiqām.', tafsir: 'Previous scriptures were sent as guidance, and the Quran is the Criterion to distinguish truth from falsehood. Disbelievers face severe punishment.', juzNumber: 3, page: 50 },
  { id: '3:5', surahId: 3, numberInSurah: 5, arabicText: 'مَا يَلْفِظُ مِن قَوْلٍ إِلَّا لَدَيْهِ رَقِيبٌ عَتِيدٌ', englishTranslation: 'No word does he utter but there is an observer beside him, ready [to record].', frenchTranslation: 'Il ne prononce aucune parole sans avoir près de lui un observateur prêt [à l\'enregistrer].', transliteration: 'Mā yalfiẓu min qawlin illā ladayhi raqībun ʿatīd.', tafsir: 'Every word spoken is recorded by angels (Kiraman Katibin), emphasizing accountability for all speech.', juzNumber: 3, page: 51 },
];

const SAMPLE_AYAHS: Ayah[] = [...AL_FATIHA, ...AL_BAQARAH_FIRST5, ...AL_IMRAN_FIRST5];

export class QuranService {
  private reciters: AudioReciter[] = RECITERS;
  private bookmarks: Bookmark[] = [];
  private lastReadPositions: Map<number, number> = new Map();
  private readingProgress: Map<number, ReadingProgress> = new Map();

  getAllSurahs(): Surah[] {
    return ALL_SURAHS;
  }

  getSurah(id: number): Surah | undefined {
    return ALL_SURAHS.find(s => s.id === id);
  }

  getSurahByName(name: string): Surah[] {
    const lower = name.toLowerCase();
    return ALL_SURAHS.filter(s =>
      s.nameEnglish.toLowerCase().includes(lower) ||
      s.nameTransliteration.toLowerCase().includes(lower)
    );
  }

  getAyahsForSurah(surahId: number, start?: number, limit?: number): Ayah[] {
    const ayahs = SAMPLE_AYAHS.filter(a => a.surahId === surahId);
    if (start !== undefined && limit !== undefined) {
      return ayahs.slice(start - 1, start - 1 + limit);
    }
    return ayahs;
  }

  getAyahById(id: string): Ayah | undefined {
    return SAMPLE_AYAHS.find(a => a.id === id);
  }

  search(query: string): QuranSearchResult[] {
    const results: QuranSearchResult[] = [];
    const lower = query.toLowerCase();

    for (const surah of ALL_SURAHS) {
      if (
        surah.nameEnglish.toLowerCase().includes(lower) ||
        surah.nameTransliteration.toLowerCase().includes(lower)
      ) {
        results.push({ surah, matchType: 'surah_name' });
      }
    }

    for (const ayah of SAMPLE_AYAHS) {
      if (ayah.englishTranslation.toLowerCase().includes(lower)) {
        const surah = ALL_SURAHS.find(s => s.id === ayah.surahId)!;
        results.push({ surah, ayah, matchType: 'english_text' });
      }
      if (ayah.arabicText.includes(query)) {
        const surah = ALL_SURAHS.find(s => s.id === ayah.surahId)!;
        results.push({ surah, ayah, matchType: 'arabic_text' });
      }
    }

    return results;
  }

  addBookmark(surahId: number, ayahNumber: number, note?: string): Bookmark {
    const bookmark: Bookmark = {
      id: `bm_${Date.now()}_${surahId}_${ayahNumber}`,
      surahId,
      ayahNumber,
      timestamp: new Date(),
      note,
    };
    this.bookmarks.push(bookmark);
    return bookmark;
  }

  removeBookmark(id: string): void {
    this.bookmarks = this.bookmarks.filter(b => b.id !== id);
  }

  getBookmarks(): Bookmark[] {
    return [...this.bookmarks].sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime());
  }

  setLastRead(surahId: number, ayahNumber: number): void {
    this.lastReadPositions.set(surahId, ayahNumber);
    const surah = this.getSurah(surahId);
    if (surah) {
      this.readingProgress.set(surahId, {
        surahId,
        lastAyahRead: ayahNumber,
        totalAyahs: surah.totalAyahs,
        percentage: Math.round((ayahNumber / surah.totalAyahs) * 100),
        lastReadAt: new Date(),
      });
    }
  }

  getLastRead(surahId: number): number | undefined {
    return this.lastReadPositions.get(surahId);
  }

  getReadingProgress(surahId: number): ReadingProgress | undefined {
    return this.readingProgress.get(surahId);
  }

  getAllReadingProgress(): ReadingProgress[] {
    return Array.from(this.readingProgress.values());
  }

  getReciters(): AudioReciter[] {
    return this.reciters;
  }

  getAudioUrl(reciterId: string, surahId: number): string {
    const reciter = this.reciters.find(r => r.id === reciterId);
    if (!reciter) throw new Error(`Reciter ${reciterId} not found`);
    const paddedId = surahId.toString().padStart(3, '0');
    return `${reciter.baseUrl}${paddedId}.mp3`;
  }

  getJuzNumber(surahId: number, ayahNumber: number): number {
    const ayah = SAMPLE_AYAHS.find(a => a.surahId === surahId && a.numberInSurah === ayahNumber);
    return ayah?.juzNumber ?? 1;
  }

  getSurahsByJuz(juz: number): Surah[] {
    return ALL_SURAHS.filter(s => s.juzStart === juz);
  }

  getTotalAyahs(): number {
    return ALL_SURAHS.reduce((sum, s) => sum + s.totalAyahs, 0);
  }
}

export const quranService = new QuranService();
