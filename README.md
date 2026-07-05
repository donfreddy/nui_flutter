# nui_flutter

A Flutter design system inspired by [Nuxt UI](https://ui.nuxt.com), bringing its component philosophy, semantic color tokens, and variant system to mobile apps.

Built on top of Flutter's `ThemeExtension` API for clean multi-brand support, full dark mode, and zero global state leakage between apps.

## Features

- **25+ production-ready components** covering buttons, inputs, cards, avatars, badges, alerts, toggles, dropdowns, tab bars, bottom sheets, modals, toasts, progress bars, skeletons, checkboxes, radio groups, textareas, and more
- **Semantic color tokens** via `NColors` for consistent, brand-aware theming
- **Full dark mode** with `NTheme.lightTheme` and `NTheme.darkTheme` factories
- **Multi-brand support** by passing a custom palette per app with no shared state
- **Nuxt UI variant system** ported to Flutter: `NVariant` enum (`solid`, `outline`, `soft`, `subtle`, `ghost`, `link`) + `NVariantSupport` per-component validation + `NVariantResolver` for concrete color resolution
- **Lucide icons** self-hosted via `NIcons`, no external icon dependency
- **Accessibility-first** with `Semantics` wrappers on all interactive components

## Installation

Add the package to your app's `pubspec.yaml`:

```yaml
dependencies:
  nui_flutter:
    path: ../nui_flutter  # path dependency during development
```

Then run:

```sh
flutter pub get
```

See the [`example/`](example) directory for a complete showcase app demonstrating all components.

## Quick start

### 1. Wrap your app with NTheme

```dart
import 'package:flutter/material.dart';
import 'package:nui_flutter/nui_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: NTheme.lightTheme(colors: _lightColors),
      darkTheme: NTheme.darkTheme(colors: _darkColors),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

final _lightColors = NColors.light(
  palette: {
    NColorRole.primary: NRoleColor(Color(0xFFF97316)),
    NColorRole.secondary: NRoleColor(Color(0xFF6B7280)),
    NColorRole.success: NRoleColor(Color(0xFF10B981)),
    NColorRole.error: NRoleColor(Color(0xFFEF4444)),
  },
);

final _darkColors = NColors.dark(
  palette: {
    NColorRole.primary: NRoleColor(Color(0xFFF97316)),
    NColorRole.secondary: NRoleColor(Color(0xFF6B7280)),
    NColorRole.success: NRoleColor(Color(0xFF10B981)),
    NColorRole.error: NRoleColor(Color(0xFFEF4444)),
  },
);
```

### 2. Use components

```dart
import 'package:nui_flutter/nui_flutter.dart';

// Button
NButton(
  label: 'Send money',
  onPressed: () {},
  color: NColorRole.primary,
)

// Input
NInput(
  label: 'Amount',
  placeholder: '0.00',
  keyboardType: TextInputType.number,
  trailingText: 'FCFA',
)

// Card
NCard(
  header: const NCardHeader(title: 'Balance', subtitle: 'Available funds'),
  child: const Text('5 000 FCFA'),
  footer: NCardFooter(actions: [
    NButton(label: 'Send', onPressed: () {}),
    NButton.outline(label: 'Request', onPressed: () {}),
  ]),
)
```

## Theming

### Color palette

`NColors` defines all semantic color tokens for an app. It is registered as a `ThemeExtension` in `ThemeData` via `NTheme`.

```dart
NColors.light(
  palette: {
    NColorRole.primary: NRoleColor(Color(0xFFF97316)),
    NColorRole.secondary: NRoleColor(Color(0xFF6B7280)),
    NColorRole.success: NRoleColor(Color(0xFF10B981)),
    NColorRole.error: NRoleColor(Color(0xFFEF4444)),
  },
)
```

### Accessing tokens at runtime

Use `context.nui` inside any `build` method:

```dart
final colors = context.nui.colors;
final radius = context.nui.radius.md;
final shadow = context.nui.shadows.sm;
```

### Custom component themes

Override button or input defaults by passing extra extensions to `NTheme`:

```dart
NTheme.lightTheme(
  colors: myColors,
  extensions: [
    const NButtonTheme(radius: 4.0),
    const NInputTheme(radius: 4.0),
  ],
)
```

### Variant system

The variant system is split across two files:

| File | Location | Contents |
|------|----------|----------|
| `n_variant.dart` | `lib/src/tokens/` | `NVariant` enum + `NVariantSupport` (per-component allowed-variant sets) |
| `n_variant_resolver.dart` | `lib/src/theme/` | `NVariantResolver.resolve(NColorRole, NVariant, NColors)` → `NResolvedColors` |

Components validate their variant at development time via `NVariantSupport`, then delegate color resolution to `NVariantResolver` at runtime.

## Component catalog

### Buttons

```dart
NButton(label: 'Primary', onPressed: () {})
NButton(label: 'Success', color: NColorRole.success, onPressed: () {})
NButton(label: 'Outline', variant: NVariant.outline, onPressed: () {})
NButton(label: 'Soft', variant: NVariant.soft, onPressed: () {})
NButton(label: 'Ghost', variant: NVariant.ghost, onPressed: () {})
NButton(label: 'Link', variant: NVariant.link, onPressed: () {})
NButton(label: 'Loading', loading: true, onPressed: () {})
NButton(label: 'Disabled', disabled: true, onPressed: () {})
NButton(label: 'Full width', block: true, onPressed: () {})
NButton.destructive(label: 'Delete account', onPressed: _delete)
```

### Inputs

```dart
NInput(label: 'Email', placeholder: 'you@example.com')
NInput(label: 'Password', obscureText: true, passwordToggle: true)
NInput(label: 'Search', leading: const Icon(NIcons.search), clearable: true)
NInput(label: 'Bio', maxLines: 4, minLines: 3)
NInput.amount(label: 'Amount', trailingText: 'FCFA')
NInput.phone(label: 'Phone')
NInput.otp(controller: _ctrl, onSubmitted: _verify)
```

### Cards

```dart
NCard(child: const Text('Outline card'))
NCard.soft(child: const Text('Soft card'))
NCard.subtle(child: const Text('Subtle card'))
NCard(variant: NVariant.outline, color: NColorRole.success, child: ...)
NCard(onTap: () {}, child: const Text('Tappable card'))
```

### Avatars

```dart
NAvatar(name: 'John Doe')
NAvatar(imageUrl: 'https://example.com/photo.jpg')
NAvatar(name: 'JD', size: NAvatarSize.lg) // NAvatarSize enum

NAvatarGroup(
  avatars: [
    NAvatar(name: 'Alice'),
    NAvatar(name: 'Bob'),
    NAvatar(name: 'Carol'),
  ],
  max: 3,
)
```

### Alerts

```dart
NAlert(title: 'Success', description: 'Payment sent.', color: NColorRole.success)
NAlert(title: 'Warning', description: 'Low balance.', color: NColorRole.warning, variant: NVariant.soft)
NAlert(title: 'Error', description: 'Transfer failed.', color: NColorRole.error, variant: NVariant.outline)
```

### Badges and chips

```dart
NBadge(label: 'New')
NBadge(label: 'Active', color: NColorRole.success, variant: NVariant.soft)
NBadge.dot(color: NColorRole.error)

NChip(label: 'Category', selected: true, onPressed: () {})
NChipGroup(
  chips: ['All', 'Pending', 'Completed'],
  selectedIndex: _index,
  onChanged: (i) => setState(() => _index = i),
)
```

### Toggle

```dart
NToggle(
  value: _enabled,
  onChanged: (v) => setState(() => _enabled = v),
  label: 'Enable notifications',
)
```

### Dropdown

```dart
NDropdown<String>(
  items: [
    NDropdownItem(value: 'usd', label: 'USD'),
    NDropdownItem(value: 'eur', label: 'EUR'),
    NDropdownItem(value: 'xof', label: 'FCFA'),
  ],
  value: _currency,
  onChanged: (v) => setState(() => _currency = v),
  placeholder: 'Select currency',
)
```

### Navigation

```dart
// App bar
NAppBar(
  title: 'Wallet',
  showBack: true,
  actions: [NIconButton(icon: NIcons.bell, onPressed: () {})],
)

// Tab bar
NTabBar(
  tabs: [
    NTab(label: 'All'),
    NTab(label: 'Pending', count: 2),
    NTab(label: 'Completed'),
  ],
  selectedIndex: _index,
  onChanged: (i) => setState(() => _index = i),
)
```

### Bottom sheet

```dart
// Generic sheet
NBottomSheet.show(
  context: context,
  title: 'Select currency',
  child: CurrencyPicker(onSelect: _onSelect),
  footer: NButton(block: true, label: 'Confirm', onPressed: () => Navigator.pop(context)),
);

// Action list
NBottomSheetActionList.show(
  context: context,
  title: 'Options',
  actions: [
NBottomSheetAction(label: 'Edit', icon: NIcons.pencil, onTap: _edit),
NBottomSheetAction(label: 'Delete', icon: NIcons.trash2, isDestructive: true, onTap: _delete),
  ],
);
```

### Icon button

```dart
NIconButton(icon: NIcons.share2, onPressed: () {})
NIconButton(icon: NIcons.trash2, color: NColorRole.error, variant: NVariant.soft, onPressed: () {})
```

### Checkbox

```dart
NCheckbox(
  value: _accepted,
  onChanged: (v) => setState(() => _accepted = v),
  label: 'Accept terms',
  description: 'I agree to the terms and conditions.',
)
NCheckbox(value: null, label: 'Indeterminate')  // Indeterminate state
```

### Radio group

```dart
NRadioGroup<String>(
  items: [
    NRadioItem(label: 'Option A', value: 'a'),
    NRadioItem(label: 'Option B', value: 'b'),
    NRadioItem(label: 'Option C', description: 'With description', value: 'c'),
  ],
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
)
```

### Textarea

```dart
NTextarea(
  label: 'Notes',
  placeholder: 'Add your notes here...',
  maxLines: 5,
)
NTextarea(
  label: 'Bio',
  maxLines: 3,
  maxLength: 500,
  helperText: 'Tell us about yourself',
)
```

### Modal

```dart
// Simple confirm dialog
final confirmed = await NModal.dialog(
  context: context,
  title: 'Delete item',
  body: 'This action cannot be undone.',
  destructive: true,
);

// Full custom modal
NModal.show(
  context: context,
  builder: (ctx, close) => NModal(
    title: 'Custom modal',
    body: const Text('Any content here'),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: close, child: const Text('Close')),
      ],
    ),
  ),
);
```

### Toast

```dart
// Auto-dismissing notification
NToast.show(
  context,
  title: 'Payment sent',
  description: 'Your transfer was successful.',
  color: NColorRole.success,
);

// Persistent toast
NToast.show(
  context,
  title: 'Uploading...',
  color: NColorRole.info,
  duration: Duration.zero,
);
```

### Progress

```dart
NProgress(value: 0.5)                                      // Determinate
NProgress(value: 0.75, color: NColorRole.success)          // Colored
NProgress()                                                 // Indeterminate
NProgress(value: null, size: NProgressSize.lg)              // Larger size
```

### Skeleton

```dart
NSkeleton(width: 250, height: 16)    // Text line placeholder
NSkeleton(width: 48, height: 48)     // Avatar placeholder
NSkeleton(height: 200)               // Card placeholder (full width)
```

## Design tokens reference

| Token group | Example accessor | Description |
|-------------|-----------------|-------------|
| Colors | `context.nui.colors.primary` | Primary brand color |
| Backgrounds | `context.nui.colors.bgDefault` | Page background |
| Text | `context.nui.colors.textMuted` | Low-emphasis text |
| Borders | `context.nui.colors.borderDefault` | Default border |
| Shadows | `context.nui.shadows.sm` | Small shadow |
| Radius | `context.nui.radius.md` | Medium radius |

## Comparison with Nuxt UI

| Nuxt UI component | nui_flutter equivalent |
|-------------------|----------------------|
| `UButton` | `NButton` |
| `UInput` | `NInput` |
| `UTextarea` | `NTextarea` |
| `UCheckbox` | `NCheckbox` |
| `URadioGroup` | `NRadioGroup` |
| `UCard` | `NCard` |
| `UAvatar` / `UAvatarGroup` | `NAvatar` / `NAvatarGroup` |
| `UBadge` | `NBadge` |
| `UAlert` | `NAlert` |
| `UChip` | `NChip` / `NChipGroup` |
| `USwitch` | `NToggle` |
| `UDropdownMenu` | `NDropdown` |
| `UTabs` | `NTabBar` |
| `UModal` | `NModal` |
| `UToast` | `NToast` |
| `UProgress` | `NProgress` |
| `USkeleton` | `NSkeleton` |
| `UEmpty` | `NEmptyState` |
| `UModal` / `UDrawer` (mobile) | `NBottomSheet` |
| CSS variables | `NColors` + `context.nui` |
| Tailwind variants | `NVariant` enum |

## Dependencies

nui_flutter has **no third-party dependencies**. The Lucide icon font is self-hosted at `assets/fonts/lucide.ttf` and exposed via the `NIcons` class.

| Asset | Role |
|-------|------|
| `assets/fonts/lucide.ttf` | Self-hosted Lucide icon font (~67 KB, 1986 glyphs) |

## License

Licensed under the [MIT License](LICENSE).
