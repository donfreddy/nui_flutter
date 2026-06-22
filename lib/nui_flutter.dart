/// NUI Flutter — a Nuxt UI-inspired design system for Flutter.
///
/// Import this single file to access the entire NUI component library:
///
/// ```dart
/// import 'package:nui_flutter/nui_flutter.dart';
/// ```
///
/// ## Getting started
///
/// 1. Wrap your [MaterialApp] with [NTheme]:
///    ```dart
///    MaterialApp(
///      theme: NTheme.lightTheme(palette: NColorPalette.light(
///        primary: Color(0xFFF97316),
///        secondary: Color(0xFF6B7280),
///        success: Color(0xFF10B981),
///        error: Color(0xFFEF4444),
///      )),
///      darkTheme: NTheme.darkTheme(palette: NColorPalette.dark(
///        primary: Color(0xFFF97316),
///        secondary: Color(0xFF6B7280),
///        success: Color(0xFF10B981),
///        error: Color(0xFFEF4444),
///      )),
///    )
///    ```
///
/// 2. Use design tokens anywhere via [NTokens], [NSpacing], and [NTextScale].
///
/// 3. Drop in pre-built components: [NButton], [NInput], [NCard], [NAlert],
///    [NAvatar], [NBadge], [NChip], [NToggle], [NDropdown], [NIconButton],
///    [NAppBar], [NTabBar], [NBottomSheet], [NModal], [NToast], [NProgress],
///    [NSkeleton], [NCheckbox], [NRadioGroup], and [NTextarea].
library;

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------
export 'src/theme/n_color_palette.dart';
export 'src/theme/n_component_colors.dart';
export 'src/theme/n_spacing.dart';
export 'src/theme/n_text_scale.dart';
export 'src/theme/n_theme.dart';
export 'src/theme/n_typography.dart';

// ---------------------------------------------------------------------------
// Components
// ---------------------------------------------------------------------------

// Button
export 'src/components/button/n_button.dart';
export 'src/components/button/n_button_theme.dart';
export 'src/components/button/n_icon_button.dart';

// Forms
export 'src/components/forms/n_input.dart';
export 'src/components/forms/n_input_theme.dart';
export 'src/components/forms/n_checkbox.dart';
export 'src/components/forms/n_radio_group.dart';
export 'src/components/forms/n_textarea.dart';
export 'src/components/forms/n_select_menu.dart';
export 'src/components/forms/n_toggle.dart';

// Layout
export 'src/components/layout/n_card.dart';

// Elements
export 'src/components/elements/n_alert.dart';
export 'src/components/elements/n_avatar.dart';
export 'src/components/elements/n_badge.dart';
export 'src/components/elements/n_chip.dart';
export 'src/components/elements/n_skeleton.dart';
export 'src/components/elements/n_progress.dart';

// Data
export 'src/components/data/n_empty_state.dart';
export 'src/components/data/n_error.dart';

// Overlay
export 'src/components/overlay/n_bottom_sheet.dart';
export 'src/components/overlay/n_dropdown_menu.dart';
export 'src/components/overlay/n_modal.dart';
export 'src/components/overlay/n_toast.dart';

// Navigation
export 'src/components/navigation/n_app_bar.dart';
export 'src/components/navigation/n_tab_bar.dart';
