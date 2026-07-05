import 'package:flutter/material.dart';
import 'n_color_palette.dart';
import '../tokens/n_radius.dart';
import '../tokens/n_shadows.dart';

/// Convenience extension on [BuildContext] for accessing the NUI design system.
///
/// Instead of calling `Theme.of(context).extension<NColorPalette>()` directly,
/// use `context.nui` to get a typed [NuiThemeData] bundle that exposes the
/// palette, radius scale, and shadow set in one place.
///
/// ```dart
/// // Before (verbose):
/// final palette = Theme.of(context).extension<NColorPalette>()!;
/// final color = palette.primary;
///
/// // After (idiomatic):
/// final color = context.nui.colors.primary;
/// final radius = context.nui.radius.md;
/// final shadow = context.nui.shadows.sm;
/// ```
extension NuiContext on BuildContext {
  /// Returns the [NuiThemeData] for this context.
  ///
  /// Throws a [FlutterError] if [NColorPalette] is not registered via [NTheme]
  /// or [NApp]. Wrap your [MaterialApp] with [NApp] or pass [NTheme.lightTheme]
  /// to [MaterialApp.theme].
  NuiThemeData get nui => NuiThemeData.of(this);

  /// Returns the [NuiThemeData] for this context, or `null` if not registered.
  NuiThemeData? get nuiOrNull => NuiThemeData.maybeOf(this);
}

/// A typed bundle of NUI design tokens readable from a [BuildContext].
///
/// Accessed via `context.nui`. Provides the current [NColorPalette], [NRadius]
/// scale, and [NShadows] set without needing to call multiple `Theme.of`
/// look-ups yourself.
///
/// The [radius] and [shadows] are derived from the registered [NRadius] and
/// [NShadows] extensions when present, or fall back to sensible defaults.
@immutable
class NuiThemeData {
  const NuiThemeData._({
    required this.colors,
    required this.radius,
    required this.shadows,
  });

  /// The full semantic color palette for the current brightness.
  final NColorPalette colors;

  /// The active radius scale.
  final NRadius radius;

  /// The active shadow set for the current brightness.
  final NShadows shadows;

  // ---------------------------------------------------------------------------
  // Look-up
  // ---------------------------------------------------------------------------

  /// Reads the [NuiThemeData] from [context].
  ///
  /// Throws if [NColorPalette] is not registered.
  static NuiThemeData of(BuildContext context) {
    final palette = Theme.of(context).extension<NColorPalette>();
    if (palette == null) {
      throw FlutterError(
        'NuiThemeData not found in this BuildContext.\n'
        'Make sure you wrap your app with NApp(...) or use\n'
        '  theme: NTheme.lightTheme(palette: myPalette)\n'
        'in your MaterialApp.',
      );
    }
    final radius = Theme.of(context).extension<NRadius>() ?? const NRadius();
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final shadows = Theme.of(context).extension<NShadows>() ??
        (isDark ? NShadows.dark() : NShadows.light());

    return NuiThemeData._(
      colors: palette,
      radius: radius,
      shadows: shadows,
    );
  }

  /// Reads the [NuiThemeData] from [context], returning `null` if not found.
  static NuiThemeData? maybeOf(BuildContext context) {
    final palette = Theme.of(context).extension<NColorPalette>();
    if (palette == null) return null;
    final radius = Theme.of(context).extension<NRadius>() ?? const NRadius();
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final shadows = Theme.of(context).extension<NShadows>() ??
        (isDark ? NShadows.dark() : NShadows.light());
    return NuiThemeData._(
      colors: palette,
      radius: radius,
      shadows: shadows,
    );
  }
}
