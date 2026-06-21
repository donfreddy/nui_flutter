import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nui_flutter/nui_flutter.dart';

void main() {
  runApp(const NuiFlutterExampleApp());
}

class NuiFlutterExampleApp extends StatefulWidget {
  const NuiFlutterExampleApp({super.key});

  @override
  State<NuiFlutterExampleApp> createState() => _NuiFlutterExampleAppState();
}

class _NuiFlutterExampleAppState extends State<NuiFlutterExampleApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final palette = _dark
        ? NColorPalette.dark(
            primary: const Color(0xFFF97316),
            secondary: const Color(0xFF6B7280),
            success: const Color(0xFF10B981),
            error: const Color(0xFFEF4444),
          )
        : NColorPalette.light(
            primary: const Color(0xFFF97316),
            secondary: const Color(0xFF6B7280),
            success: const Color(0xFF10B981),
            error: const Color(0xFFEF4444),
          );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: NTheme.lightTheme(palette: palette),
      darkTheme: NTheme.darkTheme(palette: palette),
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: _HomePage(onToggleTheme: () => setState(() => _dark = !_dark)),
    );
  }
}

class _HomePage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const _HomePage({required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _Header(onToggleTheme: onToggleTheme),
            SizedBox(height: 24),
            _SectionTitle('Buttons'),
            _ButtonsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Inputs'),
            _InputsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Cards'),
            _CardsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Alerts'),
            _AlertsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Toasts'),
            _ToastsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Badges'),
            _BadgesDemo(),
            SizedBox(height: 24),
            _SectionTitle('Chips'),
            _ChipsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Toggles'),
            _TogglesDemo(),
            SizedBox(height: 24),
            _SectionTitle('Dropdowns'),
            _DropdownsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Avatars'),
            _AvatarsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Icon Buttons'),
            _IconButtonsDemo(),
            SizedBox(height: 24),
            _SectionTitle('Empty State'),
            _EmptyStateDemo(),
            SizedBox(height: 24),
            _SectionTitle('Bottom Sheet'),
            _BottomSheetDemo(),
            SizedBox(height: 24),
            _SectionTitle('Tab Bar'),
            _TabBarDemo(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const _Header({required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'nui_flutter',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            NIconButton(
              icon: _isDark(context) ? LucideIcons.sun : LucideIcons.moon,
              onPressed: onToggleTheme,
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'A Nuxt UI-inspired design system for Flutter',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}

// ---------------------------------------------------------------------------
// Section title
// ---------------------------------------------------------------------------
class _SectionTitle extends StatelessWidget {
  final String label;

  const _SectionTitle(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------
class _ButtonsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _variantLabel('solid'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NButton(label: 'Primary'),
          NButton(label: 'Secondary', color: NButtonColor.secondary),
          NButton(label: 'Success', color: NButtonColor.success),
          NButton(label: 'Warning', color: NButtonColor.warning),
          NButton(label: 'Error', color: NButtonColor.error),
          NButton(label: 'Info', color: NButtonColor.info),
          NButton(label: 'Neutral', color: NButtonColor.neutral),
        ]),
        SizedBox(height: 12),
        _variantLabel('outline / ghost / destructive'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NButton.outline(label: 'Outline', onPressed: () {}),
          NButton.ghost(label: 'Ghost', onPressed: () {}),
          NButton.destructive(label: 'Delete', onPressed: () {}),
        ]),
        SizedBox(height: 12),
        _variantLabel('loading / disabled / with icons'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NButton(
            label: 'Loading',
            loading: true,
            leading: Icon(LucideIcons.loader),
          ),
          NButton(label: 'Disabled', disabled: true),
          NButton(
            label: 'With Icon',
            leading: Icon(LucideIcons.cloudUpload),
          ),
          NButton(
            label: 'Full width',
            block: true,
          ),
        ]),
        SizedBox(height: 12),
        _variantLabel('sizes (xs · sm · md · lg · xl)'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NButton(label: 'Xs', size: NButtonSize.xs),
          NButton(label: 'Sm', size: NButtonSize.sm),
          NButton(label: 'Md', size: NButtonSize.md),
          NButton(label: 'Lg', size: NButtonSize.lg),
          NButton(label: 'Xl', size: NButtonSize.xl),
        ]),
      ],
    );
  }

  Widget _variantLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Inputs
// ---------------------------------------------------------------------------
class _InputsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NInput(label: 'Email', placeholder: 'you@example.com'),
        SizedBox(height: 12),
        NInput(label: 'Password', obscureText: true, passwordToggle: true),
        SizedBox(height: 12),
        NInput.amount(label: 'Amount', trailingText: 'FCFA'),
        SizedBox(height: 12),
        NInput.phone(label: 'Phone'),
        SizedBox(height: 12),
        NInput.otp(),
        SizedBox(height: 12),
        NInput(
          label: 'With error',
          errorText: 'This field is required',
        ),
        SizedBox(height: 12),
        NInput(
          label: 'Disabled',
          initialValue: 'Read only',
          disabled: true,
        ),
        SizedBox(height: 12),
        NInput(
          label: 'Loading',
          loading: true,
        ),
        SizedBox(height: 12),
        _variantLabelForInput(
            'variants (outline · soft · subtle · ghost · none)'),
        NInput(label: 'Outline', variant: NInputVariant.outline),
        SizedBox(height: 8),
        NInput(label: 'Soft', variant: NInputVariant.soft),
        SizedBox(height: 8),
        NInput(label: 'Subtle', variant: NInputVariant.subtle),
        SizedBox(height: 8),
        NInput(label: 'Ghost', variant: NInputVariant.ghost),
        SizedBox(height: 8),
        NInput(label: 'None', variant: NInputVariant.none),
      ],
    );
  }

  Widget _variantLabelForInput(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Cards
// ---------------------------------------------------------------------------
class _CardsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NCard(
          header:
              NCardHeader(title: 'Default Card', subtitle: 'Outline variant'),
          child: Text('This is the default card with header and body.'),
        ),
        SizedBox(height: 12),
        NCard.soft(
          color: NCardColor.primary,
          child: Text('Soft card with primary color'),
        ),
        SizedBox(height: 12),
        NCard.subtle(
          color: NCardColor.success,
          header: NCardHeader(
              title: 'Success',
              leading: Icon(Icons.check_circle, color: Colors.green)),
          child: Text('Everything looks good!'),
        ),
        SizedBox(height: 12),
        NCard.ghost(
          child: Text('Ghost card — no background, no border'),
        ),
        SizedBox(height: 12),
        NCard.naked(
          child: Text('Naked card — no padding, no background'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Alerts
// ---------------------------------------------------------------------------
class _AlertsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NAlert(title: 'Info', description: 'This is an informational message.'),
        SizedBox(height: 8),
        NAlert(
            title: 'Success',
            description: 'Operation completed successfully.',
            color: NAlertColor.success),
        SizedBox(height: 8),
        NAlert(
            title: 'Warning',
            description: 'Please check your input.',
            color: NAlertColor.warning),
        SizedBox(height: 8),
        NAlert(
            title: 'Error',
            description: 'Something went wrong.',
            color: NAlertColor.error,
            closable: true),
        SizedBox(height: 8),
        _variantLabelForAlert('variants'),
        NAlert(
            title: 'Outline',
            color: NAlertColor.primary,
            variant: NAlertVariant.outline),
        SizedBox(height: 8),
        NAlert(
            title: 'Soft',
            color: NAlertColor.secondary,
            variant: NAlertVariant.soft),
        SizedBox(height: 8),
        NAlert(
            title: 'Subtle',
            color: NAlertColor.info,
            variant: NAlertVariant.subtle),
      ],
    );
  }

  Widget _variantLabelForAlert(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Toasts
// ---------------------------------------------------------------------------
class _ToastsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        NButton(
          label: 'Success',
          color: NButtonColor.success,
          onPressed: () {
            NToast.show(
              context,
              title: 'Payment sent',
              description: 'Your transfer was successful.',
              color: NToastColor.success,
            );
          },
        ),
        NButton(
          label: 'Warning',
          color: NButtonColor.warning,
          onPressed: () {
            NToast.show(
              context,
              title: 'Check details',
              description: 'Some information may need your attention.',
              color: NToastColor.warning,
            );
          },
        ),
        NButton(
          label: 'Error',
          color: NButtonColor.error,
          onPressed: () {
            NToast.show(
              context,
              title: 'Transfer failed',
              description: 'Please try again in a moment.',
              color: NToastColor.error,
            );
          },
        ),
        NButton(
          label: 'Info',
          color: NButtonColor.info,
          onPressed: () {
            NToast.show(
              context,
              title: 'New update',
              description: 'Your dashboard has refreshed.',
              color: NToastColor.info,
              icon: LucideIcons.bell,
            );
          },
        ),
        NButton.outline(
          label: 'Persistent',
          onPressed: () {
            NToast.show(
              context,
              title: 'Saved draft',
              description: 'This toast stays until you close it.',
              color: NToastColor.neutral,
              duration: Duration.zero,
            );
          },
        ),
        NButton.outline(
          label: 'Top Position & Avatar',
          onPressed: () {
            NToast.show(
              context,
              title: 'New message',
              description: 'You have received a new message from Jane.',
              position: NToastPosition.top,
              avatar: const NAvatar(name: 'JA', size: NAvatarSize.sm),
            );
          },
        ),
        NButton.outline(
          label: 'With Actions',
          onPressed: () {
            NToast.show(
              context,
              title: 'Update available',
              description: 'A new software version is ready to install.',
              icon: LucideIcons.downloadCloud,
              color: NToastColor.primary,
              orientation: NToastOrientation.vertical,
              actions: [
                NButton(
                  label: 'Install',
                  size: NButtonSize.sm,
                  onPressed: () {},
                ),
                NButton.ghost(
                  label: 'Later',
                  size: NButtonSize.sm,
                  color: NButtonColor.neutral,
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Badges
// ---------------------------------------------------------------------------
class _BadgesDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _variantLabelForBadge('solid · soft · outline · subtle'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NBadge(label: 'Solid', variant: NBadgeVariant.solid),
          NBadge(label: 'Soft', variant: NBadgeVariant.soft),
          NBadge(label: 'Outline', variant: NBadgeVariant.outline),
          NBadge(label: 'Subtle', variant: NBadgeVariant.subtle),
        ]),
        SizedBox(height: 12),
        _variantLabelForBadge('colors'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NBadge(label: 'Primary', color: NBadgeColor.primary),
          NBadge(label: 'Secondary', color: NBadgeColor.secondary),
          NBadge(label: 'Success', color: NBadgeColor.success),
          NBadge(label: 'Warning', color: NBadgeColor.warning),
          NBadge(label: 'Error', color: NBadgeColor.error),
          NBadge(label: 'Info', color: NBadgeColor.info),
          NBadge(label: 'Neutral', color: NBadgeColor.neutral),
        ]),
        SizedBox(height: 12),
        _variantLabelForBadge('emoji · dot · removable'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NBadge.emoji(emoji: '🔥', label: 'Hot'),
          NBadge.dot(label: 'Online'),
          NBadge(label: 'Close', onRemove: () {}),
        ]),
      ],
    );
  }

  Widget _variantLabelForBadge(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Chips
// ---------------------------------------------------------------------------
class _ChipsDemo extends StatefulWidget {
  @override
  State<_ChipsDemo> createState() => _ChipsDemoState();
}

class _ChipsDemoState extends State<_ChipsDemo> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: [
      NChip(label: 'Chip', onTap: () {}),
      NChip(
          label: 'Selected',
          selected: _selected,
          onTap: () {
            setState(() => _selected = !_selected);
          }),
      NChip(label: 'Leading', leading: Icon(LucideIcons.filter, size: 14)),
      NChip(label: 'Soft', variant: NChipVariant.soft),
      NChip(label: 'Outline', variant: NChipVariant.outline),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Toggles
// ---------------------------------------------------------------------------
class _TogglesDemo extends StatefulWidget {
  @override
  State<_TogglesDemo> createState() => _TogglesDemoState();
}

class _TogglesDemoState extends State<_TogglesDemo> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NToggle(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
            label: 'Enable notifications'),
        SizedBox(height: 8),
        NToggle(value: true, disabled: true, label: 'Disabled'),
        SizedBox(height: 8),
        NToggle(value: true, loading: true, label: 'Loading'),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dropdowns
// ---------------------------------------------------------------------------
class _DropdownsDemo extends StatefulWidget {
  @override
  State<_DropdownsDemo> createState() => _DropdownsDemoState();
}

class _DropdownsDemoState extends State<_DropdownsDemo> {
  String? _value;
  List<String> _multi = [];

  @override
  Widget build(BuildContext context) {
    final List<NDropdownItem<String>> items = [
      const NDropdownItem(
          value: 'cm', label: 'Cameroon', icon: LucideIcons.mapPin),
      const NDropdownItem(
          value: 'ng', label: 'Nigeria', icon: LucideIcons.mapPin),
      const NDropdownItem(
          value: 'fr', label: 'France', icon: LucideIcons.mapPin),
      NDropdownItem<String>.separator(),
      const NDropdownItem(value: 'other', label: 'Other'),
    ];

    return Column(
      children: [
        NDropdown<String>(
          label: 'Country',
          items: items,
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
        SizedBox(height: 12),
        NDropdown<String>(
          label: 'Multi-select',
          items: [
            NDropdownItem(value: 'a', label: 'Option A'),
            NDropdownItem(value: 'b', label: 'Option B'),
            NDropdownItem(value: 'c', label: 'Option C'),
          ],
          values: _multi,
          onChangedMultiple: (v) => setState(() => _multi = v),
          multiple: true,
        ),
        SizedBox(height: 12),
        NDropdown<String>(
          label: 'Searchable',
          items: items,
          value: _value,
          onChanged: (v) => setState(() => _value = v),
          searchable: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Avatars
// ---------------------------------------------------------------------------
class _AvatarsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _variantLabelForAvatar('initials · icon · sizes'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NAvatar(name: 'JD', size: NAvatarSize.xs),
          NAvatar(name: 'JD', size: NAvatarSize.sm),
          NAvatar(name: 'JD', size: NAvatarSize.md),
          NAvatar(name: 'JD', size: NAvatarSize.lg),
          NAvatar(name: 'JD', size: NAvatarSize.xl),
          NAvatar(name: 'JD', size: NAvatarSize.xxl),
        ]),
        SizedBox(height: 12),
        _variantLabelForAvatar('colors · chip · ring'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NAvatar(name: 'AB', color: NAvatarColor.primary),
          NAvatar(name: 'CD', color: NAvatarColor.random),
          NAvatar(name: 'EF', color: NAvatarColor.success),
          NAvatar(name: 'GH', chip: true, chipText: 'VIP'),
          NAvatar(icon: LucideIcons.user, hasRing: true),
        ]),
      ],
    );
  }

  Widget _variantLabelForAvatar(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon Buttons
// ---------------------------------------------------------------------------
class _IconButtonsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _variantLabelForIconBtn('variants'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NIconButton(icon: LucideIcons.bell, onPressed: () {}),
          NIconButton(
              icon: LucideIcons.bell,
              variant: NIconButtonVariant.solid,
              onPressed: () {}),
          NIconButton(
              icon: LucideIcons.bell,
              variant: NIconButtonVariant.outline,
              onPressed: () {}),
          NIconButton(
              icon: LucideIcons.bell,
              variant: NIconButtonVariant.ghost,
              onPressed: () {}),
        ]),
        SizedBox(height: 12),
        _variantLabelForIconBtn('colors'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NIconButton(
              icon: LucideIcons.heart,
              color: NIconButtonColor.primary,
              onPressed: () {}),
          NIconButton(
              icon: LucideIcons.heart,
              color: NIconButtonColor.success,
              onPressed: () {}),
          NIconButton(
              icon: LucideIcons.heart,
              color: NIconButtonColor.warning,
              onPressed: () {}),
          NIconButton(
              icon: LucideIcons.heart,
              color: NIconButtonColor.error,
              onPressed: () {}),
        ]),
        SizedBox(height: 12),
        _variantLabelForIconBtn('sizes'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          NIconButton.sm(icon: LucideIcons.settings, onPressed: () {}),
          NIconButton(
              icon: LucideIcons.settings,
              size: NIconButtonSize.md,
              onPressed: () {}),
          NIconButton.lg(icon: LucideIcons.settings, onPressed: () {}),
        ]),
      ],
    );
  }

  Widget _variantLabelForIconBtn(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty State
// ---------------------------------------------------------------------------
class _EmptyStateDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NEmptyState(
      icon: LucideIcons.inbox,
      title: 'No messages',
      description: 'You are all caught up. New messages will appear here.',
      action: NButton(label: 'Refresh', onPressed: () {}),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom Sheet
// ---------------------------------------------------------------------------
class _BottomSheetDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: NButton(
        label: 'Open Bottom Sheet',
        onPressed: () {
          NBottomSheet.show(
            context: context,
            title: 'Choose an action',
            child: Column(
              children: [
                ListTile(
                    leading: Icon(LucideIcons.camera),
                    title: Text('Camera'),
                    onTap: () => Navigator.pop(context)),
                ListTile(
                    leading: Icon(LucideIcons.image),
                    title: Text('Gallery'),
                    onTap: () => Navigator.pop(context)),
                ListTile(
                    leading: Icon(LucideIcons.file),
                    title: Text('Document'),
                    onTap: () => Navigator.pop(context)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab Bar
// ---------------------------------------------------------------------------
class _TabBarDemo extends StatefulWidget {
  @override
  State<_TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<_TabBarDemo> {
  int _underline = 0;
  int _pill = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      NTab(label: 'All', icon: LucideIcons.list),
      NTab(label: 'Active', count: 3),
      NTab(label: 'Completed', icon: LucideIcons.check),
    ];

    return Column(
      children: [
        NTabBar(
          tabs: tabs,
          selectedIndex: _underline,
          onChanged: (i) => setState(() => _underline = i),
          variant: NTabBarVariant.underline,
        ),
        SizedBox(height: 12),
        NTabBar(
          tabs: tabs,
          selectedIndex: _pill,
          onChanged: (i) => setState(() => _pill = i),
          variant: NTabBarVariant.pill,
        ),
      ],
    );
  }
}
