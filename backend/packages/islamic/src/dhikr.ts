export type DhikrCategory = 'morning' | 'evening' | 'sleep' | 'waking' | 'prayer' | 'custom';

export interface Dhikr {
  id: string;
  name: string;
  nameArabic: string;
  arabicText: string;
  transliteration: string;
  translation: string;
  targetCount: number;
  currentCount: number;
  isCompleted: boolean;
  category: DhikrCategory;
  reward?: string;
}

export interface DhikrSession {
  id: string;
  dhikrId: string;
  startTime: Date;
  endTime?: Date;
  count: number;
  completed: boolean;
}

export interface DhikrGoal {
  id: string;
  dhikrId: string;
  targetCount: number;
  currentCount: number;
  date: string;
  isCompleted: boolean;
}

const MORNING_ADHKAR: Dhikr[] = [
  {
    id: 'morning_1',
    name: 'Tasbih',
    nameArabic: 'التسبيح',
    arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration: 'Subhanallahi wa bihamdihi',
    translation: 'Glory be to Allah and His is all praise.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Allah will have 100 rewards written for you, 100 sins erased, and 100 degrees raised.',
  },
  {
    id: 'morning_2',
    name: 'La ilaha illallah',
    nameArabic: 'لا إله إلا الله',
    arabicText: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ',
    transliteration: 'La ilaha illallahu wahdahu la sharika lahu, lahul mulku wa lahul hamdu wa huwa ala kulli shay\'in qadir',
    translation: 'There is no god but Allah alone, with no partner. To Him belongs sovereignty and praise, and He is over all things competent.',
    targetCount: 10,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Will have a reward equal to freeing ten slaves, 100 good deeds will be written, 100 sins will be erased.',
  },
  {
    id: 'morning_3',
    name: 'Astaghfirullah',
    nameArabic: 'أستغفر الله',
    arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ',
    transliteration: 'Astaghfirullaha al-adheema alladhi la ilaha illa huwa al-hayyu al-qayyumu wa atubu ilayh',
    translation: 'I seek forgiveness of Allah, the Mighty, whom there is no god but He, the Ever-Living, the Self-Subsisting, and I repent to Him.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Will be forgiven even if he fled from the battlefield.',
  },
  {
    id: 'morning_4',
    name: 'Hasbiyallah',
    nameArabic: 'حسبنا الله',
    arabicText: 'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    transliteration: 'Hasbiyallahu la ilaha illa huwa alayhi tawakkaltu wa huwa rabbul arshil adheem',
    translation: 'Allah is sufficient for me. There is no god but Him; in Him I put my trust. He is the Lord of the Mighty Throne.',
    targetCount: 7,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Allah will be sufficient for you in what concerns you.',
  },
  {
    id: 'morning_5',
    name: 'Ayatul Kursi',
    nameArabic: 'آية الكرسي',
    arabicText: 'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَىْءٍ مِنْ عِلْمِهِ إِلاَّ بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyum, la ta\'khudhuhu sinatun wa la nawm, lahu ma fi al-samawati wa ma fi al-ard',
    translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth.',
    targetCount: 1,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Nothing will prevent him from entering Paradise except death.',
  },
  {
    id: 'morning_6',
    name: 'SubhanAllah',
    nameArabic: 'سبحان الله',
    arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
    transliteration: 'Subhanallahi wa bihamdihi subhanallahil adheem',
    translation: 'Glory be to Allah and His praise. Glory be to Allah, the Mighty.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Two beloved words, light on the tongue, heavy on the scale.',
  },
  {
    id: 'morning_7',
    name: 'La hawla',
    nameArabic: 'لا حول ولا قوة',
    arabicText: 'لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
    transliteration: 'La hawla wa la quwwata illa billah',
    translation: 'There is no power nor strength except with Allah.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'A treasure from the treasures of Paradise.',
  },
  {
    id: 'morning_8',
    name: 'Allahumma salli ala Muhammad',
    nameArabic: 'اللهم صل على محمد',
    arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
    transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad',
    translation: 'O Allah, send blessings and peace upon our Prophet Muhammad.',
    targetCount: 10,
    currentCount: 0,
    isCompleted: false,
    category: 'morning',
    reward: 'Allah will send ten blessings upon him.',
  },
];

const EVENING_ADHKAR: Dhikr[] = [
  {
    id: 'evening_1',
    name: 'Tasbih',
    nameArabic: 'التسبيح',
    arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration: 'Subhanallahi wa bihamdihi',
    translation: 'Glory be to Allah and His is all praise.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Allah will have 100 rewards written for you, 100 sins erased, and 100 degrees raised.',
  },
  {
    id: 'evening_2',
    name: 'La ilaha illallah',
    nameArabic: 'لا إله إلا الله',
    arabicText: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ',
    transliteration: 'La ilaha illallahu wahdahu la sharika lahu, lahul mulku wa lahul hamdu wa huwa ala kulli shay\'in qadir',
    translation: 'There is no god but Allah alone, with no partner. To Him belongs sovereignty and praise.',
    targetCount: 10,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Will have a reward equal to freeing ten slaves.',
  },
  {
    id: 'evening_3',
    name: 'Astaghfirullah',
    nameArabic: 'أستغفر الله',
    arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ',
    transliteration: 'Astaghfirullaha al-adheema alladhi la ilaha illa huwa al-hayyu al-qayyumu wa atubu ilayh',
    translation: 'I seek forgiveness of Allah, the Mighty, whom there is no god but He.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Will be forgiven even if he fled from the battlefield.',
  },
  {
    id: 'evening_4',
    name: 'Hasbiyallah',
    nameArabic: 'حسبنا الله',
    arabicText: 'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    transliteration: 'Hasbiyallahu la ilaha illa huwa alayhi tawakkaltu wa huwa rabbul arshil adheem',
    translation: 'Allah is sufficient for me. There is no god but Him; in Him I put my trust.',
    targetCount: 7,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Allah will be sufficient for you in what concerns you.',
  },
  {
    id: 'evening_5',
    name: 'Ayatul Kursi',
    nameArabic: 'آية الكرسي',
    arabicText: 'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ',
    transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyum',
    translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.',
    targetCount: 1,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Nothing will prevent him from entering Paradise except death.',
  },
  {
    id: 'evening_6',
    name: 'SubhanAllah',
    nameArabic: 'سبحان الله',
    arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
    transliteration: 'Subhanallahi wa bihamdihi subhanallahil adheem',
    translation: 'Glory be to Allah and His praise. Glory be to Allah, the Mighty.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Two beloved words, light on the tongue, heavy on the scale.',
  },
  {
    id: 'evening_7',
    name: 'La hawla',
    nameArabic: 'لا حول ولا قوة',
    arabicText: 'لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
    transliteration: 'La hawla wa la quwwata illa billah',
    translation: 'There is no power nor strength except with Allah.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'A treasure from the treasures of Paradise.',
  },
  {
    id: 'evening_8',
    name: 'Allahumma salli ala Muhammad',
    nameArabic: 'اللهم صل على محمد',
    arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
    transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad',
    translation: 'O Allah, send blessings and peace upon our Prophet Muhammad.',
    targetCount: 10,
    currentCount: 0,
    isCompleted: false,
    category: 'evening',
    reward: 'Allah will send ten blessings upon him.',
  },
];

const SLEEP_ADHKAR: Dhikr[] = [
  {
    id: 'sleep_1',
    name: 'Ayatul Kursi',
    nameArabic: 'آية الكرسي',
    arabicText: 'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ',
    transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyum',
    translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.',
    targetCount: 1,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'Allah will appoint a guardian angel for him who will protect him until morning.',
  },
  {
    id: 'sleep_2',
    name: 'Surah Al-Ikhlas',
    nameArabic: 'سورة الإخلاص',
    arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
    transliteration: 'Qul huwallahu ahad, Allahus samad, lam yalid wa lam yulad, wa lam yakun lahu kufuwan ahad',
    translation: 'Say, "He is Allah, [who is] One. Allah, the Eternal Refuge. He neither begets nor is born. Nor is there to Him any equivalent."',
    targetCount: 3,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'Allah will protect him from Shaytan.',
  },
  {
    id: 'sleep_3',
    name: 'Surah Al-Falaq',
    nameArabic: 'سورة الفلق',
    arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
    transliteration: 'Qul a\'udhu bi rabbil falaq, min sharri ma khalaq, wa min sharri ghasiqin iza waqab, wa min sharrin naffathati fil uqad',
    translation: 'Say, "I seek refuge in the Lord of daybreak. From the evil of that which He created. And from the evil of darkness when it settles. And from the evil of the blowers in knots."',
    targetCount: 3,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'Allah will protect him from all evil.',
  },
  {
    id: 'sleep_4',
    name: 'Surah An-Nas',
    nameArabic: 'سورة الناس',
    arabicText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَهِ النَّاسِ، مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
    transliteration: 'Qul a\'udhu bi rabbin nas, malikin nas, ilahin nas, min sharril waswasil khannas',
    translation: 'Say, "I seek refuge in the Lord of mankind, the Sovereign of mankind, the God of mankind, from the evil of the retreating whisperer."',
    targetCount: 3,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'Allah will protect him from Shaytan.',
  },
  {
    id: 'sleep_5',
    name: 'La ilaha illallah',
    nameArabic: 'لا إله إلا الله',
    arabicText: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
    transliteration: 'La ilaha illallahu wahdahu la sharika lahu',
    translation: 'There is no god but Allah alone, with no partner.',
    targetCount: 100,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'A hundred good deeds, a hundred sins erased, and protection from Shaytan.',
  },
  {
    id: 'sleep_6',
    name: 'SubhanAllah',
    nameArabic: 'سبحان الله',
    arabicText: 'سُبْحَانَ اللَّهِ',
    transliteration: 'Subhanallah',
    translation: 'Glory be to Allah.',
    targetCount: 33,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'Light words on the tongue, heavy on the scale.',
  },
  {
    id: 'sleep_7',
    name: 'Alhamdulillah',
    nameArabic: 'الحمد لله',
    arabicText: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    translation: 'All praise is due to Allah.',
    targetCount: 33,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'Fill the scale of good deeds.',
  },
  {
    id: 'sleep_8',
    name: 'Allahu Akbar',
    nameArabic: 'الله أكبر',
    arabicText: 'اللَّهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    translation: 'Allah is the Greatest.',
    targetCount: 33,
    currentCount: 0,
    isCompleted: false,
    category: 'sleep',
    reward: 'A tree in Paradise, leaves falling from it.',
  },
];

const WAKING_ADHKAR: Dhikr[] = [
  {
    id: 'waking_1',
    name: 'Alhamdulillah',
    nameArabic: 'الحمد لله',
    arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    transliteration: 'Alhamdulillahilladhi ahyana ba\'da ma amatana wa ilayhin nushoor',
    translation: 'All praise is due to Allah who gave us life after causing us to die, and to Him is the resurrection.',
    targetCount: 1,
    currentCount: 0,
    isCompleted: false,
    category: 'waking',
    reward: 'Allah will be pleased with him and will admit him to Paradise.',
  },
  {
    id: 'waking_2',
    name: 'La ilaha illallah',
    nameArabic: 'لا إله إلا الله',
    arabicText: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ',
    transliteration: 'La ilaha illallahu wahdahu la sharika lahu, lahul mulku wa lahul hamdu wa huwa ala kulli shay\'in qadir',
    translation: 'There is no god but Allah alone, with no partner. To Him belongs sovereignty and praise.',
    targetCount: 1,
    currentCount: 0,
    isCompleted: false,
    category: 'waking',
    reward: 'Allah will forgive his sins.',
  },
  {
    id: 'waking_3',
    name: 'Ayatul Kursi',
    nameArabic: 'آية الكرسي',
    arabicText: 'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ',
    transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyum',
    translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.',
    targetCount: 1,
    currentCount: 0,
    isCompleted: false,
    category: 'waking',
    reward: 'Nothing will prevent him from entering Paradise.',
  },
];

export class DhikrService {
  private morningAdhkar: Dhikr[] = [...MORNING_ADHKAR];
  private eveningAdhkar: Dhikr[] = [...EVENING_ADHKAR];
  private sleepAdhkar: Dhikr[] = [...SLEEP_ADHKAR];
  private wakingAdhkar: Dhikr[] = [...WAKING_ADHKAR];
  private customAdhkar: Dhikr[] = [];
  private sessions: DhikrSession[] = [];
  private goals: DhikrGoal[] = [];

  getAdhkarByCategory(category: DhikrCategory): Dhikr[] {
    switch (category) {
      case 'morning': return this.morningAdhkar;
      case 'evening': return this.eveningAdhkar;
      case 'sleep': return this.sleepAdhkar;
      case 'waking': return this.wakingAdhkar;
      case 'custom': return this.customAdhkar;
      default: return [];
    }
  }

  incrementDhikr(id: string): Dhikr | undefined {
    const allAdhkar = [...this.morningAdhkar, ...this.eveningAdhkar, ...this.sleepAdhkar, ...this.wakingAdhkar, ...this.customAdhkar];
    const dhikr = allAdhkar.find(d => d.id === id);
    if (dhikr && dhikr.currentCount < dhikr.targetCount) {
      dhikr.currentCount++;
      if (dhikr.currentCount >= dhikr.targetCount) {
        dhikr.isCompleted = true;
      }
      return { ...dhikr };
    }
    return dhikr ? { ...dhikr } : undefined;
  }

  resetDhikr(id: string): void {
    const allAdhkar = [...this.morningAdhkar, ...this.eveningAdhkar, ...this.sleepAdhkar, ...this.wakingAdhkar, ...this.customAdhkar];
    const dhikr = allAdhkar.find(d => d.id === id);
    if (dhikr) {
      dhikr.currentCount = 0;
      dhikr.isCompleted = false;
    }
  }

  resetAll(category?: DhikrCategory): void {
    const adhkar = category ? this.getAdhkarByCategory(category) : [...this.morningAdhkar, ...this.eveningAdhkar, ...this.sleepAdhkar, ...this.wakingAdhkar];
    adhkar.forEach(d => {
      d.currentCount = 0;
      d.isCompleted = false;
    });
  }

  addCustomDhikr(name: string, arabicText: string, transliteration: string, translation: string, targetCount: number): Dhikr {
    const dhikr: Dhikr = {
      id: `custom_${Date.now()}`,
      name,
      nameArabic: name,
      arabicText,
      transliteration,
      translation,
      targetCount,
      currentCount: 0,
      isCompleted: false,
      category: 'custom',
    };
    this.customAdhkar.push(dhikr);
    return dhikr;
  }

  removeCustomDhikr(id: string): void {
    this.customAdhkar = this.customAdhkar.filter(d => d.id !== id);
  }

  getSessionProgress(category: DhikrCategory): { completed: number; total: number; percentage: number } {
    const adhkar = this.getAdhkarByCategory(category);
    const completed = adhkar.filter(d => d.isCompleted).length;
    return {
      completed,
      total: adhkar.length,
      percentage: Math.round((completed / adhkar.length) * 100),
    };
  }

  getDailyGoals(): DhikrGoal[] {
    const today = new Date().toISOString().split('T')[0];
    return this.goals.filter(g => g.date === today);
  }

  setGoal(dhikrId: string, targetCount: number): DhikrGoal {
    const today = new Date().toISOString().split('T')[0];
    const existing = this.goals.find(g => g.dhikrId === dhikrId && g.date === today);
    if (existing) {
      existing.targetCount = targetCount;
      return existing;
    }
    const goal: DhikrGoal = {
      id: `goal_${Date.now()}`,
      dhikrId,
      targetCount,
      currentCount: 0,
      date: today,
      isCompleted: false,
    };
    this.goals.push(goal);
    return goal;
  }

  getCategories(): { id: DhikrCategory; name: string; arabicName: string; icon: string; description: string }[] {
    return [
      { id: 'morning', name: 'Morning Adhkar', arabicName: 'أذكار الصباح', icon: '🌅', description: 'Recite after Fajr prayer until sunrise' },
      { id: 'evening', name: 'Evening Adhkar', arabicName: 'أذكار المساء', icon: '🌇', description: 'Recite after Asr prayer until Maghrib' },
      { id: 'sleep', name: 'Before Sleep', arabicName: 'أذكار النوم', icon: '🌙', description: 'Recite before going to sleep' },
      { id: 'waking', name: 'When Waking', arabicName: 'أذكار الاستيقاظ', icon: '☀️', description: 'Recite upon waking up' },
      { id: 'custom', name: 'Custom Dhikr', arabicName: 'ذكر مخصص', icon: '✨', description: 'Create your own dhikr counter' },
    ];
  }
}

export const dhikrService = new DhikrService();
