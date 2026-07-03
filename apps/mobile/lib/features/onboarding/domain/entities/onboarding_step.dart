import 'package:equatable/equatable.dart';

enum OnboardingStepType {
  welcome,
  persona,
  interests,
  goals,
  connect,
  notifications,
  complete;

  String get displayName {
    switch (this) {
      case OnboardingStepType.welcome:
        return 'Welcome';
      case OnboardingStepType.persona:
        return 'Who Are You';
      case OnboardingStepType.interests:
        return 'Interests';
      case OnboardingStepType.goals:
        return 'Goals';
      case OnboardingStepType.connect:
        return 'Connect Apps';
      case OnboardingStepType.notifications:
        return 'Notifications';
      case OnboardingStepType.complete:
        return 'All Set';
    }
  }
}

class OnboardingStep extends Equatable {
  final int id;
  final OnboardingStepType type;
  final String title;
  final String description;
  final bool isRequired;

  const OnboardingStep({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.isRequired = true,
  });

  @override
  List<Object?> get props => [id, type, title, description, isRequired];
}

const List<OnboardingStep> onboardingSteps = [
  OnboardingStep(
    id: 0,
    type: OnboardingStepType.welcome,
    title: 'Welcome to asheeighe',
    description: 'Your AI Life OS',
    isRequired: true,
  ),
  OnboardingStep(
    id: 1,
    type: OnboardingStepType.persona,
    title: 'Who Are You?',
    description: 'Tell us about yourself to personalize your experience',
    isRequired: true,
  ),
  OnboardingStep(
    id: 2,
    type: OnboardingStepType.interests,
    title: 'What Matters to You?',
    description: 'Select at least 3 interests to customize your app',
    isRequired: true,
  ),
  OnboardingStep(
    id: 3,
    type: OnboardingStepType.goals,
    title: 'What Do You Want to Achieve?',
    description: 'Choose your goals to get personalized recommendations',
    isRequired: true,
  ),
  OnboardingStep(
    id: 4,
    type: OnboardingStepType.connect,
    title: 'Connect Your Apps',
    description: 'Sync with your favorite apps for a seamless experience',
    isRequired: false,
  ),
  OnboardingStep(
    id: 5,
    type: OnboardingStepType.notifications,
    title: 'Stay on Track',
    description: 'Set up reminders to help you achieve your goals',
    isRequired: false,
  ),
  OnboardingStep(
    id: 6,
    type: OnboardingStepType.complete,
    title: "You're All Set!",
    description: 'Start your journey with asheeighe',
    isRequired: true,
  ),
];
