import 'package:flutter/material.dart';

import '../domain/entities/coding_lesson.dart';

class LessonTile extends StatelessWidget {
  final CodingLesson lesson;
  final VoidCallback? onTap;

  const LessonTile({
    super.key,
    required this.lesson,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.isCompleted;
    final isLocked = lesson.status == LessonStatus.notStarted && lesson.order > 1;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: isLocked ? null : onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.1)
                : isLocked
                    ? Colors.grey.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 24)
                : isLocked
                    ? Icon(Icons.lock_rounded,
                        color: Colors.grey[400], size: 22)
                    : Icon(
                        _typeIcon(lesson.type),
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isLocked ? Colors.grey : null,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _typeColor(lesson.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                lesson.typeDisplayName,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _typeColor(lesson.type),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${lesson.estimatedMinutes} min',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const SizedBox(width: 8),
            Text(
              '+${lesson.xpReward} XP',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.amber[700],
              ),
            ),
          ],
        ),
        trailing: isCompleted
            ? Text(
                '${lesson.score ?? 0}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.green,
                ),
              )
            : isLocked
                ? null
                : Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      ),
    );
  }

  IconData _typeIcon(LessonType type) {
    switch (type) {
      case LessonType.concept:
        return Icons.lightbulb_outline_rounded;
      case LessonType.exercise:
        return Icons.code_rounded;
      case LessonType.quiz:
        return Icons.quiz_rounded;
      case LessonType.project:
        return Icons.build_rounded;
    }
  }

  Color _typeColor(LessonType type) {
    switch (type) {
      case LessonType.concept:
        return Colors.blue;
      case LessonType.exercise:
        return Colors.purple;
      case LessonType.quiz:
        return Colors.orange;
      case LessonType.project:
        return Colors.teal;
    }
  }
}
