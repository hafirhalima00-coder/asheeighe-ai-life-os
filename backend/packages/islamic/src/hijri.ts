export interface HijriDate {
  day: number;
  month: number;
  monthName: string;
  monthNameArabic: string;
  year: number;
  gregorianEquivalent: Date;
}

export interface IslamicMonth {
  number: number;
  name: string;
  nameArabic: string;
  days: number;
  significance: string;
}

export interface ImportantDate {
  id: string;
  name: string;
  nameArabic: string;
  hijriMonth: number;
  hijriDay: number;
  description: string;
  icon: string;
  type: 'major' | 'minor' | 'recommended';
}

export interface RamadanInfo {
  year: number;
  startDate: Date;
  endDate: Date;
  daysCount: number;
  laylatAlQadr: Date;
  eidAlFitr: Date;
  daysRemaining: number;
  currentDay: number;
}

const HIJRI_MONTHS: IslamicMonth[] = [
  { number: 1, name: 'Muharram', nameArabic: 'مُحَرَّم', days: 30, significance: 'The first month of the Islamic calendar. Day of Ashura (10th) is significant.' },
  { number: 2, name: 'Safar', nameArabic: 'صَفَر', days: 29, significance: 'Historically associated with hardships for early Muslims.' },
  { number: 3, name: 'Rabi al-Awwal', nameArabic: 'رَبِيع الأَوَّل', days: 30, significance: 'The month of the Prophet Muhammad\'s birth (12th).' },
  { number: 4, name: 'Rabi al-Thani', nameArabic: 'رَبِيع الثَّانِي', days: 29, significance: 'The second month of spring.' },
  { number: 5, name: 'Jumada al-Ula', nameArabic: 'جُمَادَى الأُولَى', days: 30, significance: 'First month of dry season.' },
  { number: 6, name: 'Jumada al-Thani', nameArabic: 'جُمَادَى الثَّانِيَة', days: 29, significance: 'Second month of dry season. Death of Fatimah (1st).' },
  { number: 7, name: 'Rajab', nameArabic: 'رَجَب', days: 30, significance: 'Sacred month. Isra and Mi\'raj (27th). Month of repentance.' },
  { number: 8, name: 'Sha\'ban', nameArabic: 'شَعْبَان', days: 29, significance: 'Month of preparation for Ramadan. Mid-Sha\'ban night (15th).' },
  { number: 9, name: 'Ramadan', nameArabic: 'رَمَضَان', days: 30, significance: 'The month of fasting. Revelation of the Quran. Laylat al-Qadr.' },
  { number: 10, name: 'Shawwal', nameArabic: 'شَوَّال', days: 30, significance: 'Month of Eid al-Fitr. Six days of fasting recommended.' },
  { number: 11, name: 'Dhu al-Qi\'dah', nameArabic: 'ذُو القِعْدَة', days: 29, significance: 'Sacred month. Hajj preparation month.' },
  { number: 12, name: 'Dhu al-Hijjah', nameArabic: 'ذُو الحِجَّة', days: 30, significance: 'Month of Hajj. Eid al-Adha (10th). Day of Arafah (9th).' },
];

const IMPORTANT_DATES: ImportantDate[] = [
  { id: 'islamic_new_year', name: 'Islamic New Year', nameArabic: 'رأس السنة الهجرية', hijriMonth: 1, hijriDay: 1, description: 'Beginning of the Islamic calendar year', icon: '🌙', type: 'minor' },
  { id: 'ashura', name: 'Day of Ashura', nameArabic: 'يوم عاشوراء', hijriMonth: 1, hijriDay: 10, description: 'Day of fasting commemorating the saving of Moses', icon: '💧', type: 'recommended' },
  { id: 'mawlid', name: 'Mawlid al-Nabi', nameArabic: 'المولد النبوي', hijriMonth: 3, hijriDay: 12, description: 'Birthday of Prophet Muhammad (peace be upon him)', icon: '🌟', type: 'major' },
  { id: 'isra_miraj', name: 'Isra and Mi\'raj', nameArabic: 'الإسراء والمعراج', hijriMonth: 7, hijriDay: 27, description: 'Night Journey of Prophet Muhammad', icon: '✈️', type: 'major' },
  { id: 'mid_shaaban', name: 'Mid-Sha\'ban', nameArabic: 'نصف شعبان', hijriMonth: 8, hijriDay: 15, description: 'Night of forgiveness and blessings', icon: '🌙', type: 'recommended' },
  { id: 'ramadan_start', name: 'Start of Ramadan', nameArabic: 'بداية رمضان', hijriMonth: 9, hijriDay: 1, description: 'Beginning of the holy month of fasting', icon: '🌙', type: 'major' },
  { id: 'laylat_al_qadr', name: 'Laylat al-Qadr', nameArabic: 'ليلة القدر', hijriMonth: 9, hijriDay: 27, description: 'The Night of Decree - better than a thousand months', icon: '✨', type: 'major' },
  { id: 'eid_al_fitr', name: 'Eid al-Fitr', nameArabic: 'عيد الفطر', hijriMonth: 10, hijriDay: 1, description: 'Festival marking the end of Ramadan', icon: '🎉', type: 'major' },
  { id: 'day_of_rafah', name: 'Day of Arafah', nameArabic: 'يوم عرفة', hijriMonth: 12, hijriDay: 9, description: 'Best day of the year - Day of Arafah', icon: '🕋', type: 'major' },
  { id: 'eid_al_adha', name: 'Eid al-Adha', nameArabic: 'عيد الأضحى', hijriMonth: 12, hijriDay: 10, description: 'Festival of Sacrifice', icon: '🐑', type: 'major' },
];

function getJulianDate(date: Date): number {
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  let a = Math.floor((14 - month) / 12);
  let y = year + 4800 - a;
  let m = month + 12 * a - 3;
  return day + Math.floor((153 * m + 2) / 5) + 365 * y + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) - 32045;
}

function getGregorianFromJulian(jd: number): Date {
  const a = jd + 32044;
  const b = Math.floor((4 * a + 3) / 146097);
  const c = a - Math.floor(146097 * b / 4);
  const d = Math.floor((4 * c + 3) / 1461);
  const e = c - Math.floor(1461 * d / 4);
  const m = Math.floor((5 * e + 2) / 153);
  const day = e - Math.floor((153 * m + 2) / 5) + 1;
  const month = m + 3 - 12 * Math.floor(m / 10);
  const year = 100 * b + d - 4800 + Math.floor(m / 10);
  return new Date(year, month - 1, day);
}

export class HijriService {
  gregorianToHijri(date: Date): HijriDate {
    const jd = getJulianDate(date);
    const l = Math.floor(jd - 1948440 + 10632);
    const n = Math.floor((l - 1) / 10631);
    const remainder = l - 10631 * n + 354;
    const j = Math.floor((10985 - remainder) / 5316) * Math.floor((50 * remainder) / 17719) +
              Math.floor(remainder / 5670) * Math.floor((43 * remainder) / 15238);
    const day = remainder - Math.floor((30 - j) / 15) * Math.floor((17719 * j) / 50) -
                Math.floor(j / 16) * Math.floor((15238 * j) / 43) + 29;
    const month = Math.floor((24 * day) / 709);
    const year = 30 * n + j - 30;

    const monthIndex = Math.max(0, Math.min(11, month - 1));
    const hijriMonth = HIJRI_MONTHS[monthIndex];

    return {
      day,
      month: monthIndex + 1,
      monthName: hijriMonth.name,
      monthNameArabic: hijriMonth.nameArabic,
      year,
      gregorianEquivalent: date,
    };
  }

  hijriToGregorian(year: number, month: number, day: number): Date {
    let jd = Math.floor((11 * year + 3) / 30) + 354 * year + 30 * month - Math.floor((month - 1) / 2) + day + 1948440 - 385;
    return getGregorianFromJulian(jd);
  }

  getMonths(): IslamicMonth[] {
    return HIJRI_MONTHS;
  }

  getImportantDates(): ImportantDate[] {
    return IMPORTANT_DATES;
  }

  getUpcomingImportantDates(): ImportantDate[] {
    const today = new Date();
    const hijriToday = this.gregorianToHijri(today);
    const upcoming: ImportantDate[] = [];

    for (const date of IMPORTANT_DATES) {
      let gregorianDate = this.hijriToGregorian(hijriToday.year, date.hijriMonth, date.hijriDay);
      if (gregorianDate < today) {
        gregorianDate = this.hijriToGregorian(hijriToday.year + 1, date.hijriMonth, date.hijriDay);
      }
      upcoming.push({ ...date });
    }

    return upcoming.sort((a, b) => {
      const aDate = this.hijriToGregorian(hijriToday.year, a.hijriMonth, a.hijriDay);
      const bDate = this.hijriToGregorian(hijriToday.year, b.hijriMonth, b.hijriDay);
      if (aDate < today) aDate.setFullYear(aDate.getFullYear() + 1);
      if (bDate < today) bDate.setFullYear(bDate.getFullYear() + 1);
      return aDate.getTime() - bDate.getTime();
    });
  }

  getRamadanInfo(year?: number): RamadanInfo {
    const hijriYear = year || this.gregorianToHijri(new Date()).year;
    const startDate = this.hijriToGregorian(hijriYear, 9, 1);
    const endDate = this.hijriToGregorian(hijriYear, 9, 30);
    const laylatAlQadr = this.hijriToGregorian(hijriYear, 9, 27);
    const eidAlFitr = this.hijriToGregorian(hijriYear, 10, 1);

    const today = new Date();
    const daysCount = 30;
    let currentDay = 0;
    let daysRemaining = 0;

    if (today >= startDate && today <= endDate) {
      currentDay = Math.floor((today.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24)) + 1;
      daysRemaining = daysCount - currentDay;
    } else if (today < startDate) {
      daysRemaining = Math.floor((startDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
    }

    return {
      year: hijriYear,
      startDate,
      endDate,
      daysCount,
      laylatAlQadr,
      eidAlFitr,
      daysRemaining,
      currentDay,
    };
  }

  isRamadan(): boolean {
    const today = new Date();
    const hijri = this.gregorianToHijri(today);
    return hijri.month === 9;
  }

  getCountdownToEid(type: 'fitr' | 'adha'): { days: number; hours: number; minutes: number; seconds: number; totalSeconds: number } {
    const hijri = this.gregorianToHijri(new Date());
    let targetDate: Date;

    if (type === 'fitr') {
      targetDate = this.hijriToGregorian(hijri.month >= 10 ? hijri.year + 1 : hijri.year, 10, 1);
    } else {
      targetDate = this.hijriToGregorian(hijri.month >= 12 && hijri.day >= 10 ? hijri.year + 1 : hijri.year, 12, 10);
    }

    const now = new Date();
    if (targetDate <= now) {
      targetDate = new Date(targetDate.getFullYear() + 1, targetDate.getMonth(), targetDate.getDate());
    }

    const diff = targetDate.getTime() - now.getTime();
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((diff % (1000 * 60)) / 1000);

    return { days, hours, minutes, seconds, totalSeconds: Math.floor(diff / 1000) };
  }

  getHijriDayName(day: number): string {
    const days = ['', 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh', 'Eighth', 'Ninth', 'Tenth',
                  'Eleventh', 'Twelfth', 'Thirteenth', 'Fourteenth', 'Fifteenth', 'Sixteenth', 'Seventeenth',
                  'Eighteenth', 'Nineteenth', 'Twentieth', 'Twenty-first', 'Twenty-second', 'Twenty-third',
                  'Twenty-fourth', 'Twenty-fifth', 'Twenty-sixth', 'Twenty-seventh', 'Twenty-eighth',
                  'Twenty-ninth', 'Thirtieth'];
    return days[day] || `${day}`;
  }
}

export const hijriService = new HijriService();
