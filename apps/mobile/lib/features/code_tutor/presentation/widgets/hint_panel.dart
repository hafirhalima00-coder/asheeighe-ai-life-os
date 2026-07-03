import 'package:flutter/material.dart';

class HintPanel extends StatelessWidget {
  final String hint;
  final int hintIndex;
  final VoidCallback? onShowNext;
  final VoidCallback? onDismiss;

  const HintPanel({
    super.key,
    required this.hint,
    required this.hintIndex,
    this.onShowNext,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                size: 18,
                color: Colors.amber[700],
              ),
              const SizedBox(width: 8),
              Text(
                'Hint ${hintIndex + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber[800],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onDismiss,
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: onShowNext,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Show next hint'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
