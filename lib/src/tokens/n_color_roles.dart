import 'package:flutter/widgets.dart';
import 'n_color_scale.dart';

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
        NNeutralPalette.slate => NColorScale.slate,
        NNeutralPalette.zinc => NColorScale.zinc,
        NNeutralPalette.neutral => NColorScale.neutral,
        NNeutralPalette.stone => NColorScale.stone,
      };
}

abstract final class NRoleScales {
  static NColorScale of(NColorRole role) {
    switch (role) {
      case NColorRole.primary:
      case NColorRole.success:
        return NColorScale.green;
      case NColorRole.secondary:
        return NColorScale.blue;
      case NColorRole.info:
        return NColorScale.sky;
      case NColorRole.warning:
        return NColorScale.amber;
      case NColorRole.error:
        return NColorScale.red;
      case NColorRole.neutral:
        throw ArgumentError(
            'neutral has no fixed scale. Read it from NColors.neutral');
    }
  }
}
