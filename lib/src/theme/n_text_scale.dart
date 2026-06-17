/// A global text-scaling utility for the NUI design system.
///
/// **Deprecated:** Prefer the [NTheme.textScale] parameter instead of
/// this static mutable. Static state is not safe in multi-window or test
/// environments.
///
/// ```dart
/// // Before (deprecated):
/// NTextScale.setScale(1.15);
///
/// // After:
/// MaterialApp(
///   theme: NTheme.lightTheme(palette: palette, textScale: 1.15),
/// )
/// ```
@Deprecated('Use NTheme.lightTheme(textScale: ...) instead of static mutable')
abstract class NTextScale {
  // ---------------------------------------------------------------------------
  // Preset scales
  // ---------------------------------------------------------------------------

  /// 85% scale. Suitable for compact layouts or accessibility preferences.
  static const double small = 0.85;

  /// 100% scale. The default used when no preference is set.
  static const double medium = 1.0;

  /// 115% scale. A comfortable larger text size.
  static const double large = 1.15;

  /// 130% scale. A strongly enlarged text size.
  static const double extraLarge = 1.3;

  // ---------------------------------------------------------------------------
  // Clamp bounds
  // ---------------------------------------------------------------------------

  /// The minimum allowed scale factor (70%).
  static const double minScale = 0.7;

  /// The maximum allowed scale factor (150%).
  static const double maxScale = 1.5;

  static double _current = medium;

  // ---------------------------------------------------------------------------
  // State accessors
  // ---------------------------------------------------------------------------

  /// The active scale multiplier.
  static double get current => _current;

  // ---------------------------------------------------------------------------
  // Mutators
  // ---------------------------------------------------------------------------

  /// Sets the active scale to [scale], clamped to [minScale]..[maxScale].
  static void setScale(double scale) {
    _current = scale.clamp(minScale, maxScale);
  }

  /// Resets the scale to [medium] (100%).
  static void reset() {
    _current = medium;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns [baseSize] multiplied by the active [current] scale.
  ///
  /// Use this inside [NTheme._textTheme] to produce scaled font sizes.
  static double scale(double baseSize) {
    return baseSize * _current;
  }

  /// Whether the current scale equals [medium].
  static bool get isDefault => _current == medium;

  /// Whether the current scale is not one of the four presets.
  static bool get isCustom {
    const presets = [small, medium, large, extraLarge];
    return !presets.contains(_current);
  }

  /// A human-readable name for the current scale preset.
  ///
  /// Returns `'Custom (XX%)'` when the scale does not match any preset.
  static String get currentName {
    if (_current == small) return 'Small';
    if (_current == medium) return 'Medium';
    if (_current == large) return 'Large';
    if (_current == extraLarge) return 'Extra Large';
    return 'Custom (${(_current * 100).toStringAsFixed(0)}%)';
  }

  /// The current scale expressed as a percentage string (e.g., `'100%'`).
  static String get currentPercentage {
    return '${(_current * 100).toStringAsFixed(0)}%';
  }
}
