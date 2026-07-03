import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../widgets/prayer_time_tile.dart';
import '../widgets/qibla_compass.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerNotifier>().loadPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text('Prayer Times', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: Consumer<PrayerNotifier>(
        builder: (context, prayer, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildNextPrayerHeader(prayer),
                _buildHijriDate(prayer),
                _buildPrayerTimesList(prayer),
                const SizedBox(height: 20),
                _buildQiblaCompass(prayer),
                const SizedBox(height: 20),
                _buildCalculationMethodInfo(prayer),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNextPrayerHeader(PrayerNotifier prayer) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Next Prayer',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            prayer.nextPrayer?.name ?? 'Loading...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
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
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHijriDate(PrayerNotifier prayer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        prayer.getHijriDate(),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(PrayerNotifier prayer) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: prayer.prayerTimes.length,
      itemBuilder: (context, index) {
        final prayerTime = prayer.prayerTimes[index];
        return PrayerTimeTile(
          prayerTime: prayerTime,
          isJumuah: prayerTime.name == 'Jumu\'ah',
        );
      },
    );
  }

  Widget _buildQiblaCompass(PrayerNotifier prayer) {
    final qibla = prayer.getQiblaDirection();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Qibla Direction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          QiblaCompass(direction: qibla['direction'] as double),
          const SizedBox(height: 12),
          Text(
            '${(qibla['direction'] as double).toStringAsFixed(1)}° from North',
            style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 4),
          Text(
            'Distance: ${(qibla['distance'] as double).toStringAsFixed(0)} km',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationMethodInfo(PrayerNotifier prayer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1565C0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calculation Method: ${prayer.selectedMethod}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Juristic Method: ${prayer.selectedJuristic}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final prayer = context.read<PrayerNotifier>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Text('Calculation Method', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...prayer.getCalculationMethods().map((method) => RadioListTile<String>(
                    title: Text(method['name']!),
                    subtitle: Text(method['country']!),
                    value: method['id']!,
                    groupValue: prayer.selectedMethod,
                    onChanged: (value) {
                      if (value != null) prayer.setCalculationMethod(value);
                    },
                  )),
                  const Divider(),
                  const Text('Juristic Method', style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    title: const Text("Shafi'i"),
                    value: "Shafi'i",
                    groupValue: prayer.selectedJuristic,
                    onChanged: (value) {
                      if (value != null) prayer.setJuristicMethod(value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Hanafi'),
                    value: 'Hanafi',
                    groupValue: prayer.selectedJuristic,
                    onChanged: (value) {
                      if (value != null) prayer.setJuristicMethod(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
