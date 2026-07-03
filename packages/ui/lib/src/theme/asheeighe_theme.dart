import 'package:flutter/material.dart';
import 'asheeighe_colors.dart';
import 'typography.dart';

abstract final class AsheeigheTheme {
  AsheeigheTheme._();

  static ThemeData get light => _buildLight();
  static ThemeData get dark => _buildDark();

  static ThemeData _buildLight() {
    final colorScheme = ColorScheme.light(
      primary: AsheeigheColors.pastelPink,
      onPrimary: Colors.black87,
      primaryContainer: AsheeigheColors.softRose,
      onPrimaryContainer: Colors.black87,
      secondary: AsheeigheColors.softLavender,
      onSecondary: Colors.black87,
      secondaryContainer: AsheeigheColors.gentlePurple,
      onSecondaryContainer: Colors.black87,
      tertiary: AsheeigheColors.mint,
      onTertiary: Colors.black87,
      error: AsheeigheColors.error,
      onError: Colors.white,
      errorContainer: AsheeigheColors.errorContainer,
      onErrorContainer: Colors.black87,
      surface: AsheeigheColors.surfaceLight,
      onSurface: AsheeigheColors.surfaceOnLight,
      surfaceContainerHighest: AsheeigheColors.surfaceContainerLight,
      onSurfaceVariant: const Color(0xFF49454F),
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
      inverseSurface: AsheeigheColors.surfaceDark,
      onInverseSurface: AsheeigheColors.surfaceOnDark,
      inversePrimary: AsheeigheColors.darkPastelPink,
      shadow: Colors.black26,
      scrim: Colors.black38,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AsheeigheTypography.textTheme,
      brightness: Brightness.light,

      // ─── Card ──────────────────────────────────
      cardTheme: CardTheme(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        color: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
      ),

      // ─── AppBar ────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AsheeigheColors.surfaceOnLight,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AsheeigheTypography.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      // ─── Bottom Navigation ─────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AsheeigheColors.creamWhite,
        selectedItemColor: AsheeigheColors.pastelPink,
        unselectedItemColor: const Color(0xFF79747E),
        selectedLabelStyle: AsheeigheTypography.textTheme.labelMedium,
        unselectedLabelStyle: AsheeigheTypography.textTheme.labelSmall,
        indicatorColor: AsheeigheColors.pastelPink.withOpacity(0.24),
      ),

      // ─── Floating Action Button ────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AsheeigheColors.pastelPink,
        foregroundColor: Colors.black87,
        extendedTextStyle: AsheeigheTypography.textTheme.labelLarge,
      ),

      // ─── Input Decoration ──────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AsheeigheColors.creamWhite,
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
          borderSide: const BorderSide(color: AsheeigheColors.pastelPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AsheeigheColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AsheeigheColors.error, width: 2),
        ),
        labelStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF49454F),
        ),
        hintStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF79747E),
        ),
        errorStyle: AsheeigheTypography.textTheme.bodySmall?.copyWith(
          color: AsheeigheColors.error,
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
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          backgroundColor: AsheeigheColors.pastelPink,
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
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          backgroundColor: AsheeigheColors.pastelPink,
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
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          side: const BorderSide(color: AsheeigheColors.pastelPink),
          foregroundColor: AsheeigheColors.surfaceOnLight,
        ),
      ),

      // ─── Text Button ───────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          foregroundColor: AsheeigheColors.pastelPink,
        ),
      ),

      // ─── Chip ──────────────────────────────────
      chipThemeData: ChipThemeData(
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: AsheeigheTypography.textTheme.labelMedium,
        secondaryLabelStyle: AsheeigheTypography.textTheme.labelMedium,
        backgroundColor: AsheeigheColors.softLavender.withOpacity(0.5),
        selectedColor: AsheeigheColors.pastelPink.withOpacity(0.3),
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
            return AsheeigheColors.pastelPink;
          }
          return const Color(0xFFCAC4D0);
        }),
      ),

      // ─── Slider ────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AsheeigheColors.pastelPink,
        inactiveTrackColor: AsheeigheColors.pastelPink.withOpacity(0.24),
        thumbColor: AsheeigheColors.pastelPink,
        overlayColor: AsheeigheColors.pastelPink.withOpacity(0.12),
        activeTickMarkColor: Colors.white,
        inactiveTickMarkColor: AsheeigheColors.pastelPink.withOpacity(0.5),
        valueIndicatorColor: AsheeigheColors.pastelPink,
        valueIndicatorTextStyle: AsheeigheTypography.textTheme.labelSmall?.copyWith(
          color: Colors.black87,
        ),
      ),

      // ─── Dialog ────────────────────────────────
      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: AsheeigheColors.creamWhite,
        titleTextStyle: AsheeigheTypography.textTheme.headlineSmall,
        contentTextStyle: AsheeigheTypography.textTheme.bodyMedium,
      ),

      // ─── Bottom Sheet ──────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: const Color(0xFFCAC4D0),
        modalBackgroundColor: AsheeigheColors.creamWhite,
        modalElevation: 8,
      ),

      // ─── SnackBar ──────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: AsheeigheColors.surfaceOnLight,
        contentTextStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        actionTextColor: AsheeigheColors.pastelPink,
      ),

      // ─── Tooltip ───────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AsheeigheColors.surfaceOnLight,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AsheeigheTypography.textTheme.bodySmall?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ─── Date Picker ───────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AsheeigheColors.pastelPink,
        headerForegroundColor: Colors.black87,
        todayForegroundColor: WidgetStateProperty.all(AsheeigheColors.pastelPink),
        todayBackgroundColor: WidgetStateProperty.all(
          AsheeigheColors.pastelPink.withOpacity(0.12),
        ),
        selectedDayBackgroundColor: WidgetStateProperty.all(AsheeigheColors.pastelPink),
        selectedDayForegroundColor: WidgetStateProperty.all(Colors.black87),
        dayShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        yearShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        dayStyle: AsheeigheTypography.textTheme.bodyMedium,
        yearStyle: AsheeigheTypography.textTheme.bodyMedium,
        weekdayStyle: AsheeigheTypography.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF79747E),
        ),
      ),

      // ─── Time Picker ───────────────────────────
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        dialHandColor: AsheeigheColors.pastelPink,
        dialBackgroundColor: AsheeigheColors.pastelPink.withOpacity(0.12),
        hourMinuteColor: AsheeigheColors.pastelPink.withOpacity(0.12),
        hourMinuteTextColor: AsheeigheColors.surfaceOnLight,
        dayPeriodColor: AsheeigheColors.pastelPink.withOpacity(0.12),
        dayPeriodTextColor: AsheeigheColors.surfaceOnLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hourMinuteTextStyle: AsheeigheTypography.textTheme.headlineMedium,
        dayPeriodTextStyle: AsheeigheTypography.textTheme.titleMedium,
        helpTextStyle: AsheeigheTypography.textTheme.bodyMedium,
      ),

      // ─── Divider ───────────────────────────────
      dividerTheme: DividerThemeData(
        color: const Color(0xFFCAC4D0).withOpacity(0.4),
        thickness: 1,
        space: 1,
      ),

      // ─── Progress Indicator ────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AsheeigheColors.pastelPink,
        linearTrackColor: AsheeigheColors.pastelPink.withOpacity(0.24),
        circularTrackColor: AsheeigheColors.pastelPink.withOpacity(0.24),
      ),

      // ─── Menu / Popup ──────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        textStyle: AsheeigheTypography.textTheme.bodyMedium,
      ),

      // ─── Navigation Bar (Material 3) ───────────
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        backgroundColor: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AsheeigheColors.pastelPink.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AsheeigheTypography.textTheme.labelMedium?.copyWith(
              color: AsheeigheColors.pastelPink,
            );
          }
          return AsheeigheTypography.textTheme.labelSmall;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AsheeigheColors.pastelPink, size: 24);
          }
          return const IconThemeData(color: Color(0xFF79747E), size: 24);
        }),
      ),

      // ─── Drawer ────────────────────────────────
      drawerTheme: DrawerThemeData(
        elevation: 8,
        backgroundColor: AsheeigheColors.creamWhite,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),

      extensions: const [
        _AsheeigheGlassTheme(
          surface: AsheeigheColors.glassLight,
          stroke: AsheeigheColors.glassStrokeLight,
        ),
      ],
    );
  }

  static ThemeData _buildDark() {
    final colorScheme = ColorScheme.dark(
      primary: AsheeigheColors.darkPastelPink,
      onPrimary: Colors.white,
      primaryContainer: AsheeigheColors.darkSoftRose,
      onPrimaryContainer: Colors.white,
      secondary: AsheeigheColors.darkSoftLavender,
      onSecondary: Colors.white,
      secondaryContainer: AsheeigheColors.darkGentlePurple,
      onSecondaryContainer: Colors.white,
      tertiary: AsheeigheColors.darkMint,
      onTertiary: Colors.black87,
      error: const Color(0xFFEF9A9A),
      onError: Colors.black87,
      errorContainer: const Color(0xFF8B1A1A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: AsheeigheColors.surfaceDark,
      onSurface: AsheeigheColors.surfaceOnDark,
      surfaceContainerHighest: AsheeigheColors.surfaceContainerDark,
      onSurfaceVariant: const Color(0xFFCAC4D0),
      outline: const Color(0xFF938F99),
      outlineVariant: const Color(0xFF49454F),
      inverseSurface: AsheeigheColors.surfaceLight,
      onInverseSurface: AsheeigheColors.surfaceOnLight,
      inversePrimary: AsheeigheColors.pastelPink,
      shadow: Colors.black45,
      scrim: Colors.black54,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AsheeigheTypography.textTheme.apply(
        displayColor: AsheeigheColors.surfaceOnDark,
        bodyColor: AsheeigheColors.surfaceOnDark,
      ),
      brightness: Brightness.dark,

      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        color: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AsheeigheColors.surfaceOnDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AsheeigheTypography.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AsheeigheColors.surfaceOnDark,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        selectedItemColor: AsheeigheColors.darkPastelPink,
        unselectedItemColor: const Color(0xFF938F99),
        selectedLabelStyle: AsheeigheTypography.textTheme.labelMedium,
        unselectedLabelStyle: AsheeigheTypography.textTheme.labelSmall,
        indicatorColor: AsheeigheColors.darkPastelPink.withOpacity(0.24),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AsheeigheColors.darkPastelPink,
        foregroundColor: Colors.white,
        extendedTextStyle: AsheeigheTypography.textTheme.labelLarge,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AsheeigheColors.surfaceContainerDark,
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
            color: AsheeigheColors.darkPastelPink,
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
        labelStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFCAC4D0),
        ),
        hintStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF938F99),
        ),
        errorStyle: AsheeigheTypography.textTheme.bodySmall?.copyWith(
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
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          backgroundColor: AsheeigheColors.darkPastelPink,
          foregroundColor: Colors.white,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          backgroundColor: AsheeigheColors.darkPastelPink,
          foregroundColor: Colors.white,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          side: const BorderSide(color: AsheeigheColors.darkPastelPink),
          foregroundColor: AsheeigheColors.surfaceOnDark,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AsheeigheTypography.textTheme.labelLarge,
          foregroundColor: AsheeigheColors.darkPastelPink,
        ),
      ),

      chipThemeData: ChipThemeData(
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: AsheeigheTypography.textTheme.labelMedium,
        secondaryLabelStyle: AsheeigheTypography.textTheme.labelMedium,
        backgroundColor: AsheeigheColors.darkSoftLavender.withOpacity(0.2),
        selectedColor: AsheeigheColors.darkPastelPink.withOpacity(0.3),
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
            return AsheeigheColors.darkPastelPink;
          }
          return const Color(0xFF49454F);
        }),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: AsheeigheColors.darkPastelPink,
        inactiveTrackColor: AsheeigheColors.darkPastelPink.withOpacity(0.24),
        thumbColor: AsheeigheColors.darkPastelPink,
        overlayColor: AsheeigheColors.darkPastelPink.withOpacity(0.12),
        activeTickMarkColor: Colors.white,
        inactiveTickMarkColor: AsheeigheColors.darkPastelPink.withOpacity(0.5),
        valueIndicatorColor: AsheeigheColors.darkPastelPink,
        valueIndicatorTextStyle: AsheeigheTypography.textTheme.labelSmall?.copyWith(
          color: Colors.black87,
        ),
      ),

      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AsheeigheTypography.textTheme.headlineSmall?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        contentTextStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: const Color(0xFF49454F),
        modalBackgroundColor: AsheeigheColors.surfaceContainerDark,
        modalElevation: 8,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: AsheeigheColors.surfaceOnDark,
        contentTextStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceDark,
        ),
        actionTextColor: AsheeigheColors.darkPastelPink,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AsheeigheColors.surfaceOnDark,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AsheeigheTypography.textTheme.bodySmall?.copyWith(
          color: AsheeigheColors.surfaceDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AsheeigheColors.darkPastelPink,
        headerForegroundColor: Colors.white,
        todayForegroundColor: WidgetStateProperty.all(
          AsheeigheColors.darkPastelPink,
        ),
        todayBackgroundColor: WidgetStateProperty.all(
          AsheeigheColors.darkPastelPink.withOpacity(0.12),
        ),
        selectedDayBackgroundColor: WidgetStateProperty.all(
          AsheeigheColors.darkPastelPink,
        ),
        selectedDayForegroundColor: WidgetStateProperty.all(Colors.white),
        dayShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        yearShape: const WidgetStatePropertyAll(ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        )),
        dayStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        yearStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        weekdayStyle: AsheeigheTypography.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF938F99),
        ),
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        dialHandColor: AsheeigheColors.darkPastelPink,
        dialBackgroundColor: AsheeigheColors.darkPastelPink.withOpacity(0.12),
        hourMinuteColor: AsheeigheColors.darkPastelPink.withOpacity(0.12),
        hourMinuteTextColor: AsheeigheColors.surfaceOnDark,
        dayPeriodColor: AsheeigheColors.darkPastelPink.withOpacity(0.12),
        dayPeriodTextColor: AsheeigheColors.surfaceOnDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hourMinuteTextStyle: AsheeigheTypography.textTheme.headlineMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        dayPeriodTextStyle: AsheeigheTypography.textTheme.titleMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
        helpTextStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: const Color(0xFF49454F).withOpacity(0.6),
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AsheeigheColors.darkPastelPink,
        linearTrackColor: AsheeigheColors.darkPastelPink.withOpacity(0.24),
        circularTrackColor: AsheeigheColors.darkPastelPink.withOpacity(0.24),
      ),

      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        textStyle: AsheeigheTypography.textTheme.bodyMedium?.copyWith(
          color: AsheeigheColors.surfaceOnDark,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AsheeigheColors.darkPastelPink.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AsheeigheTypography.textTheme.labelMedium?.copyWith(
              color: AsheeigheColors.darkPastelPink,
            );
          }
          return AsheeigheTypography.textTheme.labelSmall?.copyWith(
            color: const Color(0xFF938F99),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AsheeigheColors.darkPastelPink,
              size: 24,
            );
          }
          return const IconThemeData(color: Color(0xFF938F99), size: 24);
        }),
      ),

      drawerTheme: DrawerThemeData(
        elevation: 8,
        backgroundColor: AsheeigheColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),

      extensions: const [
        _AsheeigheGlassTheme(
          surface: AsheeigheColors.glassDark,
          stroke: AsheeigheColors.glassStrokeDark,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Glassmorphism Theme Extension
// ──────────────────────────────────────────────
class _AsheeigheGlassTheme extends ThemeExtension<_AsheeigheGlassTheme> {
  final Color surface;
  final Color stroke;

  const _AsheeigheGlassTheme({
    required this.surface,
    required this.stroke,
  });

  @override
  _AsheeigheGlassTheme copyWith({Color? surface, Color? stroke}) {
    return _AsheeigheGlassTheme(
      surface: surface ?? this.surface,
      stroke: stroke ?? this.stroke,
    );
  }

  @override
  _AsheeigheGlassTheme lerp(_AsheeigheGlassTheme? other, double t) {
    if (other == null) return this;
    return _AsheeigheGlassTheme(
      surface: Color.lerp(surface, other.surface, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
    );
  }
}

extension AsheeigheGlassX on ThemeData {
  Color get glassSurface =>
      extension<_AsheeigheGlassTheme>()?.surface ?? AsheeigheColors.glassLight;
  Color get glassStroke =>
      extension<_AsheeigheGlassTheme>()?.stroke ?? AsheeigheColors.glassStrokeLight;
}
