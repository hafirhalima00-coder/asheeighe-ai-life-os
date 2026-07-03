import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/code_tutor_provider.dart';
import '../widgets/language_card.dart';
import 'lesson_list_screen.dart';

class LanguageSelectScreen extends ConsumerWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(codeTutorProvider);
    final notifier = ref.read(codeTutorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Language'),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.languages.isEmpty
              ? const Center(child: Text('No languages available yet.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What would you like to learn?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pick a language to begin your coding journey.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: state.languages.length,
                          itemBuilder: (context, index) {
                            final lang = state.languages[index];
                            final langId = lang['id'] as String;
                            final progress =
                                ref.watch(codeTutorProvider).progressForLanguage(langId);

                            return LanguageCard(
                              name: lang['name'] as String,
                              icon: lang['icon'] as String,
                              description: lang['description'] as String,
                              progress: progress?.progressPercentage ?? 0,
                              level: progress?.levelTitle,
                              onTap: () {
                                notifier.selectLanguage(langId);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LessonListScreen(
                                      language: langId,
                                      languageName: lang['name'] as String,
                                    ),
                                  ),
                                );
                              },
                            ).animate().fadeIn(
                                  duration: 300.ms,
                                  delay: (index * 80).ms,
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
