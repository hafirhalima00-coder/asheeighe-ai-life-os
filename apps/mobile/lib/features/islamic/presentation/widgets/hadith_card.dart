import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/hadith.dart';

class HadithCard extends StatelessWidget {
  final Hadith hadith;

  const HadithCard({super.key, required this.hadith});

  Color _getGradeColor() {
    switch (hadith.grade) {
      case 'sahih': return const Color(0xFF2E7D32);
      case 'hasan': return const Color(0xFFF9A825);
      case 'daif': return const Color(0xFFE53935);
      default: return Colors.grey;
    }
  }

  String _getGradeLabel() {
    switch (hadith.grade) {
      case 'sahih': return 'Sahih';
      case 'hasan': return 'Hasan';
      case 'daif': return "Da'if";
      default: return hadith.grade;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getGradeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getGradeLabel(),
                  style: TextStyle(
                    color: _getGradeColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hadith.collectionDisplayName,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${hadith.bookNumber}:${hadith.hadithNumber}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                    text: '${hadith.englishTranslation}\n\n— ${hadith.narrator}\n(${hadith.collectionDisplayName} ${hadith.bookNumber}:${hadith.hadithNumber})',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hadith copied')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            hadith.arabicText,
            style: const TextStyle(
              fontSize: 24,
              height: 2.0,
              fontFamily: 'Amiri',
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          Text(
            hadith.englishTranslation,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Color(0xFFD4AF37)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hadith.narrator,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
