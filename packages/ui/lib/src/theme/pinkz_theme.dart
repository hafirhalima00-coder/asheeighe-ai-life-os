import 'package:flutter/material.dart';
import 'pinkz_colors.dart';
import 'typography.dart';

abstract final class PinkzTheme {
  PinkzTheme._();

  static ThemeData get light => _buildLight();
  static ThemeData get dark => _buildDark();

  static ThemeData _buildLight() {
    final colorScheme = ColorScheme.light(
      primary: PinkzColors.pastelPink,
      onPrimary: Colors.black87,
      primaryContainer: PinkzColors.softRose,
      onPrimaryContainer: Colors.black87,
      secondary: PinkzColors.softLavender,
      onSecondary: Colors.black87,
      secondaryContainer: PinkzColors.gentlePurple,
      onSecondaryContainer: Colors.black87,
      tertiary: PinkzColors.mint,
      onTertiary: Colors.black87,
      error: PinkzColors.error,
      onError: Colors.white,
      errorContainer: PinkzColors.errorContainer,
      onErrorContainer: Colors.black87,
      surface: PinkzColors.surfaceLight,
      onSurface: PinkzColors.surfaceOnLight,
      surfaceContainerHighest: PinkzColors.surfaceContainerLight,
      onSurfaceVariant: const Color(0xFF49454F),
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
      inverseSurface: PinkzColors.surfaceDark,
      onInverseSurface: PinkzColors.surfaceOnDark,
      inversePrimary: PinkzColors.darkPastelPink,
      shadow: Colors.black26,
      scrim: Colors.black38,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: PinkzTypography.textTheme,
      brightness: Brightness.light,

      // ─── Card ──────────────────────────────────
      cardTheme: CardTheme(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        color: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
      ),

      // ─── AppBar ────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: PinkzColors.surfaceOnLight,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: PinkzTypography.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      // ─── Bottom Navigation ─────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: PinkzColors.creamWhite,
        selectedItemColor: PinkzColors.pastelPink,
        unselectedItemColor: const Color(0xFF79747E),
        selectedLabelStyle: PinkzTypography.textTheme.labelMedium,
        unselectedLabelStyle: PinkzTypography.textTheme.labelSmall,
        indicatorColor: PinkzColors.pastelPink.withOpacity(0.24),
      ),

      // ─── Floating Action Button ────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: PinkzColors.pastelPink,
        foregroundColor: Colors.black87,
        extendedTextStyle: PinkzTypography.textTheme.labelLarge,
      ),

      // ─── Input Decoration ──────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PinkzColors.creamWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCAC4D0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCAC4D0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PinkzColors.pastelPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PinkzColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PinkzColors.error, width: 2),
        ),
        labelStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF49454F),
        ),
        hintStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF79747E),
        ),
        errorStyle: PinkzTypography.textTheme.bodySmall?.copyWith(
          color: PinkzColors.error,
        ),
      ),

      // ─── Elevated Button ───────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          backgroundColor: PinkzColors.pastelPink,
          foregroundColor: Colors.black87,
        ),
      ),

      // ─── Filled Button ─────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          backgroundColor: PinkzColors.pastelPink,
          foregroundColor: Colors.black87,
        ),
      ),

      // ─── Outlined Button ───────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          side: const BorderSide(color: PinkzColors.pastelPink),
          foregroundColor: PinkzColors.surfaceOnLight,
        ),
      ),

      // ─── Text Button ───────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          foregroundColor: PinkzColors.pastelPink,
        ),
      ),

      // ─── Chip ──────────────────────────────────
      chipThemeData: ChipThemeData(
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: PinkzTypography.textTheme.labelMedium,
        secondaryLabelStyle: PinkzTypography.textTheme.labelMedium,
        backgroundColor: PinkzColors.softLavender.withOpacity(0.5),
        selectedColor: PinkzColors.pastelPink.withOpacity(0.3),
        disabledColor: const Color(0xFFE0E0E0),
        surfaceTintColor: Colors.transparent,
        side: BorderSide.none,
        brightness: Brightness.light,
      ),

      // ─── Switch ────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return const Color(0xFF79747E);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return PinkzColors.pastelPink;
          }
          return const Color(0xFFCAC4D0);
        }),
      ),

      // ─── Slider ────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: PinkzColors.pastelPink,
        inactiveTrackColor: PinkzColors.pastelPink.withOpacity(0.24),
        thumbColor: PinkzColors.pastelPink,
        overlayColor: PinkzColors.pastelPink.withOpacity(0.12),
        activeTickMarkColor: Colors.white,
        inactiveTickMarkColor: PinkzColors.pastelPink.withOpacity(0.5),
        valueIndicatorColor: PinkzColors.pastelPink,
        valueIndicatorTextStyle: PinkzTypography.textTheme.labelSmall?.copyWith(
          color: Colors.black87,
        ),
      ),

      // ─── Dialog ────────────────────────────────
      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: PinkzColors.creamWhite,
        titleTextStyle: PinkzTypography.textTheme.headlineSmall,
        contentTextStyle: PinkzTypography.textTheme.bodyMedium,
      ),

      // ─── Bottom Sheet ──────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: const Color(0xFFCAC4D0),
        modalBackgroundColor: PinkzColors.creamWhite,
        modalElevation: 8,
      ),

      // ─── SnackBar ──────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: PinkzColors.surfaceOnLight,
        contentTextStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        actionTextColor: PinkzColors.pastelPink,
      ),

      // ─── Tooltip ───────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: PinkzColors.surfaceOnLight,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: PinkzTypography.textTheme.bodySmall?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ─── Date Picker ───────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: PinkzColors.pastelPink,
        headerForegroundColor: Colors.black87,
        todayForegroundColor: WidgetStateProperty.all(PinkzColors.pastelPink),
        todayBackgroundColor: WidgetStateProperty.all(
          PinkzColors.pastelPink.withOpacity(0.12),
        ),
        selectedDayBackgroundColor: WidgetStateProperty.all(PinkzColors.pastelPink),
        selectedDayForegroundColor: WidgetStateProperty.all(Colors.black87),
        dayShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        yearShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        dayStyle: PinkzTypography.textTheme.bodyMedium,
        yearStyle: PinkzTypography.textTheme.bodyMedium,
        weekdayStyle: PinkzTypography.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF79747E),
        ),
      ),

      // ─── Time Picker ───────────────────────────
      timePickerTheme: TimePickerThemeData(
        backgroundColor: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        dialHandColor: PinkzColors.pastelPink,
        dialBackgroundColor: PinkzColors.pastelPink.withOpacity(0.12),
        hourMinuteColor: PinkzColors.pastelPink.withOpacity(0.12),
        hourMinuteTextColor: PinkzColors.surfaceOnLight,
        dayPeriodColor: PinkzColors.pastelPink.withOpacity(0.12),
        dayPeriodTextColor: PinkzColors.surfaceOnLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hourMinuteTextStyle: PinkzTypography.textTheme.headlineMedium,
        dayPeriodTextStyle: PinkzTypography.textTheme.titleMedium,
        helpTextStyle: PinkzTypography.textTheme.bodyMedium,
      ),

      // ─── Divider ───────────────────────────────
      dividerTheme: DividerThemeData(
        color: const Color(0xFFCAC4D0).withOpacity(0.4),
        thickness: 1,
        space: 1,
      ),

      // ─── Progress Indicator ────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: PinkzColors.pastelPink,
        linearTrackColor: PinkzColors.pastelPink.withOpacity(0.24),
        circularTrackColor: PinkzColors.pastelPink.withOpacity(0.24),
      ),

      // ─── Menu / Popup ──────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        textStyle: PinkzTypography.textTheme.bodyMedium,
      ),

      // ─── Navigation Bar (Material 3) ───────────
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        backgroundColor: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        indicatorColor: PinkzColors.pastelPink.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return PinkzTypography.textTheme.labelMedium?.copyWith(
              color: PinkzColors.pastelPink,
            );
          }
          return PinkzTypography.textTheme.labelSmall;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: PinkzColors.pastelPink, size: 24);
          }
          return const IconThemeData(color: Color(0xFF79747E), size: 24);
        }),
      ),

      // ─── Drawer ────────────────────────────────
      drawerTheme: DrawerThemeData(
        elevation: 8,
        backgroundColor: PinkzColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),

      extensions: const [
        _PinkzGlassTheme(
          surface: PinkzColors.glassLight,
          stroke: PinkzColors.glassStrokeLight,
        ),
      ],
    );
  }

  static ThemeData _buildDark() {
    final colorScheme = ColorScheme.dark(
      primary: PinkzColors.darkPastelPink,
      onPrimary: Colors.white,
      primaryContainer: PinkzColors.darkSoftRose,
      onPrimaryContainer: Colors.white,
      secondary: PinkzColors.darkSoftLavender,
      onSecondary: Colors.white,
      secondaryContainer: PinkzColors.darkGentlePurple,
      onSecondaryContainer: Colors.white,
      tertiary: PinkzColors.darkMint,
      onTertiary: Colors.black87,
      error: const Color(0xFFEF9A9A),
      onError: Colors.black87,
      errorContainer: const Color(0xFF8B1A1A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: PinkzColors.surfaceDark,
      onSurface: PinkzColors.surfaceOnDark,
      surfaceContainerHighest: PinkzColors.surfaceContainerDark,
      onSurfaceVariant: const Color(0xFFCAC4D0),
      outline: const Color(0xFF938F99),
      outlineVariant: const Color(0xFF49454F),
      inverseSurface: PinkzColors.surfaceLight,
      onInverseSurface: PinkzColors.surfaceOnLight,
      inversePrimary: PinkzColors.pastelPink,
      shadow: Colors.black45,
      scrim: Colors.black54,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: PinkzTypography.textTheme.apply(
        displayColor: PinkzColors.surfaceOnDark,
        bodyColor: PinkzColors.surfaceOnDark,
      ),
      brightness: Brightness.dark,

      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        color: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: PinkzColors.surfaceOnDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: PinkzTypography.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: PinkzColors.surfaceOnDark,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: PinkzColors.surfaceContainerDark,
        selectedItemColor: PinkzColors.darkPastelPink,
        unselectedItemColor: const Color(0xFF938F99),
        selectedLabelStyle: PinkzTypography.textTheme.labelMedium,
        unselectedLabelStyle: PinkzTypography.textTheme.labelSmall,
        indicatorColor: PinkzColors.darkPastelPink.withOpacity(0.24),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: PinkzColors.darkPastelPink,
        foregroundColor: Colors.white,
        extendedTextStyle: PinkzTypography.textTheme.labelLarge,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PinkzColors.surfaceContainerDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF49454F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF49454F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: PinkzColors.darkPastelPink,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF9A9A), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF9A9A), width: 2),
        ),
        labelStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFCAC4D0),
        ),
        hintStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF938F99),
        ),
        errorStyle: PinkzTypography.textTheme.bodySmall?.copyWith(
          color: const Color(0xFFEF9A9A),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          backgroundColor: PinkzColors.darkPastelPink,
          foregroundColor: Colors.white,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          backgroundColor: PinkzColors.darkPastelPink,
          foregroundColor: Colors.white,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          side: const BorderSide(color: PinkzColors.darkPastelPink),
          foregroundColor: PinkzColors.surfaceOnDark,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: PinkzTypography.textTheme.labelLarge,
          foregroundColor: PinkzColors.darkPastelPink,
        ),
      ),

      chipThemeData: ChipThemeData(
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: PinkzTypography.textTheme.labelMedium,
        secondaryLabelStyle: PinkzTypography.textTheme.labelMedium,
        backgroundColor: PinkzColors.darkSoftLavender.withOpacity(0.2),
        selectedColor: PinkzColors.darkPastelPink.withOpacity(0.3),
        disabledColor: const Color(0xFF2B2930),
        surfaceTintColor: Colors.transparent,
        side: BorderSide.none,
        brightness: Brightness.dark,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return const Color(0xFF938F99);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return PinkzColors.darkPastelPink;
          }
          return const Color(0xFF49454F);
        }),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: PinkzColors.darkPastelPink,
        inactiveTrackColor: PinkzColors.darkPastelPink.withOpacity(0.24),
        thumbColor: PinkzColors.darkPastelPink,
        overlayColor: PinkzColors.darkPastelPink.withOpacity(0.12),
        activeTickMarkColor: Colors.white,
        inactiveTickMarkColor: PinkzColors.darkPastelPink.withOpacity(0.5),
        valueIndicatorColor: PinkzColors.darkPastelPink,
        valueIndicatorTextStyle: PinkzTypography.textTheme.labelSmall?.copyWith(
          color: Colors.black87,
        ),
      ),

      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: PinkzTypography.textTheme.headlineSmall?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        contentTextStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: const Color(0xFF49454F),
        modalBackgroundColor: PinkzColors.surfaceContainerDark,
        modalElevation: 8,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: PinkzColors.surfaceOnDark,
        contentTextStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceDark,
        ),
        actionTextColor: PinkzColors.darkPastelPink,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: PinkzColors.surfaceOnDark,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: PinkzTypography.textTheme.bodySmall?.copyWith(
          color: PinkzColors.surfaceDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: PinkzColors.darkPastelPink,
        headerForegroundColor: Colors.white,
        todayForegroundColor: WidgetStateProperty.all(
          PinkzColors.darkPastelPink,
        ),
        todayBackgroundColor: WidgetStateProperty.all(
          PinkzColors.darkPastelPink.withOpacity(0.12),
        ),
        selectedDayBackgroundColor: WidgetStateProperty.all(
          PinkzColors.darkPastelPink,
        ),
        selectedDayForegroundColor: WidgetStateProperty.all(Colors.white),
        dayShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        yearShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        dayStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        yearStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        weekdayStyle: PinkzTypography.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF938F99),
        ),
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        dialHandColor: PinkzColors.darkPastelPink,
        dialBackgroundColor: PinkzColors.darkPastelPink.withOpacity(0.12),
        hourMinuteColor: PinkzColors.darkPastelPink.withOpacity(0.12),
        hourMinuteTextColor: PinkzColors.surfaceOnDark,
        dayPeriodColor: PinkzColors.darkPastelPink.withOpacity(0.12),
        dayPeriodTextColor: PinkzColors.surfaceOnDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hourMinuteTextStyle: PinkzTypography.textTheme.headlineMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        dayPeriodTextStyle: PinkzTypography.textTheme.titleMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
        helpTextStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: const Color(0xFF49454F).withOpacity(0.6),
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: PinkzColors.darkPastelPink,
        linearTrackColor: PinkzColors.darkPastelPink.withOpacity(0.24),
        circularTrackColor: PinkzColors.darkPastelPink.withOpacity(0.24),
      ),

      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        textStyle: PinkzTypography.textTheme.bodyMedium?.copyWith(
          color: PinkzColors.surfaceOnDark,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        backgroundColor: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: PinkzColors.darkPastelPink.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return PinkzTypography.textTheme.labelMedium?.copyWith(
              color: PinkzColors.darkPastelPink,
            );
          }
          return PinkzTypography.textTheme.labelSmall?.copyWith(
            color: const Color(0xFF938F99),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: PinkzColors.darkPastelPink,
              size: 24,
            );
          }
          return const IconThemeData(color: Color(0xFF938F99), size: 24);
        }),
      ),

      drawerTheme: DrawerThemeData(
        elevation: 8,
        backgroundColor: PinkzColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),

      extensions: const [
        _PinkzGlassTheme(
          surface: PinkzColors.glassDark,
          stroke: PinkzColors.glassStrokeDark,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Glassmorphism Theme Extension
// ──────────────────────────────────────────────
class _PinkzGlassTheme extends ThemeExtension<_PinkzGlassTheme> {
  final Color surface;
  final Color stroke;

  const _PinkzGlassTheme({
    required this.surface,
    required this.stroke,
  });

  @override
  _PinkzGlassTheme copyWith({Color? surface, Color? stroke}) {
    return _PinkzGlassTheme(
      surface: surface ?? this.surface,
      stroke: stroke ?? this.stroke,
    );
  }

  @override
  _PinkzGlassTheme lerp(_PinkzGlassTheme? other, double t) {
    if (other == null) return this;
    return _PinkzGlassTheme(
      surface: Color.lerp(surface, other.surface, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
    );
  }
}

extension PinkzGlassX on ThemeData {
  Color get glassSurface =>
      extension<_PinkzGlassTheme>()?.surface ?? PinkzColors.glassLight;
  Color get glassStroke =>
      extension<_PinkzGlassTheme>()?.stroke ?? PinkzColors.glassStrokeLight;
}
