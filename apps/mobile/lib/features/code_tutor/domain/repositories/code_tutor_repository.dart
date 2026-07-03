import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coding_lesson.dart';
import '../entities/tutor_session.dart';
import '../entities/tutor_progress.dart';

abstract class CodeTutorRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getAvailableLanguages();

  Future<Either<Failure, List<CodingLesson>>> getLessons(String language);

  Future<Either<Failure, CodingLesson>> getLessonById(String language, String lessonId);

  Future<Either<Failure, TutorProgress>> getProgress(String language);

  Future<Either<Failure, List<TutorProgress>>> getAllProgress();

  Future<Either<Failure, TutorSession>> startSession(String language, String? lessonId);

  Future<Either<Failure, TutorSession>> sendMessage(String sessionId, String message);

  Future<Either<Failure, CodeReviewResult>> submitCode(
    String sessionId,
    String lessonId,
    String code,
  );

  Future<Either<Failure, String>> getHint(String lessonId, int hintIndex);

  Future<Either<Failure, String>> explainConcept(String sessionId, String lessonId);

  Future<Either<Failure, String>> fixCode(String sessionId, String lessonId, String code);

  Future<Either<Failure, String>> getProjectSuggestion(String sessionId, String lessonId);

  Future<Either<Failure, void>> completeLesson(String lessonId, int score);

  Future<Either<Failure, Map<String, dynamic>>> getStats();
}

class CodeReviewResult {
  final bool isCorrect;
  final int score;
  final String feedback;
  final List<String> suggestions;
  final List<String> hints;

  const CodeReviewResult({
    required this.isCorrect,
    required this.score,
    required this.feedback,
    this.suggestions = const [],
    this.hints = const [],
  });
}
