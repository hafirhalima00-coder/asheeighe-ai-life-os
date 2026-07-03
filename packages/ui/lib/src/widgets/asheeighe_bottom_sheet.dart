import 'package:flutter/material.dart';
import '../theme/asheeighe_colors.dart';

class AsheeigheBottomSheet {
  AsheeigheBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double borderRadius = 24,
    bool dragHandle = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    Color? backgroundColor,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      backgroundColor:
          backgroundColor ?? theme.bottomSheetTheme.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: theme.bottomSheetTheme.elevation ?? 8,
      showDragHandle: dragHandle,
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              Flexible(
                child: SingleChildScrollView(
                  padding: padding ??
                      const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
