import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkz/app/theme/app_theme.dart';

void main() {
  group('AppTheme color constants', () {
    test('primary should be correct pink shade', () {
      expect(AppTheme.primary, const Color(0xFFFF6B9D));
    });

    test('primaryLight should be lighter pink', () {
      expect(AppTheme.primaryLight, const Color(0xFFFFA3C8));
    });

    test('primaryDark should be darker pink', () {
      expect(AppTheme.primaryDark, const Color(0xFFE8457A));
    });

    test('secondary should be purple', () {
      expect(AppTheme.secondary, const Color(0xFF6C63FF));
    });

    test('accent should be yellow', () {
      expect(AppTheme.accent, const Color(0xFFFFD93D));
    });

    test('background should be light pink', () {
      expect(AppTheme.background, const Color(0xFFFDF2F8));
    });

    test('surface should be white', () {
      expect(AppTheme.surface, const Color(0xFFFFFFFF));
    });

    test('error should be red', () {
      expect(AppTheme.error, const Color(0xFFE53935));
    });

    test('success should be green', () {
      expect(AppTheme.success, const Color(0xFF4CAF50));
    });

    test('warning should be orange', () {
      expect(AppTheme.warning, const Color(0xFFFFA726));
    });

    test('textPrimary should be dark navy', () {
      expect(AppTheme.textPrimary, const Color(0xFF1A1A2E));
    });

    test('textSecondary should be gray', () {
      expect(AppTheme.textSecondary, const Color(0xFF6B7280));
    });

    test('textHint should be light gray', () {
      expect(AppTheme.textHint, const Color(0xFF9CA3AF));
    });

    test('divider should be a light gray', () {
      expect(AppTheme.divider, const Color(0xFFE5E7EB));
    });

    group('dark theme colors', () {
      test('darkBackground should be very dark navy', () {
        expect(AppTheme.darkBackground, const Color(0xFF0F0F23));
      });

      test('darkSurface should be dark navy', () {
        expect(AppTheme.darkSurface, const Color(0xFF1A1A2E));
      });

      test('darkTextPrimary should be near white', () {
        expect(AppTheme.darkTextPrimary, const Color(0xFFF3F4F6));
      });

      test('darkTextSecondary should be gray', () {
        expect(AppTheme.darkTextSecondary, const Color(0xFF9CA3AF));
      });
    });

    group('all colors should have correct hex length', () {
      final colors = [
        AppTheme.primary,
        AppTheme.primaryLight,
        AppTheme.primaryDark,
        AppTheme.secondary,
        AppTheme.accent,
        AppTheme.background,
        AppTheme.surface,
        AppTheme.error,
        AppTheme.success,
        AppTheme.warning,
        AppTheme.textPrimary,
        AppTheme.textSecondary,
        AppTheme.textHint,
        AppTheme.divider,
        AppTheme.darkBackground,
        AppTheme.darkSurface,
        AppTheme.darkTextPrimary,
        AppTheme.darkTextSecondary,
      ];

      for (final color in colors) {
        test('${color.value.toRadixString(16)} should be 8-digit hex', () {
          expect(color.value.toRadixString(16).length, 8);
        });
      }
    });
  });
}
