import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/persona_card.dart';
import '../widgets/interest_chip.dart';
import '../widgets/goal_card.dart';
import '../widgets/setup_toggle.dart';
import '../widgets/celebration_animation.dart';
import '../../domain/entities/onboarding_step.dart';
import '../../domain/entities/user_persona.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    if (state.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state),
            Expanded(
              child: _buildCurrentStep(state),
            ),
            _buildFooter(state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${state.currentStep + 1} of ${onboardingSteps.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurface.withOpacity(0.6),
                ),
              ),
              if (state.currentStep > 0 &&
                  state.currentStep < onboardingSteps.length - 1)
                TextButton(
                  onPressed: () => ref.read(onboardingProvider.notifier).skipOnboarding(),
                  child: const Text('Skip'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          OnboardingIndicator(
            currentStep: state.currentStep,
            totalSteps: onboardingSteps.length,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(OnboardingState state) {
    final step = onboardingSteps[state.currentStep];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          switch (step.type) {
            OnboardingStepType.welcome => _buildWelcomeStep(),
            OnboardingStepType.persona => _buildPersonaStep(state),
            OnboardingStepType.interests => _buildInterestsStep(state),
            OnboardingStepType.goals => _buildGoalsStep(state),
            OnboardingStepType.connect => _buildConnectStep(state),
            OnboardingStepType.notifications => _buildNotificationsStep(state),
            OnboardingStepType.complete => _buildCompleteStep(),
          },
        ],
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '🌸',
                  style: TextStyle(fontSize: 64),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to asheeighe',
              style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your AI Life OS',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Organize your life, achieve your goals, and become the best version of yourself.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonaStep(OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who are you?',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your primary role to personalize your experience',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: userPersonas.length,
              itemBuilder: (context, index) {
                final persona = userPersonas[index];
                return PersonaCard(
                  persona: persona,
                  isSelected: state.selectedPersona?.id == persona.id,
                  onTap: () {
                    ref.read(onboardingProvider.notifier).selectPersona(persona);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsStep(OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What matters to you?',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select at least 3 interests',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.selectedInterests.length} selected',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableInterests.map((interest) {
                return InterestChip(
                  interest: interest,
                  isSelected: state.selectedInterests.contains(interest['id']),
                  onTap: () {
                    ref.read(onboardingProvider.notifier).toggleInterest(interest['id']!);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsStep(OnboardingState state) {
    final selectedInterests = state.selectedInterests;
    final availableGoals = <Map<String, String>>[];

    for (final interest in selectedInterests) {
      if (goalsByInterest.containsKey(interest)) {
        availableGoals.addAll(goalsByInterest[interest]!);
      }
    }

    if (availableGoals.isEmpty) {
      availableGoals.addAll(goalsByInterest['productivity']!);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you want to achieve?',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your goals',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.selectedGoals.length} selected',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: availableGoals.length,
              itemBuilder: (context, index) {
                final goal = availableGoals[index];
                return GoalCard(
                  goal: goal,
                  isSelected: state.selectedGoals.contains(goal['id']),
                  onTap: () {
                    ref.read(onboardingProvider.notifier).toggleGoal(goal['id']!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectStep(OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect your apps',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sync with your favorite apps for a seamless experience',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: availableApps.length,
              itemBuilder: (context, index) {
                final app = availableApps[index];
                return _buildAppTile(
                  app: app,
                  isConnected: state.connectedApps.contains(app['id']),
                  onToggle: () {
                    ref.read(onboardingProvider.notifier).toggleConnectedApp(app['id']!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppTile({
    required Map<String, String> app,
    required bool isConnected,
    required VoidCallback onToggle,
  }) {
    return ListTile(
      leading: Text(
        app['icon']!,
        style: const TextStyle(fontSize: 32),
      ),
      title: Text(
        app['name']!,
        style: AppTextStyles.titleMedium,
      ),
      trailing: Switch(
        value: isConnected,
        onChanged: (_) => onToggle(),
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNotificationsStep(OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay on track',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up reminders to help you achieve your goals',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          SetupToggle(
            title: 'Prayer Reminders',
            subtitle: 'Get notified before prayer times',
            icon: '🕌',
            value: state.notificationSettings['prayer_reminders'] ?? true,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).toggleNotification(
                    'prayer_reminders',
                    value,
                  );
            },
          ),
          const SizedBox(height: 16),
          SetupToggle(
            title: 'Task Reminders',
            subtitle: 'Never miss a deadline',
            icon: '✅',
            value: state.notificationSettings['task_reminders'] ?? true,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).toggleNotification(
                    'task_reminders',
                    value,
                  );
            },
          ),
          const SizedBox(height: 16),
          SetupToggle(
            title: 'Study Reminders',
            subtitle: 'Stay consistent with your studies',
            icon: '📚',
            value: state.notificationSettings['study_reminders'] ?? true,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).toggleNotification(
                    'study_reminders',
                    value,
                  );
            },
          ),
          const SizedBox(height: 16),
          SetupToggle(
            title: 'Daily Inspiration',
            subtitle: 'Start your day with motivation',
            icon: '✨',
            value: state.notificationSettings['daily_inspiration'] ?? true,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).toggleNotification(
                    'daily_inspiration',
                    value,
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CelebrationAnimation(),
            const SizedBox(height: 32),
            Text(
              "You're All Set!",
              style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your personalized dashboard is ready. Start your journey with asheeighe!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(OnboardingState state) {
    final step = onboardingSteps[state.currentStep];

    if (step.type == OnboardingStepType.complete) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(onboardingProvider.notifier).completeOnboarding();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Start Your Journey",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(onboardingProvider.notifier).previousStep();
                  _animationController.reset();
                  _animationController.forward();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (state.currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: state.canProceed
                  ? () {
                      ref.read(onboardingProvider.notifier).nextStep();
                      _animationController.reset();
                      _animationController.forward();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                step.type == OnboardingStepType.welcome ? 'Get Started' : 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
