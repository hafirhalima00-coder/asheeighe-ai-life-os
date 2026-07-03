import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/entities/prayer_time.dart';

class PrayerNotifier extends ChangeNotifier {
  List<PrayerTime> _prayerTimes = [];
  PrayerTime? _nextPrayer;
  String _nextPrayerCountdown = '';
  String _selectedMethod = 'MWL';
  String _selectedJuristic = "Shafi'i";
  double _latitude = 21.4225;
  double _longitude = 39.8262;
  Timer? _countdownTimer;
  bool _isLoading = false;
  String? _error;

  List<PrayerTime> get prayerTimes => _prayerTimes;
  PrayerTime? get nextPrayer => _nextPrayer;
  String get nextPrayerCountdown => _nextPrayerCountdown;
  String get selectedMethod => _selectedMethod;
  String get selectedJuristic => _selectedJuristic;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PrayerNotifier() {
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_nextPrayer == null) return;
    final now = DateTime.now();
    final diff = _nextPrayer!.time.difference(now);
    if (diff.isNegative) {
      _findNextPrayer();
    } else {
      final hours = diff.inHours;
      final minutes = (diff.inMinutes % 60);
      final seconds = (diff.inSeconds % 60);
      _nextPrayerCountdown =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      notifyListeners();
    }
  }

  Future<void> loadPrayerTimes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _prayerTimes = _calculatePrayerTimes();
      _findNextPrayer();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<PrayerTime> _calculatePrayerTimes() {
    final now = DateTime.now();
    final times = <PrayerTime>[];

    final prayerData = [
      {'name': 'Fajr', 'arabic': 'الفجر', 'hour': 4, 'minute': 30, 'icon': '🌅'},
      {'name': 'Sunrise', 'arabic': 'الشروق', 'hour': 6, 'minute': 0, 'icon': '☀️'},
      {'name': 'Dhuhr', 'arabic': 'الظهر', 'hour': 12, 'minute': 15, 'icon': '🌞'},
      {'name': 'Asr', 'arabic': 'العصر', 'hour': 15, 'minute': 30, 'icon': '🌤️'},
      {'name': 'Maghrib', 'arabic': 'المغرب', 'hour': 18, 'minute': 15, 'icon': '🌅'},
      {'name': 'Isha', 'arabic': 'العشاء', 'hour': 19, 'minute': 45, 'icon': '🌙'},
    ];

    for (final prayer in prayerData) {
      final time = DateTime(now.year, now.month, now.day, prayer['hour']! as int, prayer['minute']! as int);
      times.add(PrayerTime(
        name: prayer['name'] as String,
        nameArabic: prayer['arabic'] as String,
        time: time,
        isNext: false,
        isPassed: now.isAfter(time),
        icon: prayer['icon'] as String,
      ));
    }

    return times;
  }

  void _findNextPrayer() {
    final now = DateTime.now();
    for (final prayer in _prayerTimes) {
      if (prayer.time.isAfter(now)) {
        _nextPrayer = prayer;
        break;
      }
    }
    if (_nextPrayer == null && _prayerTimes.isNotEmpty) {
      _nextPrayer = _prayerTimes.first;
    }
    notifyListeners();
  }

  void setLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    loadPrayerTimes();
  }

  void setCalculationMethod(String method) {
    _selectedMethod = method;
    loadPrayerTimes();
  }

  void setJuristicMethod(String method) {
    _selectedJuristic = method;
    loadPrayerTimes();
  }

  PrayerTime? getNextPrayer() {
    return _nextPrayer;
  }

  PrayerTime? getCurrentPrayer() {
    final now = DateTime.now();
    for (int i = _prayerTimes.length - 1; i >= 0; i--) {
      if (_prayerTimes[i].time.isBefore(now)) {
        return _prayerTimes[i];
      }
    }
    return null;
  }

  Map<String, dynamic> getQiblaDirection() {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final dLng = kaabaLng - _longitude;
    final y = _sin(dLng);
    final x = _cos(_latitude) * _tan(kaabaLat) - _sin(_latitude) * _cos(dLng);
    var direction = _toDegrees(_atan2(y, x));
    direction = (direction + 360) % 360;
    return {'direction': direction, 'distance': _calculateDistance()};
  }

  double _calculateDistance() {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    const R = 6371.0;
    final dLat = _toRadians(kaabaLat - _latitude);
    final dLon = _toRadians(kaabaLng - _longitude);
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(_latitude)) * _cos(_toRadians(kaabaLat)) * _sin(dLon / 2) * _sin(dLon / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return R * c;
  }

  double _sin(double degrees) => (degrees * 3.14159265359 / 180);
  double _cos(double degrees) => (degrees * 3.14159265359 / 180);
  double _tan(double degrees) => (degrees * 3.14159265359 / 180);
  double _sqrt(double x) => x < 0 ? 0 : x;
  double _toDegrees(double radians) => radians * 180 / 3.14159265359;
  double _toRadians(double degrees) => degrees * 3.14159265359 / 180;
  double _atan2(double y, double x) => 0;

  List<Map<String, String>> getCalculationMethods() {
    return [
      {'id': 'MWL', 'name': 'Muslim World League', 'country': 'International'},
      {'id': 'ISNA', 'name': 'ISNA', 'country': 'North America'},
      {'id': 'Egypt', 'name': 'Egyptian Authority', 'country': 'Egypt'},
      {'id': 'Makkah', 'name': 'Umm al-Qura', 'country': 'Saudi Arabia'},
      {'id': 'Karachi', 'name': 'University of Karachi', 'country': 'Pakistan'},
    ];
  }

  String getHijriDate() {
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
    final monthIndex = (month - 1).clamp(0, 11);
    return '$day ${months[monthIndex]} $year AH';
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
}
