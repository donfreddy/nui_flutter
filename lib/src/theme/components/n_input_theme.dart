import 'package:flutter/material.dart';

/// A [ThemeExtension] that controls the visual defaults for [NInput].
///
/// Register this extension through [NTheme.lightTheme] or [NTheme.darkTheme].
/// A default instance is always registered automatically; override individual
/// fields by passing a custom [NInputTheme] in the `extensions` list:
///
/// ```dart
/// NTheme.lightTheme(
///   palette: myPalette,
///   extensions: [
///     NInputTheme(radius: 12.0, loadingIcon: LucideIcons.loaderCircle),
///   ],
/// )
/// ```
class NInputTheme extends ThemeExtension<NInputTheme> {
  /// An optional icon to display in the leading position while
  /// [NInput.loading] is true.
  ///
  /// Defaults to [LucideIcons.loader] when not set.
  final IconData? loadingIcon;

  /// The corner radius applied to the input field container.
  ///
  /// Defaults to 8.0 dp.
  final double radius;

  /// Creates an [NInputTheme].
  ///
  /// [radius] defaults to 8.0 dp.
  const NInputTheme({
    this.loadingIcon,
    this.radius = 8.0,
  });

  /// Returns a copy of this theme with the given fields replaced.
  @override
  NInputTheme copyWith({IconData? loadingIcon, double? radius}) {
    return NInputTheme(
      loadingIcon: loadingIcon ?? this.loadingIcon,
      radius: radius ?? this.radius,
    );
  }

  /// Linearly interpolates between this theme and [other] by [t].
  @override
  NInputTheme lerp(ThemeExtension<NInputTheme>? other, double t) {
    if (other is! NInputTheme) return this;
    return NInputTheme(
      loadingIcon: loadingIcon ?? other.loadingIcon,
      radius: radius + (other.radius - radius) * t,
    );
  }
}
