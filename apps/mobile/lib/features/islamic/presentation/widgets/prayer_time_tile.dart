import 'package:flutter/material.dart';
import '../../domain/entities/prayer_time.dart';

class PrayerTimeTile extends StatelessWidget {
  final PrayerTime prayerTime;
  final bool isJumuah;

  const PrayerTimeTile({
    super.key,
    required this.prayerTime,
    this.isJumuah = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: prayerTime.isNext
            ? const Color(0xFF1565C0).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isJumuah
            ? Border.all(color: const Color(0xFF2E7D32).withOpacity(0.5))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            prayerTime.icon,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      prayerTime.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: prayerTime.isNext ? FontWeight.bold : FontWeight.w500,
                        color: prayerTime.isNext
                            ? const Color(0xFF1565C0)
                            : const Color(0xFF333333),
                      ),
                    ),
                    if (isJumuah) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Jumu'ah",
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  prayerTime.nameArabic,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayerTime.formattedTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: prayerTime.isNext ? FontWeight.bold : FontWeight.w500,
                  color: prayerTime.isNext
                      ? const Color(0xFF1565C0)
                      : prayerTime.isPassed
                          ? Colors.grey
                          : const Color(0xFF333333),
                ),
              ),
              if (prayerTime.isPassed)
                const Text(
                  'Passed',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                )
              else if (prayerTime.isNext)
                const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
