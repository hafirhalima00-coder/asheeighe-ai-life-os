import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/social_provider.dart';
import '../widgets/referral_code_widget.dart';
import '../widgets/social_share_buttons.dart';
import '../../domain/entities/referral.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await ref.read(socialProvider.notifier).loadReferralInfo();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(socialProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            title: Text(
              'Referral Center',
              style: AppTextStyles.headlineMedium,
            ),
          ),
          if (state.isLoadingReferrals)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.referralError != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      state.referralError!,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReferralCodeSection(state),
                    const SizedBox(height: 24),
                    _buildStatsSection(state),
                    const SizedBox(height: 24),
                    _buildMilestonesSection(state),
                    const SizedBox(height: 24),
                    _buildRewardsSection(state),
                    const SizedBox(height: 24),
                    _buildShareSection(state),
                    const SizedBox(height: 24),
                    _buildFAQSection(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection(SocialState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            '🌸',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            'Share PINKZ with Friends',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You both get rewards when they join!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          if (state.referralCode != null)
            ReferralCodeWidget(
              code: state.referralCode!,
              onCopy: _copyCode,
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(SocialState state) {
    final stats = state.referralStats;
    if (stats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stats',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                value: stats.completedReferrals.toString(),
                label: 'Joined',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.pending,
                value: stats.pendingReferrals.toString(),
                label: 'Pending',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.card_giftcard,
                value: stats.rewardsEarned.length.toString(),
                label: 'Rewards',
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesSection(SocialState state) {
    final stats = state.referralStats;
    if (stats == null) return const SizedBox.shrink();

    const milestones = [
      ReferralMilestone(
        requiredReferrals: 1,
        reward: ReferralReward(
          type: ReferralRewardType.proWeek,
          value: 7,
          description: '1 week of Pro free',
        ),
        title: 'First Friend',
        description: 'Invite your first friend',
      ),
      ReferralMilestone(
        requiredReferrals: 3,
        reward: ReferralReward(
          type: ReferralRewardType.proWeek,
          value: 14,
          description: '2 weeks of Pro free',
        ),
        title: 'Growing Circle',
        description: 'Invite 3 friends',
      ),
      ReferralMilestone(
        requiredReferrals: 5,
        reward: ReferralReward(
          type: ReferralRewardType.proMonth,
          value: 1,
          description: '1 month of Pro free',
        ),
        title: 'Popular Host',
        description: 'Invite 5 friends',
      ),
      ReferralMilestone(
        requiredReferrals: 10,
        reward: ReferralReward(
          type: ReferralRewardType.proMonth,
          value: 3,
          description: '3 months of Pro free',
        ),
        title: 'Influencer',
        description: 'Invite 10 friends',
      ),
      ReferralMilestone(
        requiredReferrals: 25,
        reward: ReferralReward(
          type: ReferralRewardType.lifetimePro,
          value: 1,
          description: 'Lifetime Pro access',
        ),
        title: 'PINKZ Ambassador',
        description: 'Invite 25 friends',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...milestones.map((milestone) => _buildMilestoneItem(
              milestone: milestone,
              completedCount: stats.completedReferrals,
            )),
      ],
    );
  }

  Widget _buildMilestoneItem({
    required ReferralMilestone milestone,
    required int completedCount,
  }) {
    final isCompleted = completedCount >= milestone.requiredReferrals;
    final isNext = !isCompleted &&
        (completedCount < milestone.requiredReferrals);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withOpacity(0.1)
            : isNext
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(
                      milestone.requiredReferrals.toString(),
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  milestone.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              milestone.reward.description,
              style: AppTextStyles.labelSmall.copyWith(
                color: isCompleted ? Colors.white : AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection(SocialState state) {
    final stats = state.referralStats;
    if (stats == null || stats.rewardsEarned.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Earned Rewards',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...stats.rewardsEarned.map((reward) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    reward.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reward.description,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Claimed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildShareSection(SocialState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share Your Code',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        SocialShareButtons(
          onShare: _shareToPlatform,
          onCopyLink: _copyLink,
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAQ',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: 'How do referrals work?',
          answer:
              'Share your unique code with friends. When they sign up using your code, you both get rewards!',
        ),
        _buildFAQItem(
          question: 'What rewards can I earn?',
          answer:
              'Start with 1 week of Pro free, and earn up to Lifetime Pro access with 25 referrals!',
        ),
        _buildFAQItem(
          question: 'When do I get my reward?',
          answer:
              'Rewards are granted immediately when your friend completes their signup using your code.',
        ),
        _buildFAQItem(
          question: 'Is there a limit to referrals?',
          answer:
              'No limit! Keep sharing and earning rewards. The more friends you invite, the more you earn.',
        ),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: Text(
            answer,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  void _copyCode() {
    final code = ref.read(socialProvider).referralCode;
    if (code != null) {
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral code copied!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _copyLink() {
    final link = ref.read(socialProvider).referralLink;
    if (link != null) {
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral link copied!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _shareToPlatform(String platform) {
    final code = ref.read(socialProvider).referralCode;
    final link = ref.read(socialProvider).referralLink;

    if (code == null || link == null) return;

    String shareText = 'Join me on PINKZ - your AI Life OS! 🌸\n\n';
    shareText += 'Use my referral code: $code\n\n';
    shareText += link;

    // TODO: Implement actual sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing to $platform coming soon!'),
      ),
    );
  }
}
