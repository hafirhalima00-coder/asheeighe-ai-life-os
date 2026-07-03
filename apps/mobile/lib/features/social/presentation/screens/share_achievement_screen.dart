import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/social_provider.dart';
import '../widgets/share_card.dart';
import '../widgets/social_share_buttons.dart';
import '../../domain/entities/shared_achievement.dart';

class ShareAchievementScreen extends ConsumerStatefulWidget {
  final SharedAchievement achievement;

  const ShareAchievementScreen({
    super.key,
    required this.achievement,
  });

  @override
  ConsumerState<ShareAchievementScreen> createState() =>
      _ShareAchievementScreenState();
}

class _ShareAchievementScreenState extends ConsumerState<ShareAchievementScreen> {
  int _selectedThemeIndex = 0;

  final List<Color> _themes = [
    AppColors.primary,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Share Achievement',
          style: AppTextStyles.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewCard(),
            const SizedBox(height: 24),
            _buildThemeSelector(),
            const SizedBox(height: 24),
            _buildAchievementDetails(),
            const SizedBox(height: 24),
            _buildShareButtons(),
            const SizedBox(height: 24),
            _buildCopyLinkButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Center(
      child: ShareCard(
        achievement: widget.achievement,
        themeColor: _themes[_selectedThemeIndex],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Theme',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_themes.length, (index) {
            final isSelected = _selectedThemeIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedThemeIndex = index;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: _themes[index],
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.onSurface, width: 3)
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAchievementDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievement Details',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Type', widget.achievement.type.displayName),
          _buildDetailRow('Title', widget.achievement.title),
          _buildDetailRow('Description', widget.achievement.description),
          if (widget.achievement.data.value != null)
            _buildDetailRow(
              'Value',
              '${widget.achievement.data.value} ${widget.achievement.data.unit ?? ''}',
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share to',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SocialShareButtons(
          onShare: _shareToPlatform,
          onCopyLink: _copyLink,
        ),
      ],
    );
  }

  Widget _copyLinkButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _copyLink,
        icon: const Icon(Icons.link),
        label: const Text('Copy Link'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _shareToPlatform(String platform) {
    // TODO: Implement actual sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing to $platform coming soon!'),
      ),
    );
  }

  void _copyLink() {
    Clipboard.setData(
      ClipboardData(text: widget.achievement.shareUrl),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
