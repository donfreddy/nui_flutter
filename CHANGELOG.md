# Changelog

## 0.1.0 — 2026-06-17

- Initial release : `NTheme`, `NColorPalette`, `NTokens`, `NSpacing`, `NTextScale`
- Components : `NButton`, `NInput`, `NCard`, `NAvatar`, `NBadge`, `NChip`, `NToggle`, `NDropdown`, `NAlert`, `NIconButton`, `NAppBar`, `NTabBar`, `NBottomSheet`, `NEmptyState`
- `MIGRATION_GUIDE.md` for `famsub-mobile` and `tallyno-mobile`

### P0 — Critical fixes

- **LICENSE**: Added MIT license file
- **`NTokens._palette`**: Replaced `!` force-unwrap with `?? throw FlutterError` with clear message (safe in release mode)
- **`NAlert.icon`**: Changed type from `Widget?` to `IconData?` to eliminate unsafe `(icon as Icon).icon` cast
- **WCAG contrast test**: Added 8 tests verifying AA contrast (≥4.5:1) for light/dark `ColorScheme` pairs
- **`buildColorScheme`**: Dynamic luminance-based `onPrimary`/`onSecondary`/`onError` — guarantees 4.5:1 minimum regardless of palette colors

### P1 — Architecture

- **`NCardTheme`**: New `ThemeExtension<NCardTheme>` with `borderRadius` and `padding`, registered in `NTheme.extensions`
- **`NTextScale` deprecated**: Static mutable pattern replaced by `NTheme.lightTheme(textScale: ...)` parameter. Class kept for backward compatibility with `@Deprecated` annotation
- **`NButton._onTap`**: Added `_tapping` guard with `try/finally` to prevent double-tap during 160ms animation
- **`NDropdownItem.separator()`**: Replaced `'' as T` with `_unsafeDefault()` that throws `UnsupportedError`
- **`NTheme.textScale`**: Added as direct parameter on both `lightTheme` and `darkTheme` factories, forwarded to `buildTextTheme`

### P1 — NTypography

- **`NTypography`**: New `ThemeExtension<NTypography>` with `fontFamily` support
- Wired through `NTheme.lightTheme(darkTheme(typography: ...))` → `buildTextTheme(typography: ...)` — applied as base `TextTheme` with fontFamily override

### P2 — Shared color resolver

- **`NComponentColor` / `NComponentColors`**: New shared enum + resolver eliminating 10 duplicated `switch → NTokens.*` patterns
- Migrated `NButton`, `NAlert`, `NChip`, `NIconButton`, `NBadge`, `NAvatar`, `NCard`, `NInput`, `NToggle`, `NDropdown` — ~250 lines removed across components
- Neutral mapping customizable via optional parameters per component

### P3 — New components (for pub.dev)

- **`NToast`**: Toast/snackbar overlay with slide animation, auto-dismiss, and `NToast.show()` static method supporting 6 semantic colors
- **`NModal`**: Modal dialog with header/body/footer slots, `NModal.dialog()` helper for confirm dialogs, and `NModal.show()` builder for full customization
- **`NSkeleton`**: Animated pulsing loading placeholder with configurable width, height, and border radius
- **`NProgress`**: Linear progress bar with determinate/indeterminate modes, 5 sizes, 6 semantic colors, and animated transitions
- **`NCheckbox`**: Checkbox input with label/description support, indeterminate state, and 7 color roles
- **`NRadioGroup`**: Typed radio button group with `NRadioItem` model supporting label, description, and value
- **`NTextarea`**: Multi-line text input with NUI theming, label, error text, leading icon, and configurable rows
- **`nui_flutter.dart`**: Barrel file updated to export all 7 new components

### Infrastructure

- **`CHANGELOG.md`**: Created with full history
- **`tool/check.sh`**: Script for running tests before commits
- **`.gitignore`**: Standard Dart/Flutter ignores
- **Tests**: 15 tests (fallback NButton, NInput, extension merge by type, WCAG contrast)
- **`flutter analyze`**: Clean — 0 issues
