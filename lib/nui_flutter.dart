/// NUI Flutter: a Nuxt UI-inspired design system for Flutter.
///
/// Import this single file to access the entire NUI component library:
///
/// ```dart
/// import 'package:nui_flutter/nui_flutter.dart';
/// ```
///
/// ## Getting started
///
/// ### Option A: NApp (recommended, drop-in MaterialApp)
///
/// ```dart
/// NApp(
///   colors: NColors.light(
///     palette: {
///       NColorRole.primary: NRoleColor(Color(0xFFF97316)),
///       NColorRole.secondary: NRoleColor(Color(0xFF6B7280)),
///       NColorRole.success: NRoleColor(Color(0xFF10B981)),
///       NColorRole.error: NRoleColor(Color(0xFFEF4444)),
///     },
///   ),
///   darkColors: NColors.dark(
///     palette: {
///       NColorRole.primary: NRoleColor(Color(0xFFF97316)),
///       NColorRole.secondary: NRoleColor(Color(0xFF6B7280)),
///       NColorRole.success: NRoleColor(Color(0xFF10B981)),
///       NColorRole.error: NRoleColor(Color(0xFFEF4444)),
///     },
///   ),
///   home: const HomeScreen(),
/// )
/// ```
///
/// ### Option B: Manual MaterialApp
///
/// ```dart
/// MaterialApp(
///   theme: NTheme.lightTheme(colors: myLightColors),
///   darkTheme: NTheme.darkTheme(colors: myDarkColors),
/// )
/// ```
///
/// ## Design tokens
///
/// Read tokens anywhere inside a build method:
/// ```dart
/// // Before (verbose):
/// final colors = Theme.of(context).extension<NColors>()!;
/// final color = colors.primary;
///
/// // After (idiomatic):
/// final color = context.nui.colors.primary;
/// final radius = context.nui.radius.md;
/// final shadow = context.nui.shadows.sm;
/// ```
///
/// ## Seed-based theming (NColorScale)
///
/// Generate a full 11-step scale from a single brand color:
/// ```dart
/// final violet = NColorScale.fromSeed(Color(0xFF7C3AED));
/// violet.s50  // lightest tint
/// violet.s500 // seed color
/// violet.s900 // darkest shade
/// ```
///
/// ## Raw primitives (unstyled building blocks)
///
/// Build your own components using NUI primitives:
/// ```dart
/// NRawButton(
///   onPressed: () {},
///   builder: (ctx, states) => MyCustomButton(pressed: states.isPressed),
/// )
/// NPressScale(onTap: () {}, child: MyWidget())
/// ```
library;

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------
export 'src/app/n_app.dart';

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------
export 'src/theme/n_colors.dart';
export 'src/theme/n_variant_resolver.dart';
export 'src/theme/n_spacing.dart';
export 'src/theme/n_text_scale.dart';
export 'src/theme/n_theme.dart';
export 'src/theme/n_icons.dart'; // NIcons
export 'src/theme/n_theme_extension.dart'; // context.nui
export 'src/theme/n_typography.dart';

// ---------------------------------------------------------------------------
// Theme: Components
// ---------------------------------------------------------------------------
export 'src/theme/components/n_button_theme.dart';
export 'src/theme/components/n_input_theme.dart';

// ---------------------------------------------------------------------------
// Tokens
// ---------------------------------------------------------------------------
export 'src/tokens/n_color_roles.dart'; // NColorRole, NNeutralPalette
export 'src/tokens/n_color_scale.dart'; // NColorScale.fromSeed()
export 'src/tokens/n_radius.dart';      // NRadius
export 'src/tokens/n_shadows.dart';     // NShadows

// ---------------------------------------------------------------------------
// Primitives
// ---------------------------------------------------------------------------
export 'src/primitives/n_press_scale.dart'; // NPressScale
export 'src/primitives/n_scroll_fade.dart'; // NScrollFade

// ---------------------------------------------------------------------------
// Raw components (unstyled building blocks)
// ---------------------------------------------------------------------------
export 'src/raw_components/n_raw_button.dart';
export 'src/raw_components/n_raw_input.dart';
export 'src/raw_components/n_raw_badge.dart';
export 'src/raw_components/n_raw_card.dart';
export 'src/raw_components/n_raw_tooltip.dart';
export 'src/raw_components/n_raw_dismissible.dart';

// ---------------------------------------------------------------------------
// Components: Button
// ---------------------------------------------------------------------------
export 'src/components/button/n_button.dart';
export 'src/components/button/n_icon_button.dart';

// ---------------------------------------------------------------------------
// Components: Forms
// ---------------------------------------------------------------------------
export 'src/components/forms/n_input.dart';
export 'src/components/forms/n_checkbox.dart';
export 'src/components/forms/n_radio_group.dart';
export 'src/components/forms/n_textarea.dart';
export 'src/components/forms/n_select_menu.dart';
export 'src/components/forms/n_toggle.dart';

// ---------------------------------------------------------------------------
// Components: Layout
// ---------------------------------------------------------------------------
export 'src/components/layout/n_card.dart';

// ---------------------------------------------------------------------------
// Components: Elements
// ---------------------------------------------------------------------------
export 'src/components/elements/n_alert.dart';
export 'src/components/elements/n_avatar.dart';
export 'src/components/elements/n_badge.dart';
export 'src/components/elements/n_chip.dart';
export 'src/components/elements/n_skeleton.dart';
export 'src/components/elements/n_progress.dart';

// ---------------------------------------------------------------------------
// Components: Data
// ---------------------------------------------------------------------------
export 'src/components/data/n_empty.dart';
export 'src/components/data/n_error.dart';

// ---------------------------------------------------------------------------
// Components: Overlay
// ---------------------------------------------------------------------------
export 'src/components/overlay/n_bottom_sheet.dart';
export 'src/components/overlay/n_dropdown_menu.dart';
export 'src/components/overlay/n_modal.dart';
export 'src/components/overlay/n_toast.dart';

// ---------------------------------------------------------------------------
// Components: Navigation
// ---------------------------------------------------------------------------
export 'src/components/navigation/n_app_bar.dart';
export 'src/components/navigation/n_tab_bar.dart';
