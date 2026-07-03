import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';
import '../widgets/usage_indicator.dart';
import '../widgets/pro_badge.dart';

class SubscriptionManageScreen extends ConsumerStatefulWidget {
  const SubscriptionManageScreen({super.key});

  @override
  ConsumerState<SubscriptionManageScreen> createState() =>
      _SubscriptionManageScreenState();
}

class _SubscriptionManageScreenState
    extends ConsumerState<SubscriptionManageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(subscriptionProvider.notifier);
      notifier.loadSubscription();
      notifier.loadUsage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionProvider);
    final sub = state.currentSubscription;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentPlanCard(sub),
            const SizedBox(height: 24),
            _buildUsageSection(state),
            const SizedBox(height: 24),
            _buildActions(sub),
            const SizedBox(height: 24),
            _buildPaymentHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard(dynamic sub) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: sub != null && sub.isPaidUser
              ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
              : [const Color(0xFF1a1a1a), const Color(0xFF1a1a1a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sub != null && sub.isPremium
              ? const Color(0xFFFFD700).withOpacity(0.3)
              : sub != null && sub.isPro
                  ? const Color(0xFFFF69B4).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                sub?.planName ?? 'Free',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              if (sub?.isPro == true)
                const ProBadge(type: ProBadgeType.pro),
              if (sub?.isPremium == true)
                const ProBadge(type: ProBadgeType.premium),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: sub?.isActive == true
                      ? const Color(0xFF4CAF50).withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sub?.status.name.toUpperCase() ?? 'ACTIVE',
                  style: TextStyle(
                    color: sub?.isActive == true
                        ? const Color(0xFF4CAF50)
                        : Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (sub?.currentPeriodEnd != null) ...[
            const SizedBox(height: 12),
            Text(
              'Renews ${_formatDate(sub!.currentPeriodEnd)}',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
          if (sub?.cancelAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Cancels ${_formatDate(sub!.cancelAt)}',
              style: const TextStyle(
                  color: Color(0xFFFF6B6B), fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageSection(SubscriptionState state) {
    final usage = state.usage;
    final aiUsed = usage['aiMessagesUsed'] as int? ?? 0;
    final aiLimit = usage['aiMessagesLimit'] as int? ?? 5;
    final storageUsed = usage['storageUsed'] as int? ?? 0;
    final storageLimit = usage['storageLimit'] as int? ?? 50 * 1024 * 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Usage',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        UsageIndicator(
          label: 'AI Messages',
          used: aiUsed,
          limit: aiLimit,
          icon: Icons.auto_awesome,
          color: const Color(0xFFFF69B4),
        ),
        const SizedBox(height: 12),
        UsageIndicator(
          label: 'Storage',
          used: storageUsed,
          limit: storageLimit,
          icon: Icons.storage,
          color: const Color(0xFF4FC3F7),
          usedLabel: _formatBytes(storageUsed),
          limitLabel: _formatBytes(storageLimit),
        ),
      ],
    );
  }

  Widget _buildActions(dynamic sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (sub == null || !sub.isPaidUser)
          _buildActionButton(
            'Upgrade Plan',
            Icons.upgrade,
            const Color(0xFFFF69B4),
            () => Navigator.pushNamed(context, '/paywall'),
          ),
        if (sub?.isPro == true)
          _buildActionButton(
            'Upgrade to Premium',
            Icons.star,
            const Color(0xFFFFD700),
            () => Navigator.pushNamed(context, '/paywall'),
          ),
        if (sub?.isPaidUser == true)
          _buildActionButton(
            sub?.cancelAt != null ? 'Reactivate' : 'Cancel Subscription',
            sub?.cancelAt != null ? Icons.play_arrow : Icons.cancel,
            sub?.cancelAt != null
                ? const Color(0xFF4CAF50)
                : const Color(0xFFFF6B6B),
            () => _handleCancelToggle(sub),
          ),
        _buildActionButton(
          'Restore Purchases',
          Icons.restore,
          Colors.white70,
          () => ref.read(subscriptionProvider.notifier).restorePurchases(),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'No payment history',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleCancelToggle(dynamic sub) async {
    if (sub?.cancelAt != null) {
      await ref.read(subscriptionProvider.notifier).cancelSubscription();
    } else {
      final reason = await _showCancelDialog();
      if (reason != null) {
        await ref
            .read(subscriptionProvider.notifier)
            .cancelSubscription(reason: reason);
      }
    }
  }

  Future<String?> _showCancelDialog() async {
    String? selectedReason;
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        title: const Text(
          'Cancel Subscription',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We\'re sorry to see you go. Please tell us why:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ...['Too expensive', 'Not using enough', 'Missing features', 'Other']
                .map(
              (reason) => RadioListTile<String>(
                title: Text(reason,
                    style: const TextStyle(color: Colors.white70)),
                value: reason,
                groupValue: selectedReason,
                onChanged: (v) => selectedReason = v,
                activeColor: const Color(0xFFFF69B4),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Subscription',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, selectedReason),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatBytes(int bytes) {
    if (bytes == 0) return '0 B';
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < sizes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${sizes[i]}';
  }
}
