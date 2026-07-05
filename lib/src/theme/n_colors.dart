import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';


/// Resolved semantic colors for one brightness and neutral palette.
///
/// Widgets consume these colors; they never touch raw palette shades directly.
@immutable
class NColors extends ThemeExtension<NColors> {
  /// Creates a fully resolved color set.
  /// Prefer using [NColors.light] or [NColors.dark].
  const NColors({
    required this.brightness,
    required this.neutral,
    required this.roleScales,
    required this.primary,
    required this.secondary,
    required this.success,
    required this.info,
    required this.warning,
    required this.error,
    required this.textDimmed,
    required this.textMuted,
    required this.textToned,
    required this.text,
    required this.textHighlighted,
    required this.textInverted,
    required this.bg,
    required this.bgMuted,
    required this.bgElevated,
    required this.bgAccented,
    required this.bgInverted,
    required this.border,
    required this.borderMuted,
    required this.borderAccented,
    required this.borderInverted,
  });

  /// Light or dark mode.
  final Brightness brightness;

  /// The active neutral palette.
  final NNeutralPalette neutral;

  /// The resolved palette scale for each non-neutral role.
  final Map<NColorRole, NColorScale> roleScales;

  /// Brand / primary color.
  final Color primary;

  /// Secondary color.
  final Color secondary;

  /// Success color.
  final Color success;

  /// Info color.
  final Color info;

  /// Warning color.
  final Color warning;

  /// Error color.
  final Color error;

  /// Dimmed text color.
  final Color textDimmed;

  /// Muted text color.
  final Color textMuted;

  /// Toned text color.
  final Color textToned;

  /// Default body text color.
  final Color text;

  /// Highlighted / heading text color.
  final Color textHighlighted;

  /// Text color on inverted surfaces.
  final Color textInverted;

  /// Base background color.
  final Color bg;

  /// Muted background color.
  final Color bgMuted;

  /// Elevated background color.
  final Color bgElevated;

  /// Accented background color.
  final Color bgAccented;

  /// Inverted background color.
  final Color bgInverted;

  /// Default border color.
  final Color border;

  /// Muted border color.
  final Color borderMuted;

  /// Accented border color.
  final Color borderAccented;

  /// Inverted border color.
  final Color borderInverted;

  /// Returns the resolved mid-shade color for a [role].
  Color role(NColorRole role) => switch (role) {
        NColorRole.primary => primary,
        NColorRole.secondary => secondary,
        NColorRole.success => success,
        NColorRole.info => info,
        NColorRole.warning => warning,
        NColorRole.error => error,
        NColorRole.neutral => textHighlighted,
      };

  /// Returns the full scale for a role.
  NColorScale scaleFor(NColorRole r) =>
      r == NColorRole.neutral ? neutral.scale : roleScales[r]!;

  /// Light mode resolution.
  ///
  /// Configure brand and status roles via [roles] or [palette].
  factory NColors.light({
    NNeutralPalette neutral = NNeutralPalette.slate,
    Map<NColorRole, NColorScale>? roles,
    Map<NColorRole, NRoleColor>? palette,
  }) {
    final n = neutral.scale;
    final scales = _resolveRoleScales(roles, palette);
    return NColors(
      brightness: Brightness.light,
      neutral: neutral,
      roleScales: scales,
      primary: scales[NColorRole.primary]!.s500,
      secondary: scales[NColorRole.secondary]!.s500,
      success: scales[NColorRole.success]!.s500,
      info: scales[NColorRole.info]!.s500,
      warning: scales[NColorRole.warning]!.s500,
      error: scales[NColorRole.error]!.s500,
      textDimmed: n.s400,
      textMuted: n.s500,
      textToned: n.s600,
      text: n.s700,
      textHighlighted: n.s900,
      textInverted: const Color(0xFFFFFFFF),
      bg: const Color(0xFFFFFFFF),
      bgMuted: n.s50,
      bgElevated: n.s100,
      bgAccented: n.s200,
      bgInverted: n.s900,
      border: n.s200,
      borderMuted: n.s200,
      borderAccented: n.s300,
      borderInverted: n.s900,
    );
  }

  /// Dark mode resolution.
  ///
  /// Brand colors lighten one step to 400 for better contrast.
  factory NColors.dark({
    NNeutralPalette neutral = NNeutralPalette.slate,
    Map<NColorRole, NColorScale>? roles,
    Map<NColorRole, NRoleColor>? palette,
  }) {
    final n = neutral.scale;
    final scales = _resolveRoleScales(roles, palette);
    return NColors(
      brightness: Brightness.dark,
      neutral: neutral,
      roleScales: scales,
      primary: scales[NColorRole.primary]!.s400,
      secondary: scales[NColorRole.secondary]!.s400,
      success: scales[NColorRole.success]!.s400,
      info: scales[NColorRole.info]!.s400,
      warning: scales[NColorRole.warning]!.s400,
      error: scales[NColorRole.error]!.s400,
      textDimmed: n.s500,
      textMuted: n.s400,
      textToned: n.s300,
      text: n.s200,
      textHighlighted: const Color(0xFFFFFFFF),
      textInverted: n.s900,
      bg: n.s900,
      bgMuted: n.s800,
      bgElevated: n.s800,
      bgAccented: n.s700,
      bgInverted: const Color(0xFFFFFFFF),
      border: n.s800,
      borderMuted: n.s700,
      borderAccented: n.s700,
      borderInverted: const Color(0xFFFFFFFF),
    );
  }

  static Map<NColorRole, NColorScale> _resolveRoleScales(
    Map<NColorRole, NColorScale>? roles,
    Map<NColorRole, NRoleColor>? palette,
  ) {
    return {
      for (final r in NColorRole.values)
        if (r != NColorRole.neutral)
          r: roles?[r] ?? palette?[r]?.scale ?? NRoleScales.of(r),
    };
  }

  @override
  NColors copyWith({
    Brightness? brightness,
    NNeutralPalette? neutral,
    Map<NColorRole, NColorScale>? roleScales,
    Color? primary,
    Color? secondary,
    Color? success,
    Color? info,
    Color? warning,
    Color? error,
    Color? textDimmed,
    Color? textMuted,
    Color? textToned,
    Color? text,
    Color? textHighlighted,
    Color? textInverted,
    Color? bg,
    Color? bgMuted,
    Color? bgElevated,
    Color? bgAccented,
    Color? bgInverted,
    Color? border,
    Color? borderMuted,
    Color? borderAccented,
    Color? borderInverted,
  }) {
    return NColors(
      brightness: brightness ?? this.brightness,
      neutral: neutral ?? this.neutral,
      roleScales: roleScales ?? this.roleScales,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      textDimmed: textDimmed ?? this.textDimmed,
      textMuted: textMuted ?? this.textMuted,
      textToned: textToned ?? this.textToned,
      text: text ?? this.text,
      textHighlighted: textHighlighted ?? this.textHighlighted,
      textInverted: textInverted ?? this.textInverted,
      bg: bg ?? this.bg,
      bgMuted: bgMuted ?? this.bgMuted,
      bgElevated: bgElevated ?? this.bgElevated,
      bgAccented: bgAccented ?? this.bgAccented,
      bgInverted: bgInverted ?? this.bgInverted,
      border: border ?? this.border,
      borderMuted: borderMuted ?? this.borderMuted,
      borderAccented: borderAccented ?? this.borderAccented,
      borderInverted: borderInverted ?? this.borderInverted,
    );
  }

  @override
  NColors lerp(ThemeExtension<NColors>? other, double t) {
    if (other is! NColors) return this;
    Color c(Color x, Color y) => Color.lerp(x, y, t)!;
    return NColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      neutral: t < 0.5 ? neutral : other.neutral,
      roleScales: t < 0.5 ? roleScales : other.roleScales,
      primary: c(primary, other.primary),
      secondary: c(secondary, other.secondary),
      success: c(success, other.success),
      info: c(info, other.info),
      warning: c(warning, other.warning),
      error: c(error, other.error),
      textDimmed: c(textDimmed, other.textDimmed),
      textMuted: c(textMuted, other.textMuted),
      textToned: c(textToned, other.textToned),
      text: c(text, other.text),
      textHighlighted: c(textHighlighted, other.textHighlighted),
      textInverted: c(textInverted, other.textInverted),
      bg: c(bg, other.bg),
      bgMuted: c(bgMuted, other.bgMuted),
      bgElevated: c(bgElevated, other.bgElevated),
      bgAccented: c(bgAccented, other.bgAccented),
      bgInverted: c(bgInverted, other.bgInverted),
      border: c(border, other.border),
      borderMuted: c(borderMuted, other.borderMuted),
      borderAccented: c(borderAccented, other.borderAccented),
      borderInverted: c(borderInverted, other.borderInverted),
    );
  }
}
