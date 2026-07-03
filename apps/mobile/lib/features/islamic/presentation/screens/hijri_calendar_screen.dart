import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hijri_provider.dart';

class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE65100),
        title: const Text('Islamic Calendar', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<HijriNotifier>(
        builder: (context, hijri, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCurrentDate(hijri),
                _buildMonthGrid(context, hijri),
                const SizedBox(height: 20),
                _buildImportantDates(context, hijri),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentDate(HijriNotifier hijri) {
    final date = hijri.currentHijriDate;
    if (date == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            date.monthNameArabic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${date.day} ${date.monthName} ${date.year} AH',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hijri.getGregorianDisplay(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(BuildContext context, HijriNotifier hijri) {
    final months = hijri.getIslamicMonths();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.2,
        ),
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          final isCurrentMonth = hijri.currentHijriDate?.month == month['number'];
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCurrentMonth
                  ? const Color(0xFFE65100).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: isCurrentMonth
                  ? Border.all(color: const Color(0xFFE65100), width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month['nameArabic'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isCurrentMonth
                        ? const Color(0xFFE65100)
                        : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  month['name'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrentMonth
                        ? const Color(0xFFE65100)
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImportantDates(BuildContext context, HijriNotifier hijri) {
    final dates = hijri.importantDates;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Important Dates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          ...dates.map((date) {
            final countdown = hijri.getCountdownToEid(
              date['id'] == 'eid_al_fitr' ? 'fitr' : 'adha',
            );
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(date['icon'] as String, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          date['nameArabic'] as String,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  if (date['type'] == 'major')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE65100).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${countdown['days']} days',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
