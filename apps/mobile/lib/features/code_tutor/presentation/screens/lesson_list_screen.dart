import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/code_tutor_provider.dart';
import '../widgets/lesson_tile.dart';
import 'code_editor_screen.dart';

class LessonListScreen extends ConsumerStatefulWidget {
  final String language;
  final String languageName;

  const LessonListScreen({
    super.key,
    required this.language,
    required this.languageName,
  });

  @override
  ConsumerState<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends ConsumerState<LessonListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(codeTutorProvider.notifier).selectLanguage(widget.language);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(codeTutorProvider);
    final notifier = ref.read(codeTutorProvider.notifier);
    final progress = state.progressForLanguage(widget.language);

    final beginnerLessons =
        state.currentLessons.where((l) => l.level <= 10).toList();
    final intermediateLessons =
        state.currentLessons.where((l) => l.level > 10 && l.level <= 20).toList();
    final advancedLessons =
        state.currentLessons.where((l) => l.level > 20).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.languageName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Beginner'),
            Tab(text: 'Intermediate'),
            Tab(text: 'Advanced'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (progress != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: progress.progressPercentage,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${progress.level} — ${progress.levelTitle}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${progress.lessonsCompleted}/${progress.totalLessons} lessons · Score: ${progress.score.round()}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _LessonList(
                  lessons: beginnerLessons,
                  notifier: notifier,
                ),
                _LessonList(
                  lessons: intermediateLessons,
                  notifier: notifier,
                ),
                _LessonList(
                  lessons: advancedLessons,
                  notifier: notifier,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonList extends StatelessWidget {
  final List lessons;
  final CodeTutorNotifier notifier;

  const _LessonList({
    required this.lessons,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return const Center(
        child: Text(
          'Lessons coming soon!',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return LessonTile(
          lesson: lesson,
          onTap: () {
            notifier.selectLesson(lesson);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CodeEditorScreen(
                  lesson: lesson,
                  languageName: lesson.language,
                ),
              ),
            );
          },
        ).animate().fadeIn(
              duration: 300.ms,
              delay: (index * 50).ms,
            );
      },
    );
  }
}
