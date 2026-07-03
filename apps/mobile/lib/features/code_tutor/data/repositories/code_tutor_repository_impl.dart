import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/coding_lesson.dart';
import '../../domain/entities/tutor_session.dart';
import '../../domain/entities/tutor_progress.dart';
import '../../domain/repositories/code_tutor_repository.dart';
import '../datasources/code_tutor_remote_datasource.dart';
import '../datasources/code_tutor_local_datasource.dart';
import '../models/coding_lesson_model.dart';

class CodeTutorRepositoryImpl implements CodeTutorRepository {
  final CodeTutorRemoteDataSource remoteDataSource;
  final CodeTutorLocalDataSource localDataSource;

  CodeTutorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAvailableLanguages() async {
    try {
      final result = await remoteDataSource.getLanguages();
      final languages = (result['languages'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return Right(languages);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load languages.'));
    }
  }

  @override
  Future<Either<Failure, List<CodingLesson>>> getLessons(String language) async {
    try {
      final result = await remoteDataSource.getLessons(language);
      final lessons = (result['lessons'] as List<dynamic>)
          .map((l) => CodingLessonModel.fromJson(l as Map<String, dynamic>).toEntity())
          .toList();
      return Right(lessons);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load lessons.'));
    }
  }

  @override
  Future<Either<Failure, CodingLesson>> getLessonById(String language, String lessonId) async {
    try {
      final result = await remoteDataSource.getLessons(language);
      final lessons = (result['lessons'] as List<dynamic>)
          .map((l) => CodingLessonModel.fromJson(l as Map<String, dynamic>).toEntity())
          .toList();
      final match = lessons.where((l) => l.id == lessonId).firstOrNull;
      if (match == null) {
        return const Left(NotFoundFailure(message: 'Lesson not found.'));
      }
      return Right(match);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load lesson.'));
    }
  }

  @override
  Future<Either<Failure, TutorProgress>> getProgress(String language) async {
    try {
      final result = await remoteDataSource.getProgress(language);
      final progress = TutorProgress(
        language: language,
        level: result['level'] as int? ?? 1,
        lessonsCompleted: result['lessonsCompleted'] as int? ?? 0,
        totalLessons: result['totalLessons'] as int? ?? 30,
        score: (result['score'] as num?)?.toDouble() ?? 0,
        streak: result['streak'] as int? ?? 0,
        completedLessonIds: (result['completedLessonIds'] as List<dynamic>?)?.cast<String>() ?? [],
      );
      return Right(progress);
    } catch (e) {
      return Left(CacheFailure(message: 'No cached progress.'));
    }
  }

  @override
  Future<Either<Failure, List<TutorProgress>>> getAllProgress() async {
    try {
      final result = await remoteDataSource.getAllProgress();
      final progressList = (result['progress'] as List<dynamic>).map((p) {
        final map = p as Map<String, dynamic>;
        return TutorProgress(
          language: map['language'] as String,
          level: map['level'] as int? ?? 1,
          lessonsCompleted: map['lessonsCompleted'] as int? ?? 0,
          totalLessons: map['totalLessons'] as int? ?? 30,
          score: (map['score'] as num?)?.toDouble() ?? 0,
          streak: map['streak'] as int? ?? 0,
          completedLessonIds: (map['completedLessonIds'] as List<dynamic>?)?.cast<String>() ?? [],
        );
      }).toList();
      return Right(progressList);
    } catch (e) {
      return Left(CacheFailure(message: 'No cached progress.'));
    }
  }

  @override
  Future<Either<Failure, TutorSession>> startSession(String language, String? lessonId) async {
    try {
      final result = await remoteDataSource.startSession(language, lessonId);
      final messages = (result['messages'] as List<dynamic>?)?.map((m) {
        final map = m as Map<String, dynamic>;
        return ChatMessage(
          id: map['id'] as String,
          role: map['role'] as String,
          content: map['content'] as String,
          timestamp: DateTime.parse(map['timestamp'] as String),
        );
      }).toList() ?? [];
      return Right(TutorSession(
        id: result['id'] as String,
        language: language,
        messages: messages,
        progress: 0,
        createdAt: DateTime.parse(result['startedAt'] as String),
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to start session.'));
    }
  }

  @override
  Future<Either<Failure, TutorSession>> sendMessage(String sessionId, String message) async {
    try {
      final result = await remoteDataSource.sendMessage(sessionId, message);
      final messages = (result['messages'] as List<dynamic>).map((m) {
        final map = m as Map<String, dynamic>;
        return ChatMessage(
          id: map['id'] as String,
          role: map['role'] as String,
          content: map['content'] as String,
          timestamp: DateTime.parse(map['timestamp'] as String),
        );
      }).toList();
      return Right(TutorSession(
        id: sessionId,
        language: result['language'] as String,
        messages: messages,
        progress: 0,
        createdAt: DateTime.parse(result['startedAt'] as String),
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send message.'));
    }
  }

  @override
  Future<Either<Failure, CodeReviewResult>> submitCode(
    String sessionId,
    String lessonId,
    String code,
  ) async {
    try {
      final result = await remoteDataSource.submitCode(sessionId, lessonId, code);
      return Right(CodeReviewResult(
        isCorrect: result['isCorrect'] as bool? ?? false,
        score: result['score'] as int? ?? 0,
        feedback: result['feedback'] as String? ?? '',
        suggestions: (result['suggestions'] as List<dynamic>?)?.cast<String>() ?? [],
        hints: (result['hints'] as List<dynamic>?)?.cast<String>() ?? [],
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to submit code.'));
    }
  }

  @override
  Future<Either<Failure, String>> getHint(String lessonId, int hintIndex) async {
    try {
      final result = await remoteDataSource.sendMessage(lessonId, 'hint:$hintIndex');
      return Right(result['message'] as String? ?? 'No hint available.');
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get hint.'));
    }
  }

  @override
  Future<Either<Failure, String>> explainConcept(String sessionId, String lessonId) async {
    try {
      final result = await remoteDataSource.sendMessage(sessionId, 'explain:$lessonId');
      return Right(result['message'] as String? ?? 'No explanation available.');
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to explain concept.'));
    }
  }

  @override
  Future<Either<Failure, String>> fixCode(String sessionId, String lessonId, String code) async {
    try {
      final result = await remoteDataSource.sendMessage(sessionId, 'fix:$lessonId:$code');
      return Right(result['message'] as String? ?? 'No fix suggestion available.');
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fix code.'));
    }
  }

  @override
  Future<Either<Failure, String>> getProjectSuggestion(String sessionId, String lessonId) async {
    try {
      final result = await remoteDataSource.sendMessage(sessionId, 'project:$lessonId');
      return Right(result['message'] as String? ?? 'No project suggestion available.');
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get project suggestion.'));
    }
  }

  @override
  Future<Either<Failure, void>> completeLesson(String lessonId, int score) async {
    try {
      await remoteDataSource.completeLesson(lessonId, score);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to complete lesson.'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStats() async {
    try {
      final result = await remoteDataSource.getStats();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: 'No stats available.'));
    }
  }
}
