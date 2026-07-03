import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SocialShareButtons extends StatelessWidget {
  final Function(String platform) onShare;
  final VoidCallback onCopyLink;

  const SocialShareButtons({
    super.key,
    required this.onShare,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildShareButton(
              platform: 'Twitter',
              icon: Icons.chat_bubble,
              color: const Color(0xFF1DA1F2),
              onTap: () => onShare('Twitter'),
            ),
            _buildShareButton(
              platform: 'Instagram',
              icon: Icons.camera_alt,
              color: const Color(0xFFE1306C),
              onTap: () => onShare('Instagram'),
            ),
            _buildShareButton(
              platform: 'WhatsApp',
              icon: Icons.phone,
              color: const Color(0xFF25D366),
              onTap: () => onShare('WhatsApp'),
            ),
            _buildShareButton(
              platform: 'Facebook',
              icon: Icons.facebook,
              color: const Color(0xFF1877F2),
              onTap: () => onShare('Facebook'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onCopyLink,
            icon: const Icon(Icons.link),
            label: const Text('Copy Link'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton({
    required String platform,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            platform,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
