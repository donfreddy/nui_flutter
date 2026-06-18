# Migration Guide: Famsub-Mobile & Tallyno-Mobile → nui_flutter

> Migrate both apps from their in-house design system (`FamsubTokens`/`FamsubTheme` etc.) to the standalone `nui_flutter` package.

---

## Table of Contents

1. [Add nui_flutter dependency](#1-add-nui_flutter-dependency)
2. [Create a palette bridge](#2-create-a-palette-bridge)
3. [Replace FamsubTheme → NTheme](#3-replace-famsubtheme--ntheme)
4. [Replace FamsubTokens → NTokens](#4-replace-famsubtokens--ntokens)
5. [Replace FamsubSpacing → NSpacing](#5-replace-famsubspacing--nspacing)
6. [Replace FamsubButton → NButton](#6-replace-famsubbutton--nbutton)
7. [Replace FamsubInput → NInput](#7-replace-famsubinput--ninput)
8. [Remove obsolete files](#8-remove-obsolete-files)
9. [Verify & cleanup](#9-verify--cleanup)

---

## 1. Add nui_flutter dependency

### famsub-mobile

In `pubspec.yaml`, add under `dependencies`:

```yaml
nui_flutter:
  path: ../../nui_flutter  # relative path to the nui_flutter checkout
```

### tallyno-mobile

In `pubspec.yaml`, add under `dependencies`:

```yaml
nui_flutter:
  path: ../../nui_flutter
```

Then run:

```bash
flutter pub get
```

---

## 2. Create a palette bridge

`nui_flutter` uses `NColorPalette` (a `ThemeExtension`) injected via `NTheme.lightTheme()` / `NTheme.darkTheme()`. Each app needs to build its own branded palette.

### famsub-mobile palette

`lib/core/theme/famsub_palette.dart`:

```dart
import 'package:nui_flutter/nui_flutter.dart';
import 'famsub_colors.dart';

/// Famsub brand colors mapped to the NColorPalette shape.
class FamsubPalette {
  static NColorPalette light() => NColorPalette.light(
        primary: FamsubColors.orange500,
        secondary: FamsubColors.zinc600,
        success: FamsubColors.emerald500,
        error: FamsubColors.red500,
        warning: FamsubColors.amber500,
        info: FamsubColors.blue500,
        bgDefault: Colors.white,
        bgElevated: Colors.white,
        bgMuted: FamsubColors.zinc50,
        textDefault: FamsubColors.zinc900,
        textMuted: FamsubColors.zinc600,
        textDisabled: FamsubColors.zinc400,
        borderDefault: FamsubColors.zinc200,
        borderMuted: FamsubColors.zinc100,
        // ... adjust other fields as needed
      );

  static NColorPalette dark() => NColorPalette.dark(
        primary: FamsubColors.orange400,
        secondary: FamsubColors.zinc400,
        success: FamsubColors.emerald400,
        error: FamsubColors.red400,
        warning: FamsubColors.amber400,
        info: FamsubColors.blue400,
        bgDefault: FamsubColors.zinc950,
        bgElevated: FamsubColors.zinc900,
        bgMuted: FamsubColors.zinc950,
        textDefault: FamsubColors.zinc50,
        textMuted: FamsubColors.zinc400,
        textDisabled: FamsubColors.zinc600,
        borderDefault: FamsubColors.zinc800,
        borderMuted: FamsubColors.zinc900,
        // ... adjust other fields as needed
      );
}
```

### tallyno-mobile palette

Create `lib/core/theme/tallyno_palette.dart` following the same shape but with Tallyno's brand colors.

---

## 3. Replace FamsubTheme → NTheme

### Before (`lib/core/app/famsub_app.dart`)

```dart
theme: FamsubTheme.lightTheme(context),
darkTheme: FamsubTheme.darkTheme(context),
```

### After

```dart
theme: NTheme.lightTheme(
  palette: FamsubPalette.light(),
  radius: 8.0,
  extensions: [
    // App-specific ThemeExtensions if any
  ],
),
darkTheme: NTheme.darkTheme(
  palette: FamsubPalette.dark(),
  radius: 8.0,
  extensions: [
    // App-specific ThemeExtensions if any
  ],
),
```

**What NTheme provides** (so you can delete the corresponding code from `FamsubTheme`):

| Feature | Before | After |
|---------|--------|-------|
| Color scheme | Manual `ColorScheme.light/dark` with hardcoded tokens | Auto-built from `NColorPalette` |
| Scaffold background | `scaffoldBackgroundColor: FamsubTokens.bgDefault*` | `palette.bgDefault` via NTheme |
| Card color | `cardColor: FamsubTokens.bgElevated*` | `palette.bgElevated` via NTheme |
| Text theme | `_textTheme()` with hardcoded sizes | NTheme's built-in Tailwind-scale text theme |
| NButtonTheme | Not registered | Default included (can be overridden via `extensions`) |
| NInputTheme | Not registered | Default included (can be overridden via `extensions`) |

**What stays in the app** (Material component theme overrides that NTheme intentionally does NOT set):

- `AppBarTheme` → NAppBar provides its own; remove the global override
- `CardTheme` → NCard provides its own; remove the global override
- `ElevatedButtonThemeData` / `OutlinedButtonThemeData` / `TextButtonThemeData` → NButton is used instead; remove these
- `InputDecorationTheme` → NInput handles its own styling; remove this
- `BottomNavigationBarTheme` → keep (nui_flutter doesn't provide a bottom nav component yet)
- `DrawerTheme` → keep
- `IconTheme` / `DividerTheme` → keep or replace

After the switch, you can **delete `famsub_theme.dart`** entirely (481 lines gone).

---

## 4. Replace FamsubTokens → NTokens

### API mapping

| Old | New |
|-----|-----|
| `FamsubTokens.primary(context)` | `NTokens.primary(context)` |
| `FamsubTokens.secondary(context)` | `NTokens.secondary(context)` |
| `FamsubTokens.success(context)` | `NTokens.success(context)` |
| `FamsubTokens.error(context)` | `NTokens.error(context)` |
| `FamsubTokens.warning(context)` | `NTokens.warning(context)` |
| `FamsubTokens.info(context)` | `NTokens.info(context)` |
| `FamsubTokens.bgDefault(context)` | `NTokens.bgDefault(context)` |
| `FamsubTokens.bgElevated(context)` | `NTokens.bgElevated(context)` |
| `FamsubTokens.bgInverted(context)` | `NTokens.bgInverted(context)` |
| `FamsubTokens.bgMuted(context)` | `NTokens.bgMuted(context)` |
| `FamsubTokens.textDefault(context)` | `NTokens.textDefault(context)` |
| `FamsubTokens.textInverted(context)` | `NTokens.textInverted(context)` |
| `FamsubTokens.textMuted(context)` | `NTokens.textMuted(context)` |
| `FamsubTokens.textDisabled(context)` | `NTokens.textDisabled(context)` |
| `FamsubTokens.borderDefault(context)` | `NTokens.borderDefault(context)` |
| `FamsubTokens.borderMuted(context)` | `NTokens.borderMuted(context)` |
| `FamsubTokens.borderHover(context)` | `NTokens.borderHover(context)` |
| `FamsubTokens.radiusDefault` | `NTokens.radiusDefault` |
| `FamsubTokens.radiusSm` | `NTokens.radiusSm` |
| `FamsubTokens.radiusLg` | `NTokens.radiusLg` |
| `FamsubTokens.radiusXl` | `NTokens.radiusXl` |
| `FamsubTokens.paddingDefault` | `NTokens.paddingDefault` |
| `FamsubTokens.paddingLg` | `NTokens.paddingLg` |

### Extra tokens available in NTokens (not in FamsubTokens)

| Token | Purpose |
|-------|---------|
| `NTokens.bgAccented(context)` | Accented background for emphasis |
| `NTokens.textHighlighted(context)` | Highest-emphasis text |
| `NTokens.textToned(context)` | Mid-emphasis text (between default and muted) |
| `NTokens.primaryBg(context)` / `.primaryBorder` / `.primaryText` | Semantic tinted variants for each color |
| Same for `secondary*`, `success*`, `error*`, `warning*`, `info*` | |

### Regex-based find-and-replace

```bash
# In lib/ directory (famsub-mobile or tallyno-mobile)
find lib/ -name '*.dart' -exec sed -i '' \
  -e 's/FamsubTokens\./NTokens./g' \
  {} +
```

Or use the IDE's "Replace in Files" feature.

### Manual imports to update

After the find-and-replace, update imports to use the nui_flutter barrel:

```dart
// Before
import 'package:famsub_mobile/core/core.dart';
// or
import 'package:famsub_mobile/core/theme/famsub_tokens.dart';

// After (add alongside existing imports)
import 'package:nui_flutter/nui_flutter.dart';
```

> **Note**: `FamsubTokens` also defines raw color constants (e.g., `primaryLight`, `primaryDark`). These are replaced by the `NColorPalette` light/dark factories. The static `FamsubTokens.primaryLight` pattern is no longer needed — use `FamsubPalette.light().primary` instead.

---

## 5. Replace FamsubSpacing → NSpacing

### Mapping

| Old | New |
|-----|-----|
| `FamsubSpacing.s0` | `NSpacing.s0` |
| `FamsubSpacing.s1` | `NSpacing.s1` |
| `FamsubSpacing.s2` | `NSpacing.s2` |
| `FamsubSpacing.s3` | `NSpacing.s3` |
| `FamsubSpacing.s4` | `NSpacing.s4` |
| `FamsubSpacing.s5` | `NSpacing.s5` |
| `FamsubSpacing.s6` | `NSpacing.s6` |
| `FamsubSpacing.s8` | `NSpacing.s8` |
| `FamsubSpacing.s12` | `NSpacing.s12` |
| `FamsubSpacing.s16` | `NSpacing.s16` |
| `FamsubSpacing.tight` | `NSpacing.tight` |
| `FamsubSpacing.normal` | `NSpacing.normal` |
| `FamsubSpacing.comfortable` | `NSpacing.comfortable` |
| `FamsubSpacing.spacious` | `NSpacing.spacious` |
| `FamsubSpacing.extraSpacious` | `NSpacing.extraSpacious` |
| `FamsubSpacing.componentPadding` | `NSpacing.componentPadding` |
| `FamsubSpacing.itemGap` | `NSpacing.itemGap` |
| `FamsubSpacing.sectionGap` | `NSpacing.sectionGap` |
| `FamsubSpacing.screenPadding` | `NSpacing.screenPadding` |
| `FamsubSpacing.vertical(x)` | `NSpacing.vertical(x)` |
| `FamsubSpacing.horizontal(x)` | `NSpacing.horizontal(x)` |
| `FamsubSpacing.square(x)` | `NSpacing.square(x)` |

### Find-and-replace

```bash
find lib/ -name '*.dart' -exec sed -i '' \
  -e 's/FamsubSpacing\./NSpacing./g' \
  {} +
```

The values are identical (both follow Tailwind's 4px base unit scale).

---

## 6. Replace FamsubButton → NButton

### Constructor mapping

| FamsubButton | NButton |
|--------------|---------|
| `FamsubButton(label: ..., onPressed: ...)` | `NButton(label: ..., onPressed: ...)` |
| `FamsubButton(child: ..., onPressed: ...)` | `NButton(child: ..., onPressed: ...)` |
| `variant: FamsubButtonVariant.outline` | `variant: NButtonVariant.outline` |
| `variant: FamsubButtonVariant.soft` | `variant: NButtonVariant.soft` |
| `variant: FamsubButtonVariant.subtle` | `variant: NButtonVariant.subtle` |
| `variant: FamsubButtonVariant.ghost` | `variant: NButtonVariant.ghost` |
| `variant: FamsubButtonVariant.link` | `variant: NButtonVariant.link` |
| `size: FamsubButtonSize.xs` | `size: NButtonSize.xs` |
| `color: FamsubButtonColor.error` | `color: NButtonColor.error` |
| `loading: true` | `loading: true` (same) |
| `disabled: true` | `disabled: true` (same) |
| `block: true` | `block: true` (same) |
| `roundedFull: false` | `roundedFull: false` (same) |

### Named constructors

```dart
// Before
FamsubButton(...)  // all variants use the same constructor

// After — NButton adds convenience constructors
NButton.outline(label: 'Cancel', onPressed: () {})
NButton.ghost(label: 'Skip', onPressed: () {})
NButton.destructive(label: 'Delete', onPressed: () {})
```

### Key behavioral diff

NButton wraps content in `ScaleTransition` for press feedback and uses `lucide_icons_flutter` for the loading spinner instead of `CircularProgressIndicator`. The loading icon can be customized via `NButtonTheme(loadingIcon: ...)`.

### Find-and-replace

```bash
# Enums
find lib/ -name '*.dart' -exec sed -i '' \
  -e 's/FamsubButtonVariant\./NButtonVariant./g' \
  -e 's/FamsubButtonSize\./NButtonSize./g' \
  -e 's/FamsubButtonColor\./NButtonColor./g' \
  {} +

# Class
find lib/ -name '*.dart' -exec sed -i '' \
  -e 's/FamsubButton/NButton/g' \
  {} +
```

---

## 7. Replace FamsubInput → NInput

### Constructor mapping

| FamsubInput | NInput |
|-------------|--------|
| `FamsubInput(label: ..., placeholder: ...)` | `NInput(label: ..., placeholder: ...)` |
| `size: FamsubInputSize.lg` | `size: NInputSize.lg` |
| `variant: FamsubInputVariant.soft` | `variant: NInputVariant.soft` |
| `color: FamsubInputColor.success` | `color: NInputColor.success` |

### Named constructors

```dart
// Before
FamsubInput(label: 'Amount', keyboardType: TextInputType.number, ...)

// After — dedicated constructors
NInput.amount(label: 'Amount', ...)
NInput.phone(label: 'Phone', ...)
NInput.otp(...)
```

### Removed parameters

- `leadingText` / `trailingText` — available on the base `NInput` constructor as well as the named constructors (`.amount`, `.phone`, `.otp`). Use `leading`/`trailing` widget parameters if you need a fully custom leading/trailing element.

### Find-and-replace

```bash
# Enums
find lib/ -name '*.dart' -exec sed -i '' \
  -e 's/FamsubInputSize\./NInputSize./g' \
  -e 's/FamsubInputVariant\./NInputVariant./g' \
  -e 's/FamsubInputColor\./NInputColor./g' \
  {} +

# Class
find lib/ -name '*.dart' -exec sed -i '' \
  -e 's/FamsubInput/NInput/g' \
  {} +
```

---

## 8. Remove obsolete files

After the migration, these files can be deleted from each app:

### famsub-mobile

| File | Reason |
|------|--------|
| `lib/core/theme/famsub_theme.dart` | Replaced by `NTheme` + `FamsubPalette` |
| `lib/core/theme/famsub_tokens.dart` | Replaced by `NTokens` + palette |
| `lib/core/theme/famsub_spacing.dart` | Replaced by `NSpacing` |
| `lib/core/theme/famsub_colors.dart` | Optional — can keep as raw color constants for palette construction |
| `lib/core/shared/presentation/widgets/famsub_button.dart` | Replaced by `NButton` |
| `lib/core/shared/presentation/widgets/famsub_input.dart` | Replaced by `NInput` |

Also update barrel files:
- `lib/core/theme/theme.dart` — remove `famsub_theme`, `famsub_tokens`, `famsub_spacing` exports; add `famsub_palette`
- `lib/core/shared/shared.dart` — remove `famsub_button`, `famsub_input` exports

### tallyno-mobile

Analogous files — remove the tallyno equivalents of `FamsubTheme`, `FamsubTokens`, `FamsubSpacing`, `FamsubButton`, `FamsubInput`.

---

## 9. Verify & cleanup

```bash
# 1. Run analyzer
flutter analyze

# 2. Run tests
flutter test

# 3. Run build_runner (if models changed)
dart run build_runner build --delete-conflicting-outputs

# 4. Remove unused imports
# Run the analyzer and fix any unused import warnings manually
```

### Common gotchas

1. **Missing context parameter**: `FamsubTokens.primary()` took a `context` argument and `NTokens.primary()` does too — same API, should be fine.

2. **`FamsubTextScale` vs `NTextScale`**: `NTextScale` is `@Deprecated` — use `NTheme.lightTheme(textScale: 1.15)` / `NTheme.darkTheme(textScale: 1.15)` instead. The class is kept only for backward compatibility during migration.

3. **`width8`, `height8` constants**: `famsub_button.dart` used shorthand constants like `width8`. `NButton` uses `NSpacing.s2` instead. If you used `FamsubButton` directly, the replacement is seamless. If you copied the pattern elsewhere, switch to `NSpacing`.

4. **Import path changes**: After deleting obsolete files, remove their import statements. The `nui_flutter` barrel (`package:nui_flutter/nui_flutter.dart`) exports everything needed.

---

## Summary of replaced files

| Layer | Before | After |
|-------|--------|-------|
| Theme factory | `FamsubTheme.lightTheme(context)` | `NTheme.lightTheme(palette: ..., radius: ...)` |
| Color tokens | `FamsubTokens.primary(context)` | `NTokens.primary(context)` |
| Color palette | `FamsubColors` raw constants | `NColorPalette` + `FamsubPalette` bridge |
| Spacing | `FamsubSpacing.s4` | `NSpacing.s4` |
| Buttons | `FamsubButton(...)` | `NButton(...)` |
| Inputs | `FamsubInput(...)` | `NInput(...)` |
| Avatar | `NAvatar` (already from earlier migration) | `NAvatar` (stays) |
| Theme extensions | None registered | `NButtonTheme`, `NInputTheme` auto-registered |
