# nui_flutter

A Flutter design system inspired by [Nuxt UI](https://ui.nuxt.com), bringing its component philosophy, semantic color tokens, and variant system to mobile apps.

Built on top of Flutter's `ThemeExtension` API for clean multi-brand support, full dark mode, and zero global state leakage between apps.

---

## Features

- **15+ production-ready components** covering buttons, inputs, cards, avatars, badges, alerts, toggles, dropdowns, tab bars, bottom sheets, and more
- **Semantic color tokens** via `NColorPalette` and `NTokens` for consistent, brand-aware theming
- **Full dark mode** with `NTheme.lightTheme` and `NTheme.darkTheme` factories
- **Multi-brand support** by passing a custom `NColorPalette` per app with no shared state
- **Nuxt UI variant system** ported to Flutter: `solid`, `outline`, `soft`, `subtle`, `ghost`, `link`
- **Lucide icons** built-in via `lucide_icons_flutter`
- **Accessibility-first** with `Semantics` wrappers on all interactive components
- **Responsive sizing** via `flutter_screenutil`

---

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

---

See the [`example/`](example) directory for a complete showcase app demonstrating all components.

## Quick start

### 1. Initialize ScreenUtil and wrap with NTheme

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nui_flutter/nui_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      child: MaterialApp(
        title: 'My App',
        theme: NTheme.lightTheme(palette: _lightPalette),
        darkTheme: NTheme.darkTheme(palette: _darkPalette),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

final _lightPalette = NColorPalette.light(
  primary: const Color(0xFFF97316),
  secondary: const Color(0xFF6B7280),
  success: const Color(0xFF10B981),
  error: const Color(0xFFEF4444),
);

final _darkPalette = NColorPalette.dark(
  primary: const Color(0xFFF97316),
  secondary: const Color(0xFF6B7280),
  success: const Color(0xFF10B981),
  error: const Color(0xFFEF4444),
);
```

### 2. Use components

```dart
import 'package:nui_flutter/nui_flutter.dart';

// Button
NButton(
  label: 'Send money',
  onPressed: () {},
  color: NButtonColor.primary,
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

---

## Theming

### Color palette

`NColorPalette` defines all semantic color tokens for an app. It is registered as a `ThemeExtension` in `ThemeData` via `NTheme`.

```dart
NColorPalette.light(
  // Required brand colors
  primary: Color(0xFFF97316),
  secondary: Color(0xFF6B7280),
  success: Color(0xFF10B981),
  error: Color(0xFFEF4444),

  // Optional overrides (all have defaults)
  warning: Color(0xFFF59E0B),
  info: Color(0xFF3B82F6),
  bgDefault: Color(0xFFFFFFFF),
  textDefault: Color(0xFF18181B),
  // ...
)
```

### Accessing tokens at runtime

Use `NTokens` static accessors anywhere inside `build`:

```dart
Container(
  color: NTokens.primaryBg(context),
  child: Text(
    'Hello',
    style: TextStyle(color: NTokens.primaryText(context)),
  ),
)
```

### Spacing

Use `NSpacing` for consistent 4 dp grid spacing:

```dart
Padding(
  padding: EdgeInsets.all(NSpacing.s4),  // 16 dp
  child: Column(
    children: [
      child1,
      NSpacing.vertical(NSpacing.s2),    // 8 dp gap
      child2,
    ],
  ),
)
```

### Text scale

Adjust the global text scale at startup or in response to user preferences by passing `textScale` to `NTheme`:

```dart
NTheme.lightTheme(
  palette: myPalette,
  textScale: 1.15,  // 115%
)
```

For dynamic runtime changes, use `NTextScale` (deprecated — kept for migration only):

```dart
NTextScale.setScale(NTextScale.large);  // 115% (deprecated)
```

### Custom component themes

Override button or input defaults by passing extra extensions to `NTheme`:

```dart
NTheme.lightTheme(
  palette: myPalette,
  extensions: [
    const NButtonTheme(radius: 4.0),
    const NInputTheme(radius: 4.0),
  ],
)
```

---

## Component catalog

### Buttons

```dart
NButton(label: 'Primary', onPressed: () {})
NButton(label: 'Success', color: NButtonColor.success, onPressed: () {})
NButton(label: 'Outline', variant: NButtonVariant.outline, onPressed: () {})
NButton(label: 'Soft', variant: NButtonVariant.soft, onPressed: () {})
NButton(label: 'Ghost', variant: NButtonVariant.ghost, onPressed: () {})
NButton(label: 'Link', variant: NButtonVariant.link, onPressed: () {})
NButton(label: 'Loading', loading: true, onPressed: () {})
NButton(label: 'Disabled', disabled: true, onPressed: () {})
NButton(label: 'Full width', block: true, onPressed: () {})
NButton.destructive(label: 'Delete account', onPressed: _delete)
```

### Inputs

```dart
NInput(label: 'Email', placeholder: 'you@example.com')
NInput(label: 'Password', obscureText: true, passwordToggle: true)
NInput(label: 'Search', leading: const Icon(LucideIcons.search), clearable: true)
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
NCard(variant: NCardVariant.outline, color: NCardColor.success, child: ...)
NCard(onTap: () {}, child: const Text('Tappable card'))
```

### Avatars

```dart
NAvatar(name: 'John Doe')
NAvatar(imageUrl: 'https://example.com/photo.jpg')
NAvatar(name: 'JD', size: NAvatarSize.lg)

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
NAlert(title: 'Success', description: 'Payment sent.', color: NAlertColor.success)
NAlert(title: 'Warning', description: 'Low balance.', color: NAlertColor.warning, variant: NAlertVariant.soft)
NAlert(title: 'Error', description: 'Transfer failed.', color: NAlertColor.error, variant: NAlertVariant.outline)
```

### Badges and chips

```dart
NBadge(label: 'New')
NBadge(label: 'Active', color: NBadgeColor.success, variant: NBadgeVariant.soft)
NBadge.dot(color: NBadgeColor.error)

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
  actions: [NIconButton(icon: LucideIcons.bell, onPressed: () {})],
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
    NBottomSheetAction(label: 'Edit', icon: LucideIcons.pencil, onTap: _edit),
    NBottomSheetAction(label: 'Delete', icon: LucideIcons.trash2, isDestructive: true, onTap: _delete),
  ],
);
```

### Icon button

```dart
NIconButton(icon: LucideIcons.share2, onPressed: () {})
NIconButton(icon: LucideIcons.trash2, color: NIconButtonColor.error, variant: NIconButtonVariant.soft, onPressed: () {})
```

---

## Design tokens reference

| Token group | Example accessor | Description |
|-------------|-----------------|-------------|
| Base colors | `NTokens.primary(context)` | Primary brand color |
| Backgrounds | `NTokens.bgDefault(context)` | Page background |
| Text | `NTokens.textMuted(context)` | Low-emphasis text |
| Borders | `NTokens.borderDefault(context)` | Default border |
| Semantic bg | `NTokens.primaryBg(context)` | Tinted primary background |
| Semantic border | `NTokens.errorBorder(context)` | Tinted error border |
| Semantic text | `NTokens.successText(context)` | Text on success surfaces |
| Spacing | `NSpacing.s4` | 16 dp |
| Radius | `NTokens.radiusDefault` | 8 dp |

---

## Comparison with Nuxt UI

| Nuxt UI component | nui_flutter equivalent |
|-------------------|----------------------|
| `UButton` | `NButton` |
| `UInput` | `NInput` |
| `UCard` | `NCard` |
| `UAvatar` / `UAvatarGroup` | `NAvatar` / `NAvatarGroup` |
| `UBadge` | `NBadge` |
| `UAlert` | `NAlert` |
| `UChip` | `NChip` / `NChipGroup` |
| `USwitch` | `NToggle` |
| `UDropdownMenu` | `NDropdown` |
| `UTabs` | `NTabBar` |
| `UModal` / `UDrawer` | `NBottomSheet` |
| CSS variables | `NColorPalette` + `NTokens` |
| Tailwind variants | `NButtonVariant`, `NCardVariant`, etc. |

---

## Dependencies

| Package | Role |
|---------|------|
| [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil) | Responsive sizing (`.w`, `.h`, `.sp`) |
| [`lucide_icons_flutter`](https://pub.dev/packages/lucide_icons_flutter) | Icon set (Lucide icon library) |

---

## License

Licensed under the [MIT License](LICENSE).
