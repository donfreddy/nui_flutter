import 'package:flutter/widgets.dart';
import 'n_color_scale.dart';
import 'n_tailwind_scales.dart';

/// Configures a color role from a single brand color.
class NRoleColor {
  const NRoleColor(this.seed);
  final Color seed;
  NColorScale get scale => NColorScale.fromSeed(seed);
}

/// The semantic color roles of the design system.
enum NColorRole {
  primary,
  secondary,
  success,
  info,
  warning,
  error,
  neutral,

}

/// The switchable neutral palette.
enum NNeutralPalette {
  slate,
  zinc,
  neutral,
  stone;

  NColorScale get scale => switch (this) {
        NNeutralPalette.slate => NTailwindScales.slate,
        NNeutralPalette.zinc => NTailwindScales.zinc,
        NNeutralPalette.neutral => NTailwindScales.neutral,
        NNeutralPalette.stone => NTailwindScales.stone,
      };
}

abstract final class NRoleScales {
  static NColorScale of(NColorRole role) {
    switch (role) {
      case NColorRole.primary:
        // Nuxt UI signature green (#00DC82) — kept as the brand default.
        // Use NTailwindScales.green for the official Tailwind green-500.
        return NColorScale.nuxtGreen;
      case NColorRole.success:
        return NTailwindScales.green;
      case NColorRole.secondary:
        return NTailwindScales.blue;
      case NColorRole.info:
        return NTailwindScales.sky;
      case NColorRole.warning:
        return NTailwindScales.amber;
      case NColorRole.error:
        return NTailwindScales.red;
      case NColorRole.neutral:
        throw ArgumentError(
            'neutral has no fixed scale. Read it from NColors.neutral');
    }
  }
}
