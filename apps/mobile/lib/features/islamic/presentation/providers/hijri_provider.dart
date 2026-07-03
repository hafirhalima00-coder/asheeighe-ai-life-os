import 'package:flutter/material.dart';
import '../../domain/entities/hijri_date.dart';

class HijriNotifier extends ChangeNotifier {
  HijriDate? _currentHijriDate;
  List<Map<String, dynamic>> _importantDates = [];
  Map<String, dynamic>? _ramadanInfo;
  bool _isLoading = false;

  HijriDate? get currentHijriDate => _currentHijriDate;
  List<Map<String, dynamic>> get importantDates => _importantDates;
  Map<String, dynamic>? get ramadanInfo => _ramadanInfo;
  bool get isLoading => _isLoading;

  HijriNotifier() {
    _calculateCurrentDate();
    _loadImportantDates();
    _calculateRamadanInfo();
  }

  void _calculateCurrentDate() {
    final now = DateTime.now();
    final jd = _getJulianDate(now);
    final l = (jd - 1948440 + 10632).floor();
    final n = ((l - 1) / 10631).floor();
    final remainder = l - 10631 * n + 354;
    final j = ((10985 - remainder) / 5316).floor() * ((50 * remainder) / 17719).floor() +
        (remainder / 5670).floor() * ((43 * remainder) / 15238).floor();
    final day = remainder - ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() + 29;
    final month = ((24 * day) / 709).floor();
    final year = 30 * n + j - 30;

    final months = ['Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani', 'Jumada al-Ula', 'Jumada al-Thani', 'Rajab', "Sha'ban", 'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah'];
    final monthsArabic = ['مُحَرَّم', 'صَفَر', 'رَبِيع الأَوَّل', 'رَبِيع الثَّانِي', 'جُمَادَى الأُولَى', 'جُمَادَى الثَّانِيَة', 'رَجَب', 'شَعْبَان', 'رَمَضَان', 'شَوَّال', 'ذُو القِعْدَة', 'ذُو الحِجَّة'];
    final monthIndex = (month - 1).clamp(0, 11);

    _currentHijriDate = HijriDate(
      day: day,
      month: monthIndex + 1,
      monthName: months[monthIndex],
      monthNameArabic: monthsArabic[monthIndex],
      year: year,
      gregorianEquivalent: now,
    );
    notifyListeners();
  }

  void _loadImportantDates() {
    _importantDates = [
      {'id': 'islamic_new_year', 'name': 'Islamic New Year', 'nameArabic': 'رأس السنة الهجرية', 'hijriMonth': 1, 'hijriDay': 1, 'icon': '🌙', 'type': 'minor'},
      {'id': 'ashura', 'name': 'Day of Ashura', 'nameArabic': 'يوم عاشوراء', 'hijriMonth': 1, 'hijriDay': 10, 'icon': '💧', 'type': 'recommended'},
      {'id': 'mawlid', 'name': 'Mawlid al-Nabi', 'nameArabic': 'المولد النبوي', 'hijriMonth': 3, 'hijriDay': 12, 'icon': '🌟', 'type': 'major'},
      {'id': 'isra_miraj', 'name': "Isra and Mi'raj", 'nameArabic': 'الإسراء والمعراج', 'hijriMonth': 7, 'hijriDay': 27, 'icon': '✈️', 'type': 'major'},
      {'id': 'ramadan_start', 'name': 'Start of Ramadan', 'nameArabic': 'بداية رمضان', 'hijriMonth': 9, 'hijriDay': 1, 'icon': '🌙', 'type': 'major'},
      {'id': 'laylat_al_qadr', 'name': 'Laylat al-Qadr', 'nameArabic': 'ليلة القدر', 'hijriMonth': 9, 'hijriDay': 27, 'icon': '✨', 'type': 'major'},
      {'id': 'eid_al_fitr', 'name': 'Eid al-Fitr', 'nameArabic': 'عيد الفطر', 'hijriMonth': 10, 'hijriDay': 1, 'icon': '🎉', 'type': 'major'},
      {'id': 'day_of_rafah', 'name': 'Day of Arafah', 'nameArabic': 'يوم عرفة', 'hijriMonth': 12, 'hijriDay': 9, 'icon': '🕋', 'type': 'major'},
      {'id': 'eid_al_adha', 'name': 'Eid al-Adha', 'nameArabic': 'عيد الأضحى', 'hijriMonth': 12, 'hijriDay': 10, 'icon': '🐑', 'type': 'major'},
    ];
    notifyListeners();
  }

  void _calculateRamadanInfo() {
    final now = DateTime.now();
    final hijri = _currentHijriDate;
    if (hijri == null) return;

    final isRamadan = hijri.month == 9;
    final startDate = _hijriToGregorian(hijri.year, 9, 1);
    final endDate = _hijriToGregorian(hijri.year, 9, 30);
    final eidAlFitr = _hijriToGregorian(hijri.year, 10, 1);

    int currentDay = 0;
    int daysRemaining = 0;

    if (isRamadan) {
      currentDay = now.difference(startDate).inDays + 1;
      daysRemaining = 30 - currentDay;
    } else if (now.isBefore(startDate)) {
      daysRemaining = startDate.difference(now).inDays;
    }

    _ramadanInfo = {
      'year': hijri.year,
      'isRamadan': isRamadan,
      'currentDay': currentDay,
      'daysRemaining': daysRemaining,
      'startDate': startDate,
      'endDate': endDate,
      'eidAlFitr': eidAlFitr,
    };
    notifyListeners();
  }

  Map<String, dynamic> getCountdownToEid(String type) {
    final hijri = _currentHijriDate;
    if (hijri == null) return {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};

    final now = DateTime.now();
    DateTime targetDate;

    if (type == 'fitr') {
      targetDate = _hijriToGregorian(hijri.month >= 10 ? hijri.year + 1 : hijri.year, 10, 1);
    } else {
      targetDate = _hijriToGregorian(hijri.year, 12, 10);
    }

    if (targetDate.isBefore(now)) {
      targetDate = DateTime(targetDate.year + 1, targetDate.month, targetDate.day);
    }

    final diff = targetDate.difference(now);
    return {
      'days': diff.inDays,
      'hours': (diff.inHours % 24),
      'minutes': (diff.inMinutes % 60),
      'seconds': (diff.inSeconds % 60),
    };
  }

  DateTime _hijriToGregorian(int year, int month, int day) {
    int jd = ((11 * year + 3) / 30).floor() + 354 * year + 30 * month - ((month - 1) / 2).floor() + day + 1948440 - 385;
    return _gregorianFromJulian(jd);
  }

  DateTime _gregorianFromJulian(int jd) {
    final a = jd + 32044;
    final b = ((4 * a + 3) / 146097).floor();
    final c = a - ((146097 * b) / 4).floor();
    final d = ((4 * c + 3) / 1461).floor();
    final e = c - ((1461 * d) / 4).floor();
    final m = ((5 * e + 2) / 153).floor();
    final day = e - ((153 * m + 2) / 5).floor() + 1;
    final month = m + 3 - 12 * ((m / 10).floor());
    final year = 100 * b + d - 4800 + ((m / 10).floor());
    return DateTime(year, month, day);
  }

  int _getJulianDate(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final a = ((14 - month) / 12).floor();
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day + ((153 * m + 2) / 5).floor() + 365 * y + (y / 4).floor() - (y / 100).floor() + (y / 400).floor() - 32045;
  }

  String getHijriDateDisplay() {
    if (_currentHijriDate == null) return '';
    return '${_currentHijriDate!.day} ${_currentHijriDate!.monthName} ${_currentHijriDate!.year} AH';
  }

  String getGregorianDisplay() {
    if (_currentHijriDate == null) return '';
    final date = _currentHijriDate!.gregorianEquivalent;
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, dynamic>> getIslamicMonths() {
    return [
      {'number': 1, 'name': 'Muharram', 'nameArabic': 'مُحَرَّم', 'days': 30, 'significance': 'Sacred month. Day of Ashura.'},
      {'number': 2, 'name': 'Safar', 'nameArabic': 'صَفَر', 'days': 29, 'significance': 'Second month.'},
      {'number': 3, 'name': 'Rabi al-Awwal', 'nameArabic': 'رَبِيع الأَوَّل', 'days': 30, 'significance': 'Birth of Prophet Muhammad (12th).'},
      {'number': 4, 'name': 'Rabi al-Thani', 'nameArabic': 'رَبِيع الثَّانِي', 'days': 29, 'significance': 'Second spring month.'},
      {'number': 5, 'name': 'Jumada al-Ula', 'nameArabic': 'جُمَادَى الأُولَى', 'days': 30, 'significance': 'First dry month.'},
      {'number': 6, 'name': 'Jumada al-Thani', 'nameArabic': 'جُمَادَى الثَّانِيَة', 'days': 29, 'significance': 'Second dry month.'},
      {'number': 7, 'name': 'Rajab', 'nameArabic': 'رَجَب', 'days': 30, 'significance': 'Sacred month. Isra and Mi\'raj (27th).'},
      {'number': 8, 'name': "Sha'ban", 'nameArabic': 'شَعْبَان', 'days': 29, 'significance': 'Preparation for Ramadan. Mid-Sha\'ban (15th).'},
      {'number': 9, 'name': 'Ramadan', 'nameArabic': 'رَمَضَان', 'days': 30, 'significance': 'Month of fasting. Quran revelation. Laylat al-Qadr.'},
      {'number': 10, 'name': 'Shawwal', 'nameArabic': 'شَوَّال', 'days': 30, 'significance': 'Eid al-Fitr. Six days of fasting recommended.'},
      {'number': 11, 'name': "Dhu al-Qi'dah", 'nameArabic': 'ذُو القِعْدَة', 'days': 29, 'significance': 'Sacred month. Hajj preparation.'},
      {'number': 12, 'name': 'Dhu al-Hijjah', 'nameArabic': 'ذُو الحِجَّة', 'days': 30, 'significance': 'Month of Hajj. Eid al-Adha (10th). Day of Arafah (9th).'},
    ];
  }
}
