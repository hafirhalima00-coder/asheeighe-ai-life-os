import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/coding_lesson.dart';
import '../domain/entities/tutor_session.dart';
import '../domain/entities/tutor_progress.dart';
import '../data/datasources/code_tutor_remote_datasource.dart';
import '../data/datasources/code_tutor_local_datasource.dart';
import '../data/repositories/code_tutor_repository_impl.dart';
import '../domain/repositories/code_tutor_repository.dart';
import '../domain/usecases/get_languages_usecase.dart';
import '../domain/usecases/get_lessons_usecase.dart';
import '../domain/usecases/start_session_usecase.dart';
import '../domain/usecases/send_message_usecase.dart';
import '../domain/usecases/get_progress_usecase.dart';

final codeTutorLocalDataSourceProvider = Provider<CodeTutorLocalDataSource>((ref) {
  return CodeTutorLocalDataSource();
});

final codeTutorRemoteDataSourceProvider = Provider<CodeTutorRemoteDataSource>((ref) {
  return CodeTutorRemoteDataSource(
    baseUrl: 'https://api.asheeighe.app',
  );
});

final codeTutorRepositoryProvider = Provider<CodeTutorRepository>((ref) {
  return CodeTutorRepositoryImpl(
    remoteDataSource: ref.watch(codeTutorRemoteDataSourceProvider),
    localDataSource: ref.watch(codeTutorLocalDataSourceProvider),
  );
});

final getLanguagesUseCaseProvider = Provider<GetLanguagesUseCase>((ref) {
  return GetLanguagesUseCase(ref.watch(codeTutorRepositoryProvider));
});

final getLessonsUseCaseProvider = Provider<GetLessonsUseCase>((ref) {
  return GetLessonsUseCase(ref.watch(codeTutorRepositoryProvider));
});

final startSessionUseCaseProvider = Provider<StartSessionUseCase>((ref) {
  return StartSessionUseCase(ref.watch(codeTutorRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(codeTutorRepositoryProvider));
});

final getProgressUseCaseProvider = Provider<GetProgressUseCase>((ref) {
  return GetProgressUseCase(ref.watch(codeTutorRepositoryProvider));
});

enum TutorMode { help, explain, fix, project }

enum DifficultyLevel { beginner, intermediate, advanced }

class CodeTutorState {
  final List<Map<String, dynamic>> languages;
  final Map<String, TutorProgress> progress;
  final List<CodingLesson> currentLessons;
  final CodingLesson? currentLesson;
  final TutorSession? currentSession;
  final String codeInput;
  final String lastOutput;
  final bool isRunning;
  final String? currentHint;
  final int hintIndex;
  final TutorMode mode;
  final bool isLoading;
  final String? error;
  final DifficultyLevel difficulty;

  const CodeTutorState({
    this.languages = const [],
    this.progress = const {},
    this.currentLessons = const [],
    this.currentLesson,
    this.currentSession,
    this.codeInput = '',
    this.lastOutput = '',
    this.isRunning = false,
    this.currentHint,
    this.hintIndex = 0,
    this.mode = TutorMode.help,
    this.isLoading = false,
    this.error,
    this.difficulty = DifficultyLevel.beginner,
  });

  CodeTutorState copyWith({
    List<Map<String, dynamic>>? languages,
    Map<String, TutorProgress>? progress,
    List<CodingLesson>? currentLessons,
    CodingLesson? currentLesson,
    bool clearLesson = false,
    TutorSession? currentSession,
    bool clearSession = false,
    String? codeInput,
    String? lastOutput,
    bool? isRunning,
    String? currentHint,
    bool clearHint = false,
    int? hintIndex,
    TutorMode? mode,
    bool? isLoading,
    String? error,
    bool clearError = false,
    DifficultyLevel? difficulty,
  }) {
    return CodeTutorState(
      languages: languages ?? this.languages,
      progress: progress ?? this.progress,
      currentLessons: currentLessons ?? this.currentLessons,
      currentLesson: clearLesson ? null : (currentLesson ?? this.currentLesson),
      currentSession: clearSession ? null : (currentSession ?? this.currentSession),
      codeInput: codeInput ?? this.codeInput,
      lastOutput: lastOutput ?? this.lastOutput,
      isRunning: isRunning ?? this.isRunning,
      currentHint: clearHint ? null : (currentHint ?? this.currentHint),
      hintIndex: hintIndex ?? this.hintIndex,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      difficulty: difficulty ?? this.difficulty,
    );
  }

  TutorProgress? progressForLanguage(String language) => progress[language];
}

class CodeTutorNotifier extends Notifier<CodeTutorState> {
  @override
  CodeTutorState build() {
    _loadLanguages();
    return const CodeTutorState(isLoading: true);
  }

  void _loadLanguages() {
    final useCase = ref.read(getLanguagesUseCaseProvider);
    useCase().then((result) {
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message, isLoading: false);
        },
        (languages) {
          state = state.copyWith(languages: languages, isLoading: false);
        },
      );
    });
  }

  Future<void> selectLanguage(String language) async {
    state = state.copyWith(isLoading: true);
    final lessonsResult = await ref.read(getLessonsUseCaseProvider)(language);
    final progressResult = await ref.read(getProgressUseCaseProvider).forLanguage(language);

    lessonsResult.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (lessons) {
        progressResult.fold(
          (failure) {
            state = state.copyWith(
              currentLessons: lessons,
              isLoading: false,
            );
          },
          (progress) {
            state = state.copyWith(
              currentLessons: lessons,
              progress: {...state.progress, language: progress},
              isLoading: false,
            );
          },
        );
      },
    );
  }

  Future<void> selectLesson(CodingLesson lesson) async {
    state = state.copyWith(
      currentLesson: lesson,
      codeInput: lesson.codeExample ?? '',
      currentHint: null,
      hintIndex: 0,
    );
  }

  Future<void> startSession(String language, {String? lessonId}) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(startSessionUseCaseProvider)(language, lessonId: lessonId);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isLoading: false),
      (session) => state = state.copyWith(
        currentSession: session,
        isLoading: false,
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    if (state.currentSession == null) return;

    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      role: 'user',
      content: message,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      currentSession: state.currentSession!.copyWith(
        messages: [...state.currentSession!.messages, userMsg],
      ),
    );

    final result = await ref.read(sendMessageUseCaseProvider)(
      state.currentSession!.id,
      message,
    );

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (session) => state = state.copyWith(currentSession: session),
    );
  }

  void updateCodeInput(String code) {
    state = state.copyWith(codeInput: code);
  }

  void runCode() {
    if (state.currentLesson == null) return;
    state = state.copyWith(isRunning: true);

    Future.delayed(const Duration(seconds: 1), () {
      final expected = state.currentLesson!.expectedOutput ?? '';
      final isCorrect = state.codeInput.trim() == expected.trim();
      state = state.copyWith(
        isRunning: false,
        lastOutput: isCorrect
            ? '✅ Output matches expected result!'
            : '❌ Output does not match. Expected:\n$expected',
      );
    });
  }

  Future<void> submitCode() async {
    if (state.currentSession == null || state.currentLesson == null) return;

    state = state.copyWith(isRunning: true);
    final result = await ref.read(codeTutorRepositoryProvider).submitCode(
      state.currentSession!.id,
      state.currentLesson!.id,
      state.codeInput,
    );

    result.fold(
      (failure) => state = state.copyWith(error: failure.message, isRunning: false),
      (review) {
        state = state.copyWith(
          isRunning: false,
          lastOutput: review.feedback,
          currentHint: review.hints.isNotEmpty ? review.hints.first : null,
        );

        if (review.isCorrect) {
          _completeLesson(review.score);
        }
      },
    );
  }

  void showNextHint() {
    final lesson = state.currentLesson;
    if (lesson == null) return;

    final nextIndex = state.hintIndex + 1;
    if (nextIndex < lesson.hints.length) {
      state = state.copyWith(
        currentHint: lesson.hints[nextIndex],
        hintIndex: nextIndex,
      );
    }
  }

  void clearHint() {
    state = state.copyWith(clearHint: true, hintIndex: 0);
  }

  void setMode(TutorMode mode) {
    state = state.copyWith(mode: mode);
  }

  Future<void> _completeLesson(int score) async {
    final lesson = state.currentLesson;
    if (lesson == null) return;

    await ref.read(codeTutorRepositoryProvider).completeLesson(lesson.id, score);

    final updatedLessons = state.currentLessons.map((l) {
      if (l.id == lesson.id) {
        return l.copyWith(status: LessonStatus.completed, score: score);
      }
      return l;
    }).toList();

    final lang = lesson.language;
    final currentProgress = state.progress[lang];
    final updatedProgress = currentProgress?.copyWith(
      lessonsCompleted: currentProgress.lessonsCompleted + 1,
      score: currentProgress.score + score,
      lastActivity: DateTime.now(),
      completedLessonIds: [...currentProgress.completedLessonIds, lesson.id],
    );

    state = state.copyWith(
      currentLessons: updatedLessons,
      progress: updatedProgress != null
          ? {...state.progress, lang: updatedProgress}
          : state.progress,
    );
  }
}

final codeTutorProvider = NotifierProvider<CodeTutorNotifier, CodeTutorState>(
  CodeTutorNotifier.new,
);
