import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/social_provider.dart';
import '../../domain/entities/template.dart';

class TemplateDetailScreen extends ConsumerStatefulWidget {
  final String templateId;

  const TemplateDetailScreen({
    super.key,
    required this.templateId,
  });

  @override
  ConsumerState<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends ConsumerState<TemplateDetailScreen> {
  Template? _template;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final templates = ref.read(socialProvider).templates;
      final featured = ref.read(socialProvider).featuredTemplates;
      
      final allTemplates = [...templates, ...featured];
      final template = allTemplates.firstWhere(
        (t) => t.id == widget.templateId,
        orElse: () => throw Exception('Template not found'),
      );

      setState(() {
        _template = template;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _template == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Template not found',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 16),
                  _buildCategoryChip(),
                  const SizedBox(height: 16),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  _buildPreviewSection(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildSimilarTemplatesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _template!.category.icon,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            if (_template!.isProOnly)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PRO TEMPLATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _template!.name,
          style: AppTextStyles.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'by ${_template!.authorName}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip() {
    return Chip(
      label: Text(
        '${_template!.category.icon} ${_template!.category.displayName}',
        style: AppTextStyles.labelMedium,
      ),
      backgroundColor: AppColors.surfaceVariant,
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.star,
          value: _template!.rating.toStringAsFixed(1),
          label: 'Rating',
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          icon: Icons.people,
          value: _template!.formattedUsageCount,
          label: 'Uses',
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          icon: Icons.calendar_today,
          value: _formatDate(_template!.createdAt),
          label: 'Created',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
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
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _template!.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface.withOpacity(0.8),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _template!.previewImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _template!.previewImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPreviewPlaceholder(),
                  ),
                )
              : _buildPreviewPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildPreviewPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.preview,
            size: 48,
            color: AppColors.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'Template Preview',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _useTemplate,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              _template!.isProOnly ? 'Pro Required' : 'Use Template',
              style: const TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _template!.isProOnly
                  ? AppColors.onSurface.withOpacity(0.3)
                  : AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: _shareTemplate,
          icon: const Icon(Icons.share),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceVariant,
            padding: const EdgeInsets.all(16),
          ),
        ),
        IconButton(
          onPressed: _rateTemplate,
          icon: const Icon(Icons.star_outline),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceVariant,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarTemplatesSection() {
    final state = ref.watch(socialProvider);
    final similarTemplates = state.templates
        .where((t) => t.category == _template!.category && t.id != _template!.id)
        .take(4)
        .toList();

    if (similarTemplates.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar Templates',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: similarTemplates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final template = similarTemplates[index];
              return GestureDetector(
                onTap: () {
                  context.push('/templates/${template.id}');
                },
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.category.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const Spacer(),
                      Text(
                        template.name,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _useTemplate() async {
    if (_template!.isProOnly) {
      _showProPaywall();
      return;
    }

    try {
      final data = await ref.read(socialProvider.notifier).useTemplate(_template!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_template!.name} template applied!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _shareTemplate() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
      ),
    );
  }

  void _rateTemplate() {
    showDialog(
      context: context,
      builder: (context) => _RatingDialog(
        templateName: _template!.name,
        onRate: (rating) async {
          try {
            await ref.read(socialProvider.notifier).rateTemplate(_template!.id, rating);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thanks for rating!'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showProPaywall() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('👑', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('Pro Template', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'This template is exclusive to asheeighe Pro members.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/subscription');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe Later'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }
}

class _RatingDialog extends StatefulWidget {
  final String templateName;
  final Function(int rating) onRate;

  const _RatingDialog({
    required this.templateName,
    required this.onRate,
  });

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate ${widget.templateName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How would you rate this template?',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: index < _rating ? Colors.amber : AppColors.onSurface.withOpacity(0.3),
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _rating > 0
              ? () {
                  widget.onRate(_rating);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
