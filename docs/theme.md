# asheeighe Theme Documentation

## Color Palette

### Primary Pastel Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Pastel Pink | `#F4C2C2` | Primary color, buttons, active states |
| Soft Lavender | `#E6E6FA` | Secondary elements, chip backgrounds |
| Cream White | `#FFF8F0` | Surface, cards, backgrounds |
| Warm Beige | `#F5E6D3` | Container backgrounds |
| Light Peach | `#FFDAB9` | Accent highlights |
| Soft Rose | `#FFB6C1` | Primary container |
| Gentle Purple | `#D8BFD8` | Secondary container |

### Accent Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Mint | `#98FB98` | Success states, tertiary |
| Sky Blue | `#87CEEB` | Info, links |
| Gold | `#FFD700` | Warnings, star ratings |

### Dark Mode Variants

| Color | Hex | Usage |
|-------|-----|-------|
| Dark Pastel Pink | `#C29292` | Primary in dark mode |
| Dark Soft Lavender | `#B6B6D4` | Secondary in dark mode |
| Dark Warm Beige | `#C5B6A3` | Container in dark mode |
| Dark Light Peach | `#CCAA89` | Accent in dark mode |
| Dark Soft Rose | `#CF8694` | Primary container (dark) |
| Dark Gentle Purple | `#A88FA8` | Secondary container (dark) |
| Dark Mint | `#68CB68` | Success in dark mode |
| Dark Sky Blue | `#57AECE` | Info in dark mode |

### Surface Colors

| Token | Light | Dark |
|-------|-------|------|
| `surface` | `#FFF8F0` | `#1C1B1F` |
| `surfaceContainer` | `#FFF0E0` | `#2B2930` |
| `onSurface` | `#1C1B1F` | `#E6E1E5` |

### Semantic Colors

| Token | Light | Dark | Purpose |
|-------|-------|------|---------|
| `success` | `#4CAF50` | `#68CB68` | Positive actions |
| `warning` | `#FFC107` | `#FFD54F` | Caution states |
| `error` | `#E53935` | `#EF9A9A` | Destructive actions |
| `info` | `#2196F3` | `#57AECE` | Informational |

### Glassmorphism

| Token | Light | Dark |
|-------|-------|------|
| `glassSurface` | `#CCFFF8F0` | `#CC1C1B1F` |
| `glassStroke` | `#1A000000` | `#1AFFFFFF` |

## Typography

**Font**: Inter (via Google Fonts)

| Style | Size | Weight | Letter Spacing | Line Height |
|-------|------|--------|----------------|-------------|
| `displayLarge` | 57 | Light 300 | -0.25 | 1.12 |
| `displayMedium` | 45 | Light 300 | 0 | 1.16 |
| `displaySmall` | 36 | Regular 400 | 0 | 1.22 |
| `headlineLarge` | 32 | Medium 500 | 0 | 1.25 |
| `headlineMedium` | 28 | Medium 500 | 0 | 1.29 |
| `headlineSmall` | 24 | Medium 500 | 0 | 1.33 |
| `titleLarge` | 22 | Medium 500 | 0 | 1.27 |
| `titleMedium` | 16 | Medium 500 | 0.15 | 1.50 |
| `titleSmall` | 14 | Medium 500 | 0.10 | 1.43 |
| `bodyLarge` | 16 | Regular 400 | 0.50 | 1.50 |
| `bodyMedium` | 14 | Regular 400 | 0.25 | 1.43 |
| `bodySmall` | 12 | Regular 400 | 0.40 | 1.33 |
| `labelLarge` | 14 | Medium 500 | 0.10 | 1.43 |
| `labelMedium` | 12 | Medium 500 | 0.50 | 1.33 |
| `labelSmall` | 11 | Medium 500 | 0.50 | 1.45 |

## Component Styles

### Cards
- Border radius: `20px`
- Elevation: `1` (light), `2` (dark)
- Margin: `16px` horizontal, `6px` vertical
- Surface tint: transparent

### Buttons

| Type | Background | Text | Radius | Padding |
|------|-----------|------|--------|---------|
| Elevated / Filled | Pastel Pink | Black 87% | 14px | 24x14 |
| Outlined | Transparent | On-surface | 14px | 24x14 |
| Text | Transparent | Pastel Pink | 10px | 16x10 |

### Input Fields
- Filled: `creamyWhite` (`#FFF8F0`) background
- Border radius: `12px`
- Focused border: 2px Pastel Pink
- Label: `bodyMedium`, color `#49454F`

### Bottom Navigation
- Background: Cream White (light) / Surface Container (dark)
- Selected: Pastel Pink icon + label
- Unselected: `#79747E` (light) / `#938F99` (dark)
- Type: `fixed`

### Dialogs & Bottom Sheets
- Border radius: `24px`
- Background: Cream White (light) / Surface Container (dark)
- Bottom sheet: drag handle shown, rounded top corners

### Chips
- Border radius: `20px`
- Background: Soft Lavender at 50% opacity
- Selected: Pastel Pink at 30% opacity
- No border, no checkmark

### Date/Time Pickers
- Header: Pastel Pink background
- Selected day: Pastel Pink
- Rounded day/year shape (`12px`)
- Surface tint: transparent

## Light / Dark Mode

The `AsheeigheTheme` class provides both themes:

```dart
AsheeigheTheme.light   // Light mode
AsheeigheTheme.dark    // Dark mode
```

Switching is handled via `AppTheme` in `apps/mobile/lib/app/theme/app_theme.dart`:

```dart
MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.light,  // or dark, system
)
```

The `themeProvider` in `packages/core/lib/src/providers/theme_provider.dart` persists the user's choice to `SharedPreferences`:

```dart
final themeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return ThemeModeNotifier(prefs);
});
```

## How to Use Theme in Widgets

### Accessing Colors

```dart
// Via ThemeData color scheme
final color = Theme.of(context).colorScheme.primary;

// Via AsheeigheColors constants (packages/ui)
final color = AsheeigheColors.pastelPink;

// Via glassmorphism extension
final glassBg = Theme.of(context).glassSurface;
```

### Using Typography

```dart
// Via theme's text theme
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
);

// Via AsheeigheTypography (for custom use)
final style = AsheeigheTypography.textTheme.titleLarge;
```

### Using Widget Components

```dart
// From packages/ui
AsheeigheButton(
  onPressed: () {},
  child: Text('Save'),
);

AsheeigheInput(
  label: 'Email',
  controller: _emailController,
);

AsheeigheCard(
  child: Column(
    children: [
      AsheeigheSectionHeader(title: 'Today'),
      // content
    ],
  ),
);
```

### Dark Mode Awareness

```dart
// Widget rebuilds when theme changes via provider
final themeMode = ref.watch(themeProvider);

// Or context-based
final isDark = Theme.of(context).brightness == Brightness.dark;
```

## Customizing the Theme

### Changing the Primary Color

Edit `packages/ui/lib/src/theme/asheeighe_colors.dart`:

```dart
abstract final class AsheeigheColors {
  static const Color pastelPink = Color(0xFFF4C2C2);  // Change here
  // ...
}
```

### Adding New Component Styles

Extend `_buildLight()` and `_buildDark()` in `asheeighe_theme.dart`:

```dart
extension _AsheeigheCustomTheme on ThemeData {
  Color get customColor => extension<_AsheeigheCustom>()!.color;
}

class _AsheeigheCustom extends ThemeExtension<_AsheeigheCustom> {
  final Color color;
  const _PinkzCustom({required this.color});

  @override
  _AsheeigheCustom copyWith({Color? color}) {
    return _AsheeigheCustom(color: color ?? this.color);
  }

  @override
  _AsheeigheCustom lerp(_AsheeigheCustom? other, double t) {
    if (other == null) return this;
    return _AsheeigheCustom(color: Color.lerp(color, other.color, t)!);
  }
}
```

### Theme File Locations

| File | Purpose |
|------|---------|
| `packages/ui/lib/src/theme/asheeighe_colors.dart` | Color constants |
| `packages/ui/lib/src/theme/typography.dart` | Typography scale |
| `packages/ui/lib/src/theme/asheeighe_theme.dart` | Full ThemeData (light + dark) |
| `apps/mobile/lib/app/theme/app_theme.dart` | App-level theme overrides |
