import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/task_provider.dart';

class TaskCategoriesScreen extends ConsumerWidget {
  const TaskCategoriesScreen({super.key});

  static const _categoryColors = {
    'Work': Color(0xFF60A5FA),
    'Personal': Color(0xFFA78BFA),
    'Health': Color(0xFFF472B6),
    'Study': Color(0xFF34D399),
    'Finance': Color(0xFFFBBF24),
    'Shopping': Color(0xFFFB923C),
    'Other': Color(0xFF9CA3AF),
  };

  static const _categoryIcons = {
    'Work': Icons.work_rounded,
    'Personal': Icons.person_rounded,
    'Health': Icons.favorite_rounded,
    'Study': Icons.school_rounded,
    'Finance': Icons.attach_money_rounded,
    'Shopping': Icons.shopping_cart_rounded,
    'Other': Icons.more_horiz_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);
    final categories = state.categories;
    final counts = state.categoryCounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: categories.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_rounded,
                      size: 56, color: AppTheme.textHint),
                  SizedBox(height: 16),
                  Text(
                    'No categories yet',
                    style: TextStyle(
                      fontSize: AppConstants.textLg,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Categories appear when you add them to tasks',
                    style: TextStyle(
                      fontSize: AppConstants.textSm,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final color =
                      _categoryColors[category] ?? AppTheme.primary;
                  final icon =
                      _categoryIcons[category] ?? Icons.category_rounded;
                  final count = counts[category] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(taskProvider.notifier)
                          .filterByCategory(category);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(AppConstants.radiusLg),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusMd),
                                  ),
                                  child: Icon(icon,
                                      size: 24, color: color),
                                ),
                                const Spacer(),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: AppConstants.textMd,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$count task${count != 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    fontSize: AppConstants.textSm,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
