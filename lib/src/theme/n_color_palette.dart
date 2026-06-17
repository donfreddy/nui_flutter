import 'package:flutter/material.dart';

/// A comprehensive color palette used as a [ThemeExtension] in [ThemeData].
///
/// [NColorPalette] defines all semantic color tokens for a branded design
/// system. Register it via [NTheme.lightTheme] or [NTheme.darkTheme] and
/// retrieve it at runtime with [NTokens].
///
/// Each app creates its own palette by calling [NColorPalette.light] or
/// [NColorPalette.dark] and overriding only the brand-specific values.
///
/// ```dart
/// final palette = NColorPalette.light(
///   primary: Color(0xFFF97316),
///   secondary: Color(0xFF6B7280),
///   success: Color(0xFF10B981),
///   error: Color(0xFFEF4444),
/// );
/// ```
class NColorPalette extends ThemeExtension<NColorPalette> {
  // ---------------------------------------------------------------------------
  // Semantic base colors
  // ---------------------------------------------------------------------------

  /// The primary brand color used for actions, links, and highlights.
  final Color primary;

  /// A secondary accent color that complements the primary brand color.
  final Color secondary;

  /// A color that communicates a successful or positive state.
  final Color success;

  /// A color that communicates an error or destructive state.
  final Color error;

  /// A color that communicates a warning or cautionary state.
  final Color warning;

  /// A color that communicates an informational state.
  final Color info;

  // ---------------------------------------------------------------------------
  // Backgrounds
  // ---------------------------------------------------------------------------

  /// The default page or scaffold background color.
  final Color bgDefault;

  /// A slightly elevated surface color used for cards and containers.
  final Color bgElevated;

  /// An inverted background, typically dark in light mode and light in dark mode.
  final Color bgInverted;

  /// A muted, low-contrast background used for secondary areas or skeletons.
  final Color bgMuted;

  /// A subtly accented background for hover or selection states.
  final Color bgAccented;

  // ---------------------------------------------------------------------------
  // Text hierarchy
  // ---------------------------------------------------------------------------

  /// The highest-emphasis text color, used for primary headings.
  final Color textHighlighted;

  /// The default body text color.
  final Color textDefault;

  /// A mid-emphasis text color, between default and muted.
  final Color textToned;

  /// A low-emphasis text color for secondary labels and captions.
  final Color textMuted;

  /// A color for disabled or inactive text.
  final Color textDisabled;

  /// Text color rendered on inverted (dark) backgrounds.
  final Color textInverted;

  // ---------------------------------------------------------------------------
  // Borders
  // ---------------------------------------------------------------------------

  /// The default border color for inputs, cards, and dividers.
  final Color borderDefault;

  /// A softer border color for subtle separators.
  final Color borderMuted;

  /// The border color used on hover or focus states.
  final Color borderHover;

  // ---------------------------------------------------------------------------
  // Semantic tinted backgrounds
  // ---------------------------------------------------------------------------

  /// A lightly tinted background for primary-colored surfaces.
  final Color primaryBg;

  /// A lightly tinted background for secondary-colored surfaces.
  final Color secondaryBg;

  /// A lightly tinted background for success-colored surfaces.
  final Color successBg;

  /// A lightly tinted background for error-colored surfaces.
  final Color errorBg;

  /// A lightly tinted background for warning-colored surfaces.
  final Color warningBg;

  /// A lightly tinted background for info-colored surfaces.
  final Color infoBg;

  // ---------------------------------------------------------------------------
  // Semantic tinted borders
  // ---------------------------------------------------------------------------

  /// A tinted border color for primary-colored surfaces.
  final Color primaryBorder;

  /// A tinted border color for secondary-colored surfaces.
  final Color secondaryBorder;

  /// A tinted border color for success-colored surfaces.
  final Color successBorder;

  /// A tinted border color for error-colored surfaces.
  final Color errorBorder;

  /// A tinted border color for warning-colored surfaces.
  final Color warningBorder;

  /// A tinted border color for info-colored surfaces.
  final Color infoBorder;

  // ---------------------------------------------------------------------------
  // Semantic tinted text
  // ---------------------------------------------------------------------------

  /// Text color for content rendered on a primary-tinted background.
  final Color primaryText;

  /// Text color for content rendered on a secondary-tinted background.
  final Color secondaryText;

  /// Text color for content rendered on a success-tinted background.
  final Color successText;

  /// Text color for content rendered on an error-tinted background.
  final Color errorText;

  /// Text color for content rendered on a warning-tinted background.
  final Color warningText;

  /// Text color for content rendered on an info-tinted background.
  final Color infoText;

  /// Creates a fully specified [NColorPalette].
  ///
  /// Prefer the [NColorPalette.light] or [NColorPalette.dark] factories which
  /// provide sensible defaults for optional tokens, requiring only brand colors.
  const NColorPalette({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.bgDefault,
    required this.bgElevated,
    required this.bgInverted,
    required this.bgMuted,
    required this.bgAccented,
    required this.textHighlighted,
    required this.textDefault,
    required this.textToned,
    required this.textMuted,
    required this.textDisabled,
    required this.textInverted,
    required this.borderDefault,
    required this.borderMuted,
    required this.borderHover,
    required this.primaryBg,
    required this.secondaryBg,
    required this.successBg,
    required this.errorBg,
    required this.warningBg,
    required this.infoBg,
    required this.primaryBorder,
    required this.secondaryBorder,
    required this.successBorder,
    required this.errorBorder,
    required this.warningBorder,
    required this.infoBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.successText,
    required this.errorText,
    required this.warningText,
    required this.infoText,
  });

  /// Creates a light-mode palette.
  ///
  /// Only [primary], [secondary], [success], and [error] are required.
  /// All other tokens have sensible defaults based on a neutral zinc scale.
  ///
  /// Override any token to match the app's brand guidelines.
  factory NColorPalette.light({
    required Color primary,
    required Color secondary,
    required Color success,
    required Color error,
    Color warning = const Color(0xFFF59E0B),
    Color info = const Color(0xFF3B82F6),
    Color bgDefault = Colors.white,
    Color bgElevated = Colors.white,
    Color bgInverted = const Color(0xFF18181B),
    Color bgMuted = const Color(0xFFFAFAFA),
    Color bgAccented = const Color(0xFFE4E4E7),
    Color textHighlighted = const Color(0xFF18181B),
    Color textDefault = const Color(0xFF3F3F46),
    Color textToned = const Color(0xFF52525B),
    Color textMuted = const Color(0xFF71717A),
    Color textDisabled = const Color(0xFFA1A1AA),
    Color textInverted = Colors.white,
    Color borderDefault = const Color(0xFFE4E4E7),
    Color borderMuted = const Color(0xFFF4F4F5),
    Color borderHover = const Color(0xFFD4D4D8),
    Color primaryBg = const Color(0xFFFFF7ED),
    Color secondaryBg = const Color(0xFFF4F4F5),
    Color successBg = const Color(0xFFECFDF5),
    Color errorBg = const Color(0xFFFEF2F2),
    Color warningBg = const Color(0xFFFFFBEB),
    Color infoBg = const Color(0xFFEFF6FF),
    Color primaryBorder = const Color(0xFFFED7AA),
    Color secondaryBorder = const Color(0xFFE4E4E7),
    Color successBorder = const Color(0xFFD1FAE5),
    Color errorBorder = const Color(0xFFFEE2E2),
    Color warningBorder = const Color(0xFFFEF3C7),
    Color infoBorder = const Color(0xFFDBEAFE),
    Color primaryText = const Color(0xFFC2410C),
    Color secondaryText = const Color(0xFF18181B),
    Color successText = const Color(0xFF047857),
    Color errorText = const Color(0xFFB91C1C),
    Color warningText = const Color(0xFFB45309),
    Color infoText = const Color(0xFF1D4ED8),
  }) {
    return NColorPalette(
      primary: primary,
      secondary: secondary,
      success: success,
      error: error,
      warning: warning,
      info: info,
      bgDefault: bgDefault,
      bgElevated: bgElevated,
      bgInverted: bgInverted,
      bgMuted: bgMuted,
      bgAccented: bgAccented,
      textHighlighted: textHighlighted,
      textDefault: textDefault,
      textToned: textToned,
      textMuted: textMuted,
      textDisabled: textDisabled,
      textInverted: textInverted,
      borderDefault: borderDefault,
      borderMuted: borderMuted,
      borderHover: borderHover,
      primaryBg: primaryBg,
      secondaryBg: secondaryBg,
      successBg: successBg,
      errorBg: errorBg,
      warningBg: warningBg,
      infoBg: infoBg,
      primaryBorder: primaryBorder,
      secondaryBorder: secondaryBorder,
      successBorder: successBorder,
      errorBorder: errorBorder,
      warningBorder: warningBorder,
      infoBorder: infoBorder,
      primaryText: primaryText,
      secondaryText: secondaryText,
      successText: successText,
      errorText: errorText,
      warningText: warningText,
      infoText: infoText,
    );
  }

  /// Creates a dark-mode palette.
  ///
  /// Only [primary], [secondary], [success], and [error] are required.
  /// All other tokens have sensible dark-mode defaults based on a neutral zinc scale.
  ///
  /// Override any token to match the app's brand guidelines.
  factory NColorPalette.dark({
    required Color primary,
    required Color secondary,
    required Color success,
    required Color error,
    Color warning = const Color(0xFFFBBF24),
    Color info = const Color(0xFF60A5FA),
    Color bgDefault = const Color(0xFF09090B),
    Color bgElevated = const Color(0xFF18181B),
    Color bgInverted = Colors.white,
    Color bgMuted = const Color(0xFF18181B),
    Color bgAccented = const Color(0xFF3F3F46),
    Color textHighlighted = Colors.white,
    Color textDefault = const Color(0xFFFAFAFA),
    Color textToned = const Color(0xFFD4D4D8),
    Color textMuted = const Color(0xFFA1A1AA),
    Color textDisabled = const Color(0xFF52525B),
    Color textInverted = const Color(0xFF18181B),
    Color borderDefault = const Color(0xFF27272A),
    Color borderMuted = const Color(0xFF18181B),
    Color borderHover = const Color(0xFF3F3F46),
    Color primaryBg = const Color(0xFF7C2D12),
    Color secondaryBg = const Color(0xFF18181B),
    Color successBg = const Color(0xFF064E3B),
    Color errorBg = const Color(0xFF7F1D1D),
    Color warningBg = const Color(0xFF78350F),
    Color infoBg = const Color(0xFF1E3A8A),
    Color primaryBorder = const Color(0xFF9A3412),
    Color secondaryBorder = const Color(0xFF3F3F46),
    Color successBorder = const Color(0xFF065F46),
    Color errorBorder = const Color(0xFF991B1B),
    Color warningBorder = const Color(0xFF92400E),
    Color infoBorder = const Color(0xFF1E40AF),
    Color primaryText = const Color(0xFFFED7AA),
    Color secondaryText = const Color(0xFFD4D4D8),
    Color successText = const Color(0xFFA7F3D0),
    Color errorText = const Color(0xFFFECACA),
    Color warningText = const Color(0xFFFDE68A),
    Color infoText = const Color(0xFFBFDBFE),
  }) {
    return NColorPalette(
      primary: primary,
      secondary: secondary,
      success: success,
      error: error,
      warning: warning,
      info: info,
      bgDefault: bgDefault,
      bgElevated: bgElevated,
      bgInverted: bgInverted,
      bgMuted: bgMuted,
      bgAccented: bgAccented,
      textHighlighted: textHighlighted,
      textDefault: textDefault,
      textToned: textToned,
      textMuted: textMuted,
      textDisabled: textDisabled,
      textInverted: textInverted,
      borderDefault: borderDefault,
      borderMuted: borderMuted,
      borderHover: borderHover,
      primaryBg: primaryBg,
      secondaryBg: secondaryBg,
      successBg: successBg,
      errorBg: errorBg,
      warningBg: warningBg,
      infoBg: infoBg,
      primaryBorder: primaryBorder,
      secondaryBorder: secondaryBorder,
      successBorder: successBorder,
      errorBorder: errorBorder,
      warningBorder: warningBorder,
      infoBorder: infoBorder,
      primaryText: primaryText,
      secondaryText: secondaryText,
      successText: successText,
      errorText: errorText,
      warningText: warningText,
      infoText: infoText,
    );
  }

  /// A fixed set of visually distinct colors used for avatar initials backgrounds.
  static const List<Color> avatarColors = [
    Color(0xFF8B5CF6), // violet
    Color(0xFF3B82F6), // blue
    Color(0xFF06B6D4), // cyan
    Color(0xFF14B8A6), // teal
    Color(0xFF10B981), // emerald
    Color(0xFFF59E0B), // amber
    Color(0xFFF97316), // orange
    Color(0xFFF43F5E), // rose
    Color(0xFFEC4899), // pink
    Color(0xFF6366F1), // indigo
  ];

  /// Returns a deterministic color from [avatarColors] for the given [name].
  ///
  /// The color is derived from the character code sum of [name], ensuring the
  /// same name always produces the same color across builds.
  static Color avatarColorFor(String name) {
    if (name.isEmpty) return avatarColors[0];
    final hash = name.codeUnits.fold(0, (sum, c) => sum + c);
    return avatarColors[hash % avatarColors.length];
  }

  /// Returns a copy of this palette with the given fields replaced.
  ///
  /// Any field not provided will retain its current value.
  @override
  NColorPalette copyWith({
    Color? primary,
    Color? secondary,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? bgDefault,
    Color? bgElevated,
    Color? bgInverted,
    Color? bgMuted,
    Color? bgAccented,
    Color? textHighlighted,
    Color? textDefault,
    Color? textToned,
    Color? textMuted,
    Color? textDisabled,
    Color? textInverted,
    Color? borderDefault,
    Color? borderMuted,
    Color? borderHover,
    Color? primaryBg,
    Color? secondaryBg,
    Color? successBg,
    Color? errorBg,
    Color? warningBg,
    Color? infoBg,
    Color? primaryBorder,
    Color? secondaryBorder,
    Color? successBorder,
    Color? errorBorder,
    Color? warningBorder,
    Color? infoBorder,
    Color? primaryText,
    Color? secondaryText,
    Color? successText,
    Color? errorText,
    Color? warningText,
    Color? infoText,
  }) {
    return NColorPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      bgDefault: bgDefault ?? this.bgDefault,
      bgElevated: bgElevated ?? this.bgElevated,
      bgInverted: bgInverted ?? this.bgInverted,
      bgMuted: bgMuted ?? this.bgMuted,
      bgAccented: bgAccented ?? this.bgAccented,
      textHighlighted: textHighlighted ?? this.textHighlighted,
      textDefault: textDefault ?? this.textDefault,
      textToned: textToned ?? this.textToned,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      textInverted: textInverted ?? this.textInverted,
      borderDefault: borderDefault ?? this.borderDefault,
      borderMuted: borderMuted ?? this.borderMuted,
      borderHover: borderHover ?? this.borderHover,
      primaryBg: primaryBg ?? this.primaryBg,
      secondaryBg: secondaryBg ?? this.secondaryBg,
      successBg: successBg ?? this.successBg,
      errorBg: errorBg ?? this.errorBg,
      warningBg: warningBg ?? this.warningBg,
      infoBg: infoBg ?? this.infoBg,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      secondaryBorder: secondaryBorder ?? this.secondaryBorder,
      successBorder: successBorder ?? this.successBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      warningBorder: warningBorder ?? this.warningBorder,
      infoBorder: infoBorder ?? this.infoBorder,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      successText: successText ?? this.successText,
      errorText: errorText ?? this.errorText,
      warningText: warningText ?? this.warningText,
      infoText: infoText ?? this.infoText,
    );
  }

  /// Linearly interpolates between this palette and [other] by factor [t].
  ///
  /// Used internally by Flutter's theme animation system when switching between
  /// light and dark themes or when [ThemeData.lerp] is called.
  @override
  NColorPalette lerp(ThemeExtension<NColorPalette>? other, double t) {
    if (other is! NColorPalette) return this;
    return NColorPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      bgDefault: Color.lerp(bgDefault, other.bgDefault, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgInverted: Color.lerp(bgInverted, other.bgInverted, t)!,
      bgMuted: Color.lerp(bgMuted, other.bgMuted, t)!,
      bgAccented: Color.lerp(bgAccented, other.bgAccented, t)!,
      textHighlighted: Color.lerp(textHighlighted, other.textHighlighted, t)!,
      textDefault: Color.lerp(textDefault, other.textDefault, t)!,
      textToned: Color.lerp(textToned, other.textToned, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textInverted: Color.lerp(textInverted, other.textInverted, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderMuted: Color.lerp(borderMuted, other.borderMuted, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      primaryBg: Color.lerp(primaryBg, other.primaryBg, t)!,
      secondaryBg: Color.lerp(secondaryBg, other.secondaryBg, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      primaryBorder: Color.lerp(primaryBorder, other.primaryBorder, t)!,
      secondaryBorder: Color.lerp(secondaryBorder, other.secondaryBorder, t)!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      infoBorder: Color.lerp(infoBorder, other.infoBorder, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      infoText: Color.lerp(infoText, other.infoText, t)!,
    );
  }
}
