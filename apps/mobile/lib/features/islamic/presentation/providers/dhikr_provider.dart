import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/dhikr.dart';

class DhikrNotifier extends ChangeNotifier {
  List<Dhikr> _morningAdhkar = [];
  List<Dhikr> _eveningAdhkar = [];
  List<Dhikr> _sleepAdhkar = [];
  List<Dhikr> _wakingAdhkar = [];
  List<Dhikr> _customAdhkar = [];
  String _selectedCategory = 'morning';
  bool _isLoading = false;
  String? _error;

  List<Dhikr> get currentAdhkar => _getAdhkarByCategory(_selectedCategory);
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DhikrNotifier() {
    _initializeAdhkar();
  }

  void _initializeAdhkar() {
    _morningAdhkar = [
      Dhikr(id: 'morning_1', name: 'Tasbih', nameArabic: 'التسبيح', arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', transliteration: 'Subhanallahi wa bihamdihi', translation: 'Glory be to Allah and His is all praise.', targetCount: 100, currentCount: 0, isCompleted: false, category: 'morning', reward: 'Allah will have 100 rewards written for you.'),
      Dhikr(id: 'morning_2', name: 'La ilaha illallah', nameArabic: 'لا إله إلا الله', arabicText: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَىْءٍ قَدِيرٌ', transliteration: 'La ilaha illallahu wahdahu la sharika lahu', translation: 'There is no god but Allah alone, with no partner.', targetCount: 10, currentCount: 0, isCompleted: false, category: 'morning'),
      Dhikr(id: 'morning_3', name: 'Astaghfirullah', nameArabic: 'أستغفر الله', arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ', transliteration: 'Astaghfirullaha al-adheema', translation: 'I seek forgiveness of Allah, the Mighty.', targetCount: 100, currentCount: 0, isCompleted: false, category: 'morning'),
      Dhikr(id: 'morning_4', name: 'Hasbiyallah', nameArabic: 'حسبنا الله', arabicText: 'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ', transliteration: 'Hasbiyallahu la ilaha illa huwa', translation: 'Allah is sufficient for me.', targetCount: 7, currentCount: 0, isCompleted: false, category: 'morning'),
      Dhikr(id: 'morning_5', name: 'Ayatul Kursi', nameArabic: 'آية الكرسي', arabicText: 'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ', transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyum', translation: 'Allah - there is no deity except Him, the Ever-Living.', targetCount: 1, currentCount: 0, isCompleted: false, category: 'morning'),
    ];

    _eveningAdhkar = [
      Dhikr(id: 'evening_1', name: 'Tasbih', nameArabic: 'التسبيح', arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', transliteration: 'Subhanallahi wa bihamdihi', translation: 'Glory be to Allah and His is all praise.', targetCount: 100, currentCount: 0, isCompleted: false, category: 'evening'),
      Dhikr(id: 'evening_2', name: 'La ilaha illallah', nameArabic: 'لا إله إلا الله', arabicText: 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ', transliteration: 'La ilaha illallahu wahdahu la sharika lahu', translation: 'There is no god but Allah alone.', targetCount: 10, currentCount: 0, isCompleted: false, category: 'evening'),
      Dhikr(id: 'evening_3', name: 'Astaghfirullah', nameArabic: 'أستغفر الله', arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ', transliteration: 'Astaghfirullaha al-adheema', translation: 'I seek forgiveness of Allah, the Mighty.', targetCount: 100, currentCount: 0, isCompleted: false, category: 'evening'),
    ];

    _sleepAdhkar = [
      Dhikr(id: 'sleep_1', name: 'Ayatul Kursi', nameArabic: 'آية الكرسي', arabicText: 'اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ', transliteration: 'Allahu la ilaha illa huwa', translation: 'Allah - there is no deity except Him.', targetCount: 1, currentCount: 0, isCompleted: false, category: 'sleep'),
      Dhikr(id: 'sleep_2', name: 'Al-Ikhlas', nameArabic: 'الإخلاص', arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ', transliteration: 'Qul huwallahu ahad', translation: 'Say, He is Allah, the One.', targetCount: 3, currentCount: 0, isCompleted: false, category: 'sleep'),
    ];

    _wakingAdhkar = [
      Dhikr(id: 'waking_1', name: 'Alhamdulillah', nameArabic: 'الحمد لله', arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا', transliteration: 'Alhamdulillahilladhi ahyana', translation: 'All praise is due to Allah who gave us life.', targetCount: 1, currentCount: 0, isCompleted: false, category: 'waking'),
    ];
  }

  List<Dhikr> _getAdhkarByCategory(String category) {
    switch (category) {
      case 'morning': return _morningAdhkar;
      case 'evening': return _eveningAdhkar;
      case 'sleep': return _sleepAdhkar;
      case 'waking': return _wakingAdhkar;
      case 'custom': return _customAdhkar;
      default: return [];
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void incrementDhikr(String dhikrId) {
    HapticFeedback.lightImpact();
    final allAdhkar = [..._morningAdhkar, ..._eveningAdhkar, ..._sleepAdhkar, ..._wakingAdhkar, ..._customAdhkar];
    final dhikr = allAdhkar.firstWhere((d) => d.id == dhikrId);
    if (dhikr.currentCount < dhikr.targetCount) {
      final index = allAdhkar.indexOf(dhikr);
      final updatedDhikr = Dhikr(
        id: dhikr.id,
        name: dhikr.name,
        nameArabic: dhikr.nameArabic,
        arabicText: dhikr.arabicText,
        transliteration: dhikr.transliteration,
        translation: dhikr.translation,
        targetCount: dhikr.targetCount,
        currentCount: dhikr.currentCount + 1,
        isCompleted: dhikr.currentCount + 1 >= dhikr.targetCount,
        category: dhikr.category,
        reward: dhikr.reward,
      );
      
      if (dhikr.category == 'morning') {
        _morningAdhkar[index] = updatedDhikr;
      } else if (dhikr.category == 'evening') {
        _eveningAdhkar[index] = updatedDhikr;
      } else if (dhikr.category == 'sleep') {
        _sleepAdhkar[index] = updatedDhikr;
      } else if (dhikr.category == 'waking') {
        _wakingAdhkar[index] = updatedDhikr;
      } else {
        _customAdhkar[index] = updatedDhikr;
      }
      
      if (updatedDhikr.isCompleted) {
        HapticFeedback.heavyImpact();
      }
      
      notifyListeners();
    }
  }

  void resetDhikr(String dhikrId) {
    final allAdhkar = [..._morningAdhkar, ..._eveningAdhkar, ..._sleepAdhkar, ..._wakingAdhkar, ..._customAdhkar];
    final dhikr = allAdhkar.firstWhere((d) => d.id == dhikrId);
    final index = allAdhkar.indexOf(dhikr);
    final resetDhikr = Dhikr(
      id: dhikr.id,
      name: dhikr.name,
      nameArabic: dhikr.nameArabic,
      arabicText: dhikr.arabicText,
      transliteration: dhikr.transliteration,
      translation: dhikr.translation,
      targetCount: dhikr.targetCount,
      currentCount: 0,
      isCompleted: false,
      category: dhikr.category,
      reward: dhikr.reward,
    );
    
    if (dhikr.category == 'morning') _morningAdhkar[index] = resetDhikr;
    else if (dhikr.category == 'evening') _eveningAdhkar[index] = resetDhikr;
    else if (dhikr.category == 'sleep') _sleepAdhkar[index] = resetDhikr;
    else if (dhikr.category == 'waking') _wakingAdhkar[index] = resetDhikr;
    else _customAdhkar[index] = resetDhikr;
    
    notifyListeners();
  }

  void resetAll() {
    _initializeAdhkar();
    notifyListeners();
  }

  void addCustomDhikr(String name, String arabicText, String transliteration, String translation, int targetCount) {
    _customAdhkar.add(Dhikr(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      nameArabic: name,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      targetCount: targetCount,
      currentCount: 0,
      isCompleted: false,
      category: 'custom',
    ));
    notifyListeners();
  }

  Map<String, dynamic> getCompletionStats() {
    final allAdhkar = [..._morningAdhkar, ..._eveningAdhkar, ..._sleepAdhkar, ..._wakingAdhkar];
    final completed = allAdhkar.where((d) => d.isCompleted).length;
    return {
      'completed': completed,
      'total': allAdhkar.length,
      'percentage': allAdhkar.isNotEmpty ? (completed / allAdhkar.length * 100).round() : 0,
    };
  }
}
