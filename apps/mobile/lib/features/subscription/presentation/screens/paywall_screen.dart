import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';
import '../widgets/plan_card.dart';
import '../widgets/pro_badge.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  final bool showClose;
  final String? featureName;

  const PaywallScreen({
    super.key,
    this.showClose = true,
    this.featureName,
  });

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen>
    with SingleTickerProviderStateMixin {
  bool _isYearly = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionProvider.notifier).loadPlans();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionProvider);
    final proPlan = state.plans.firstWhere(
      (p) => p.id == 'PRO_MONTHLY',
      orElse: () => state.plans.isNotEmpty
          ? state.plans.first
          : throw StateError('No plans'),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              if (widget.showClose)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeroSection(),
                      const SizedBox(height: 32),
                      _buildBillingToggle(),
                      const SizedBox(height: 24),
                      ...state.plans
                          .where((p) => p.id != 'FREE')
                          .map((plan) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16),
                                child: PlanCard(
                                  plan: plan,
                                  isYearly: _isYearly,
                                  isSelected: false,
                                  onSelect: (planId) =>
                                      _handleSubscribe(planId),
                                ),
                              )),
                      const SizedBox(height: 16),
                      _buildComparisonTable(state.plans),
                      const SizedBox(height: 24),
                      _buildRestoreLink(),
                      const SizedBox(height: 12),
                      _buildTermsLinks(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.workspace_premium,
            size: 44,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Unlock asheeighe Pro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.featureName != null
              ? 'Unlock $widget.featureName and much more'
              : 'Supercharge your productivity',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isYearly
                      ? const Color(0xFFFF69B4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isYearly ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      _isYearly ? const Color(0xFFFF69B4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Yearly',
                      style: TextStyle(
                        color: _isYearly ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_isYearly) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SAVE 34%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(List<dynamic> plans) {
    final features = [
      'AI Messages',
      'Voice Engine',
      'Islamic Features',
      'Analytics',
      'Templates',
      'Gamification',
      'Code Tutor',
      'Priority AI',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 120),
                ...['Free', 'Pro', 'Premium'].map((name) => Expanded(
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: name == 'Premium'
                                ? const Color(0xFFFFD700)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          ...features.map((feature) => _buildFeatureRow(feature)),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    final freeAccess = ['AI Messages'].contains(feature);
    final proAccess = !['Code Tutor', 'Priority AI'].contains(feature);
    final premiumAccess = true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              feature,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            child: Center(
              child: _buildCheckIcon(freeAccess),
            ),
          ),
          Expanded(
            child: Center(
              child: _buildCheckIcon(proAccess),
            ),
          ),
          Expanded(
            child: Center(
              child: _buildCheckIcon(premiumAccess),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckIcon(bool hasAccess) {
    return Icon(
      hasAccess ? Icons.check_circle : Icons.cancel,
      color: hasAccess ? const Color(0xFF4CAF50) : Colors.white24,
      size: 18,
    );
  }

  Widget _buildRestoreLink() {
    final state = ref.watch(subscriptionProvider);
    return GestureDetector(
      onTap: state.isRestoring
          ? null
          : () =>
              ref.read(subscriptionProvider.notifier).restorePurchases(),
      child: Text(
        state.isRestoring ? 'Restoring...' : 'Restore Purchases',
        style: const TextStyle(
          color: Color(0xFFFF69B4),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTermsLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Text(
            'Terms of Service',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ),
        Text(
          '  •  ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubscribe(String planId) async {
    final plan = state.plans.firstWhere((p) => p.id == planId);
    final priceId = _isYearly
        ? 'price_${plan.name.toLowerCase()}_yearly'
        : 'price_${plan.name.toLowerCase()}_monthly';

    final success = await ref
        .read(subscriptionProvider.notifier)
        .subscribeTo(planId, paymentMethodId: priceId);

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }
}
