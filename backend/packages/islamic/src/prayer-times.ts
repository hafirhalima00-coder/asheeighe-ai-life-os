export type CalculationMethod = 'MWL' | 'ISNA' | 'Egypt' | 'Makkah' | 'Karachi' | 'Tehran';
export type JuristicMethod = 'Shafi\'i' | 'Hanafi';

export interface PrayerTime {
  name: string;
  nameArabic: string;
  time: Date;
  isNext: boolean;
  isPassed: boolean;
  jamaahTime?: Date;
  icon: string;
}

export interface PrayerTimesResult {
  date: Date;
  hijriDate: string;
  fajr: PrayerTime;
  sunrise: PrayerTime;
  dhuhr: PrayerTime;
  asr: PrayerTime;
  maghrib: PrayerTime;
  isha: PrayerTime;
  jumuah?: PrayerTime;
  qiblaDirection: number;
  times: PrayerTime[];
}

export interface QiblaResult {
  direction: number;
  distance: number;
  latitude: number;
  longitude: number;
}

interface MethodParams {
  fajrAngle: number;
  ishaAngle: number;
  maghribMinutes?: number;
}

const METHOD_PARAMS: Record<CalculationMethod, MethodParams> = {
  MWL: { fajrAngle: 18, ishaAngle: 17 },
  ISNA: { fajrAngle: 15, ishaAngle: 15 },
  Egypt: { fajrAngle: 19.5, ishaAngle: 17.5 },
  Makkah: { fajrAngle: 18.5, ishaAngle: 0, maghribMinutes: 0 },
  Karachi: { fajrAngle: 18, ishaAngle: 18 },
  Tehran: { fajrAngle: 17.7, ishaAngle: 14, maghribMinutes: 4.5 },
};

const HIJRI_MONTHS = [
  'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
  'Jumada al-Ula', 'Jumada al-Thani', 'Rajab', 'Sha\'ban',
  'Ramadan', 'Shawwal', 'Dhu al-Qi\'dah', 'Dhu al-Hijjah'
];

function toRadians(degrees: number): number {
  return degrees * Math.PI / 180;
}

function toDegrees(radians: number): number {
  return radians * 180 / Math.PI;
}

function fixAngle(angle: number): number {
  while (angle > 360) angle -= 360;
  while (angle < 0) angle += 360;
  return angle;
}

function fixHour(hour: number): number {
  while (hour > 24) hour -= 24;
  while (hour < 0) hour += 24;
  return hour;
}

function getJulianDate(date: Date): number {
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  let a = Math.floor((14 - month) / 12);
  let y = year + 4800 - a;
  let m = month + 12 * a - 3;
  return day + Math.floor((153 * m + 2) / 5) + 365 * y + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) - 32045;
}

function getSunDeclination(jd: number): number {
  const d = jd - 2451545.0;
  const g = fixAngle(357.529 + 0.98560028 * d);
  const q = fixAngle(280.459 + 0.98564736 * d);
  const L = fixAngle(q + 1.915 * Math.sin(toRadians(g)) + 0.020 * Math.sin(toRadians(2 * g)));
  const e = 23.439 - 0.00000036 * d;
  return toDegrees(Math.asin(Math.sin(toRadians(e)) * Math.sin(toRadians(L))));
}

function getEquationOfTime(jd: number): number {
  const d = jd - 2451545.0;
  const g = fixAngle(357.529 + 0.98560028 * d);
  const q = fixAngle(280.459 + 0.98564736 * d);
  const L = fixAngle(q + 1.915 * Math.sin(toRadians(g)) + 0.020 * Math.sin(toRadians(2 * g)));
  const e = 23.439 - 0.00000036 * d;
  const RA = toDegrees(Math.atan2(Math.cos(toRadians(e)) * Math.sin(toRadians(L)), Math.cos(toRadians(L)))) / 15;
  const eqt = q / 15 - fixHour(RA);
  return eqt * 60;
}

function calculatePrayerTime(
  jd: number,
  angle: number,
  latitude: number,
  longitude: number,
  isRise: boolean = false
): number {
  const decl = getSunDeclination(jd);
  const eqt = getEquationOfTime(jd);
  const midDay = 12 + (-longitude / 15 - eqt / 60);

  if (isRise) {
    const cosHA = (Math.sin(toRadians(-0.833)) - Math.sin(toRadians(latitude)) * Math.sin(toRadians(decl))) /
      (Math.cos(toRadians(latitude)) * Math.cos(toRadians(decl)));
    const HA = toDegrees(Math.acos(cosHA)) / 15;
    return midDay - HA;
  } else {
    const cosHA = (Math.sin(toRadians(-angle)) - Math.sin(toRadians(latitude)) * Math.sin(toRadians(decl))) /
      (Math.cos(toRadians(latitude)) * Math.cos(toRadians(decl)));
    const HA = toDegrees(Math.acos(cosHA)) / 15;
    return midDay + HA;
  }
}

function timeToDate(hours: number, date: Date): Date {
  const d = new Date(date);
  const h = Math.floor(hours);
  const m = Math.floor((hours - h) * 60);
  const s = Math.floor(((hours - h) * 60 - m) * 60);
  d.setHours(h, m, s, 0);
  return d;
}

export class PrayerTimeService {
  private method: CalculationMethod = 'MWL';
  private juristicMethod: JuristicMethod = 'Shafi\'i';

  setMethod(method: CalculationMethod): void {
    this.method = method;
  }

  setJuristicMethod(method: JuristicMethod): void {
    this.juristicMethod = method;
  }

  getMethod(): CalculationMethod {
    return this.method;
  }

  getJuristicMethod(): JuristicMethod {
    return this.juristicMethod;
  }

  calculateTimes(date: Date, latitude: number, longitude: number): PrayerTimesResult {
    const jd = getJulianDate(date);
    const params = METHOD_PARAMS[this.method];

    const fajrTime = calculatePrayerTime(jd, params.fajrAngle, latitude, longitude, true);
    const sunriseTime = calculatePrayerTime(jd, -0.833, latitude, longitude, true);
    const dhuhrTime = 12 + (-longitude / 15 - getEquationOfTime(jd) / 60);

    let asrTime: number;
    const decl = getSunDeclination(jd);
    const asrFactor = this.juristicMethod === 'Hanafi' ? 2 : 1;
    const asrAngle = toDegrees(Math.atan(1 / (asrFactor + Math.tan(toRadians(latitude - decl)))));
    asrTime = calculatePrayerTime(jd, asrAngle, latitude, longitude, false);

    const maghribTime = calculatePrayerTime(jd, 0.833, latitude, longitude, false);
    const ishaTime = params.ishaAngle
      ? calculatePrayerTime(jd, params.ishaAngle, latitude, longitude, false)
      : maghribTime + (params.maghribMinutes || 90) / 60;

    const now = new Date();
    const times = [
      { name: 'Fajr', nameArabic: 'الفجر', time: timeToDate(fajrTime, date), icon: '🌅' },
      { name: 'Sunrise', nameArabic: 'الشروق', time: timeToDate(sunriseTime, date), icon: '☀️' },
      { name: 'Dhuhr', nameArabic: 'الظهر', time: timeToDate(dhuhrTime, date), icon: '🌞' },
      { name: 'Asr', nameArabic: 'العصر', time: timeToDate(asrTime, date), icon: '🌤️' },
      { name: 'Maghrib', nameArabic: 'المغرب', time: timeToDate(maghribTime, date), icon: '🌅' },
      { name: 'Isha', nameArabic: 'العشاء', time: timeToDate(ishaTime, date), icon: '🌙' },
    ];

    let nextFound = false;
    for (let i = 0; i < times.length; i++) {
      if (times[i].name === 'Sunrise') {
        times[i].isPassed = now > times[i].time;
        times[i].isNext = false;
        continue;
      }
      times[i].isPassed = now > times[i].time;
      times[i].isNext = !times[i].isPassed && !nextFound;
      if (times[i].isNext) nextFound = true;
    }

    if (!nextFound) {
      times[0].isNext = true;
    }

    const jumuahTime = new Date(date);
    jumuahTime.setHours(12, 30, 0, 0);

    const qibla = this.calculateQibla(latitude, longitude);

    return {
      date,
      hijriDate: this.getHijriDate(date),
      fajr: { ...times[0], isNext: times[0].isNext, isPassed: times[0].isPassed },
      sunrise: { ...times[1], isNext: false, isPassed: times[1].isPassed },
      dhuhr: { ...times[2], isNext: times[2].isNext, isPassed: times[2].isPassed },
      asr: { ...times[3], isNext: times[3].isNext, isPassed: times[3].isPassed },
      maghrib: { ...times[4], isNext: times[4].isNext, isPassed: times[4].isPassed },
      isha: { ...times[5], isNext: times[5].isNext, isPassed: times[5].isPassed },
      jumuah: { name: 'Jumu\'ah', nameArabic: 'الجمعة', time: jumuahTime, icon: '🕌', isNext: false, isPassed: now > jumuahTime },
      qiblaDirection: qibla.direction,
      times: times as PrayerTime[],
    };
  }

  calculateQibla(latitude: number, longitude: number): QiblaResult {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;

    const dLng = kaabaLng - longitude;
    const y = Math.sin(toRadians(dLng));
    const x = Math.cos(toRadians(latitude)) * Math.tan(toRadians(kaabaLat)) -
              Math.sin(toRadians(latitude)) * Math.cos(toRadians(dLng));
    let direction = toDegrees(Math.atan2(y, x));
    direction = (direction + 360) % 360;

    const R = 6371;
    const dLat = toRadians(kaabaLat - latitude);
    const dLon = toRadians(kaabaLng - longitude);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(toRadians(latitude)) * Math.cos(toRadians(kaabaLat)) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c;

    return { direction, distance, latitude, longitude };
  }

  getHijriDate(date: Date): string {
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
    return `${day} ${HIJRI_MONTHS[monthIndex]} ${year} AH`;
  }

  getNextPrayer(latitude: number, longitude: number): { name: string; timeUntil: string; seconds: number } {
    const result = this.calculateTimes(new Date(), latitude, longitude);
    const nextPrayer = result.times.find(t => t.isNext);
    if (!nextPrayer) return { name: 'Fajr', timeUntil: '00:00:00', seconds: 0 };

    const now = new Date();
    const diff = nextPrayer.time.getTime() - now.getTime();
    const hours = Math.floor(diff / 3600000);
    const minutes = Math.floor((diff % 3600000) / 60000);
    const seconds = Math.floor((diff % 60000) / 1000);

    return {
      name: nextPrayer.name,
      timeUntil: `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`,
      seconds: Math.floor(diff / 1000),
    };
  }

  getRamadanTimes(date: Date, latitude: number, longitude: number): { suhoor: string; iftar: string } {
    const result = this.calculateTimes(date, latitude, longitude);
    const suhoorTime = new Date(result.fajr.time);
    suhoorTime.setMinutes(suhoorTime.getMinutes() - 10);
    return {
      suhoor: suhoorTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }),
      iftar: result.maghrib.time.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }),
    };
  }

  getCalculationMethods(): { id: CalculationMethod; name: string; country: string; description: string }[] {
    return [
      { id: 'MWL', name: 'Muslim World League', country: 'International', description: 'Used in many Muslim countries worldwide' },
      { id: 'ISNA', name: 'Islamic Society of North America', country: 'North America', description: 'Common in North America' },
      { id: 'Egypt', name: 'Egyptian General Authority', country: 'Egypt', description: 'Used in Egypt and some African countries' },
      { id: 'Makkah', name: 'Umm al-Qura University', country: 'Saudi Arabia', description: 'Used in Saudi Arabia' },
      { id: 'Karachi', name: 'University of Islamic Sciences', country: 'Pakistan', description: 'Used in Pakistan and parts of South Asia' },
      { id: 'Tehran', name: 'Institute of Geophysics', country: 'Iran', description: 'Used in Iran' },
    ];
  }

  getJuristicMethods(): { id: JuristicMethod; name: string; description: string }[] {
    return [
      { id: 'Shafi\'i', name: 'Shafi\'i', description: 'Shadow at its minimum length' },
      { id: 'Hanafi', name: 'Hanafi', description: 'Shadow is twice its minimum length' },
    ];
  }
}

export const prayerTimeService = new PrayerTimeService();
