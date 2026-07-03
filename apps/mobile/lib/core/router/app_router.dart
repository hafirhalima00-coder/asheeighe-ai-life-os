import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/navigation/app_shell.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/calendar/presentation/screens/event_detail_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/composio/presentation/screens/composio_screen.dart';
import '../../features/composio/presentation/screens/integration_detail_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/notes/presentation/screens/note_detail_screen.dart';
import '../../features/notes/presentation/screens/note_list_screen.dart';
import '../../features/notes/presentation/screens/notebooks_screen.dart';
import '../../features/reminders/presentation/screens/reminder_detail_screen.dart';
import '../../features/reminders/presentation/screens/reminder_list_screen.dart';
import '../../features/settings/presentation/screens/ai_settings_screen.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/tasks/presentation/screens/task_categories_screen.dart';
import '../../features/tasks/presentation/screens/task_detail_screen.dart';
import '../../features/tasks/presentation/screens/task_list_screen.dart';
import '../../features/islamic/presentation/screens/islamic_hub_screen.dart';
import '../../features/islamic/presentation/screens/quran_surah_list_screen.dart';
import '../../features/islamic/presentation/screens/quran_reader_screen.dart';
import '../../features/islamic/presentation/screens/quran_bookmarks_screen.dart';
import '../../features/islamic/presentation/screens/hadith_screen.dart';
import '../../features/islamic/presentation/screens/prayer_times_screen.dart';
import '../../features/islamic/presentation/screens/dhikr_screen.dart';
import '../../features/islamic/presentation/screens/hijri_calendar_screen.dart';
import '../../features/code_tutor/presentation/screens/language_select_screen.dart';
import '../../features/code_tutor/presentation/screens/lesson_list_screen.dart';
import '../../features/code_tutor/presentation/screens/code_editor_screen.dart';
import '../../features/code_tutor/presentation/screens/tutor_chat_screen.dart';
import '../../features/code_tutor/presentation/screens/progress_screen.dart';
import '../../features/social/presentation/screens/templates_screen.dart';
import '../../features/social/presentation/screens/template_detail_screen.dart';
import '../../features/social/presentation/screens/referral_screen.dart';
import '../../features/social/presentation/screens/share_achievement_screen.dart';
import '../../features/gamification/presentation/screens/achievements_screen.dart';
import '../../features/gamification/presentation/screens/leaderboard_screen.dart';
import '../../features/gamification/presentation/screens/gamification_hub_screen.dart';
import '../../features/subscription/presentation/screens/subscription_manage_screen.dart';
import '../../features/subscription/presentation/screens/paywall_screen.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authNotifierProvider);
  final authState = authAsync.valueOrNull;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final status = authState?.status ?? AuthStatus.unknown;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null;
      if (status == AuthStatus.unknown) return null;

      final isAuthenticated = status == AuthStatus.authenticated;

      if (!isAuthenticated && !isAuthRoute) return '/auth/login';
      if (isAuthenticated && isAuthRoute) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: RouteNames.auth,
        routes: [
          GoRoute(
            path: 'login',
            name: RouteNames.login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register',
            name: RouteNames.register,
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: RouteNames.forgotPassword,
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'task/:taskId',
                name: RouteNames.taskDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => TaskDetailScreen(
                  taskId: state.pathParameters['taskId'] ?? '',
                ),
              ),
              GoRoute(
                path: 'note/:noteId',
                name: RouteNames.noteDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => NoteDetailScreen(
                  noteId: state.pathParameters['noteId'] ?? '',
                ),
              ),
              GoRoute(
                path: 'notebooks',
                name: RouteNames.notebooks,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const NotebooksScreen(),
              ),
              GoRoute(
                path: 'categories',
                name: RouteNames.categories,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TaskCategoriesScreen(),
              ),
              GoRoute(
                path: 'reminders',
                name: RouteNames.reminders,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ReminderListScreen(),
              ),
              GoRoute(
                path: 'reminders/:reminderId',
                name: RouteNames.reminderDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ReminderDetailScreen(
                  reminderId: state.pathParameters['reminderId'] ?? '',
                ),
              ),
              GoRoute(
                path: 'notes',
                name: RouteNames.notes,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const NoteListScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/calendar',
            name: RouteNames.calendar,
            builder: (context, state) => const CalendarScreen(),
            routes: [
              GoRoute(
                path: 'event/:eventId',
                name: RouteNames.eventDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => EventDetailScreen(
                  eventId: state.pathParameters['eventId'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/tasks',
            name: RouteNames.tasks,
            builder: (context, state) => const TaskListScreen(),
          ),
          GoRoute(
            path: '/chat',
            name: RouteNames.chat,
            builder: (context, state) => const ChatListScreen(),
            routes: [
              GoRoute(
                path: ':conversationId',
                name: RouteNames.chatDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ChatScreen(
                  conversationId:
                      state.pathParameters['conversationId'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                name: RouteNames.profile,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ChangePasswordScreen(),
              ),
              GoRoute(
                path: 'composio',
                name: RouteNames.composio,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ComposioScreen(),
              ),
              GoRoute(
                path: 'ai',
                name: RouteNames.aiSettings,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const AISettingsScreen(),
              ),
              GoRoute(
                path: 'integrations/:integrationId',
                name: RouteNames.integrationDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => IntegrationDetailScreen(
                  integrationId:
                      state.pathParameters['integrationId'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/islamic',
            name: RouteNames.islamicHub,
            builder: (context, state) => const IslamicHubScreen(),
            routes: [
              GoRoute(
                path: 'quran',
                name: RouteNames.quranList,
                builder: (context, state) => const QuranSurahListScreen(),
              ),
              GoRoute(
                path: 'quran/:surahId',
                name: RouteNames.quranReader,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => QuranReaderScreen(
                  surahId: int.tryParse(state.pathParameters['surahId'] ?? '1') ?? 1,
                ),
              ),
              GoRoute(
                path: 'quran/bookmarks',
                name: RouteNames.quranBookmarks,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const QuranBookmarksScreen(),
              ),
              GoRoute(
                path: 'hadith',
                name: RouteNames.hadith,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const HadithScreen(),
              ),
              GoRoute(
                path: 'prayer',
                name: RouteNames.prayerTimes,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const PrayerTimesScreen(),
              ),
              GoRoute(
                path: 'dhikr',
                name: RouteNames.dhikr,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const DhikrScreen(),
              ),
              GoRoute(
                path: 'calendar',
                name: RouteNames.hijriCalendar,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const HijriCalendarScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/code-tutor',
            name: RouteNames.codeTutor,
            builder: (context, state) => const LanguageSelectScreen(),
            routes: [
              GoRoute(
                path: ':language',
                name: RouteNames.lessonList,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => LessonListScreen(
                  language: state.pathParameters['language'] ?? '',
                ),
              ),
              GoRoute(
                path: ':language/editor/:lessonId',
                name: RouteNames.codeEditor,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => CodeEditorScreen(
                  language: state.pathParameters['language'] ?? '',
                  lessonId: state.pathParameters['lessonId'] ?? '',
                ),
              ),
              GoRoute(
                path: ':language/tutor',
                name: RouteNames.tutorChat,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => TutorChatScreen(
                  language: state.pathParameters['language'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/progress',
            name: RouteNames.progress,
            builder: (context, state) => const ProgressScreen(),
          ),
          GoRoute(
            path: '/templates',
            name: RouteNames.templates,
            builder: (context, state) => const TemplatesScreen(),
            routes: [
              GoRoute(
                path: ':templateId',
                name: RouteNames.templateDetail,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => TemplateDetailScreen(
                  templateId: state.pathParameters['templateId'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/referrals',
            name: RouteNames.referrals,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const ReferralScreen(),
          ),
          GoRoute(
            path: '/achievements',
            name: RouteNames.achievements,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: '/leaderboard',
            name: RouteNames.leaderboard,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: '/subscription',
            name: RouteNames.subscription,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SubscriptionManageScreen(),
          ),
          GoRoute(
            path: '/share/:achievementId',
            name: RouteNames.shareAchievement,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => ShareAchievementScreen(
              achievementId: state.pathParameters['achievementId'] ?? '',
            ),
          ),
        ],
      ),
    ],
  );
});

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.goNamed(RouteNames.dashboard);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF0F5), Color(0xFFF8E8FF)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFF6C63FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'PINKZ',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your personal productivity companion',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


