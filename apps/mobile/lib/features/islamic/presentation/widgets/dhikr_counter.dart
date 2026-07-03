import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/dhikr.dart';

class DhikrCounter extends StatelessWidget {
  final Dhikr dhikr;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const DhikrCounter({
    super.key,
    required this.dhikr,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: dhikr.isCompleted
            ? Border.all(color: const Color(0xFF2E7D32), width: 2)
            : null,
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
              Expanded(
                child: Text(
                  dhikr.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: dhikr.isCompleted
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF333333),
                  ),
                ),
              ),
              if (dhikr.isCompleted)
                const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            dhikr.arabicText,
            style: const TextStyle(
              fontSize: 28,
              height: 2.0,
              fontFamily: 'Amiri',
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            dhikr.transliteration,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dhikr.translation,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${dhikr.currentCount} / ${dhikr.targetCount}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(dhikr.progress * 100).round()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: dhikr.progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          dhikr.isCompleted
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFD4AF37),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: dhikr.isCompleted
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          onTap();
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: dhikr.isCompleted
                          ? Colors.grey[300]
                          : const Color(0xFF7B1FA2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        dhikr.isCompleted ? 'Completed' : 'Tap to Count',
                        style: TextStyle(
                          color: dhikr.isCompleted ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.refresh, color: Color(0xFF555555)),
                ),
              ),
            ],
          ),
          if (dhikr.reward != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFD4AF37), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dhikr.reward!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
