import 'package:equatable/equatable.dart';

class UserPersona extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<String> suggestedFeatures;
  final List<String> suggestedInterests;

  const UserPersona({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.suggestedFeatures = const [],
    this.suggestedInterests = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        suggestedFeatures,
        suggestedInterests,
      ];
}

const List<UserPersona> userPersonas = [
  UserPersona(
    id: 'student',
    name: 'Student',
    description: 'Organize your studies, track assignments, and ace your exams',
    icon: '📚',
    suggestedFeatures: ['study_planner', 'exam_prep', 'note_taking', 'time_management'],
    suggestedInterests: ['study', 'productivity', 'coding'],
  ),
  UserPersona(
    id: 'professional',
    name: 'Professional',
    description: 'Manage your career, track projects, and stay productive',
    icon: '💼',
    suggestedFeatures: ['task_management', 'meeting_notes', 'project_tracking', 'goal_setting'],
    suggestedInterests: ['business', 'productivity', 'finance'],
  ),
  UserPersona(
    id: 'entrepreneur',
    name: 'Entrepreneur',
    description: 'Build your business, track clients, and grow your venture',
    icon: '🚀',
    suggestedFeatures: ['client_tracking', 'invoice_management', 'business_planning', 'analytics'],
    suggestedInterests: ['business', 'finance', 'productivity'],
  ),
  UserPersona(
    id: 'homemaker',
    name: 'Homemaker',
    description: 'Organize your home, manage family schedules, and stay balanced',
    icon: '🏠',
    suggestedFeatures: ['meal_planning', 'family_calendar', 'budget_tracker', 'shopping_lists'],
    suggestedInterests: ['wellness', 'personal', 'productivity'],
  ),
  UserPersona(
    id: 'creative',
    name: 'Creative',
    description: 'Capture ideas, track projects, and unleash your creativity',
    icon: '🎨',
    suggestedFeatures: ['idea_capture', 'project_management', 'inspiration_board', 'portfolio'],
    suggestedInterests: ['personal', 'productivity', 'travel'],
  ),
  UserPersona(
    id: 'scholar',
    name: 'Islamic Scholar',
    description: 'Deepen your knowledge, track your progress, and strengthen your faith',
    icon: '🕌',
    suggestedFeatures: ['quran_tracking', 'prayer_log', 'dhikr_counter', 'study_notes'],
    suggestedInterests: ['islamic', 'study', 'wellness'],
  ),
];
