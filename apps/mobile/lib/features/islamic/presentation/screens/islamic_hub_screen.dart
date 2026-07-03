import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hijri_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/dhikr_provider.dart';
import '../providers/hadith_provider.dart';
import 'quran_surah_list_screen.dart';
import 'hadith_screen.dart';
import 'prayer_times_screen.dart';
import 'dhikr_screen.dart';
import 'hijri_calendar_screen.dart';
import 'quran_bookmarks_screen.dart';
import '../widgets/islamic_header.dart';
import '../widgets/dhikr_counter.dart';
import '../widgets/hadith_card.dart';
import '../widgets/prayer_time_tile.dart';

class IslamicHubScreen extends StatelessWidget {
  const IslamicHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: IslamicHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNextPrayerSection(context),
                  const SizedBox(height: 20),
                  _buildDailyHadith(context),
                  const SizedBox(height: 20),
                  _buildQuickDhikrButton(context),
                  const SizedBox(height: 20),
                  _buildFeatureGrid(context),
                  const SizedBox(height: 20),
                  _buildRamadanSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerSection(BuildContext context) {
    return Consumer<PrayerNotifier>(
      builder: (context, prayer, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Next Prayer',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                prayer.nextPrayer?.name ?? 'Loading...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                prayer.nextPrayer?.formattedTime ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                prayer.nextPrayerCountdown,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyHadith(BuildContext context) {
    return Consumer<HadithNotifier>(
      builder: (context, hadith, child) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HadithScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Daily Hadith',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD4AF37)),
                  ],
                ),
                const SizedBox(height: 12),
                if (hadith.dailyHadith != null) ...[
                  Text(
                    hadith.dailyHadith!.englishTranslation,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '— ${hadith.dailyHadith!.narrator}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ] else
                  const Text('Loading daily hadith...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickDhikrButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DhikrScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFE8C87A)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Quick Dhikr Counter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {'title': 'Quran', 'icon': '📖', 'color': Color(0xFF2E7D32), 'screen': const QuranSurahListScreen()},
      {'title': 'Hadith', 'icon': '📚', 'color': Color(0xFFD4AF37), 'screen': const HadithScreen()},
      {'title': 'Prayer Times', 'icon': '🕌', 'color': Color(0xFF1565C0), 'screen': const PrayerTimesScreen()},
      {'title': 'Dhikr', 'icon': '✨', 'color': Color(0xFF7B1FA2), 'screen': const DhikrScreen()},
      {'title': 'Calendar', 'icon': '📅', 'color': Color(0xFFE65100), 'screen': const HijriCalendarScreen()},
      {'title': 'Bookmarks', 'icon': '🔖', 'color': Color(0xFF00838F), 'screen': const QuranBookmarksScreen()},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => feature['screen'] as Widget),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      feature['icon'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRamadanSection(BuildContext context) {
    return Consumer<HijriNotifier>(
      builder: (context, hijri, child) {
        final ramadanInfo = hijri.ramadanInfo;
        if (ramadanInfo == null || !(ramadanInfo['isRamadan'] as bool)) {
          final countdown = hijri.getCountdownToEid('fitr');
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7B1FA2).withOpacity(0.8),
                  const Color(0xFF9C27B0).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  '🌙',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ramadan Countdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${countdown['days']} days to Eid al-Fitr',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('🌙', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              const Text(
                'Ramadan Mubarak!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Day ${ramadanInfo['currentDay']} of 30',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                '${ramadanInfo['daysRemaining']} days until Eid',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
