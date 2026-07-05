import 'package:flutter/material.dart';

/// A completely unstyled badge/label container primitive.
///
/// [NRawBadge] renders [child] inside a [DecoratedBox] + optional [Padding]
/// with no color, border, or typography applied. You own the full visual
/// layer via [decoration], [padding], and [child].
///
/// Use this when you need the overlay-positioning behaviour of a badge without
/// any NUI styling, or to build your own badge variant on top of NUI foundations.
///
/// ## Standalone badge
///
/// ```dart
/// NRawBadge(
///   decoration: BoxDecoration(
///     color: Colors.red,
///     borderRadius: BorderRadius.circular(99),
///   ),
///   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
///   child: Text('3', style: TextStyle(color: Colors.white, fontSize: 11)),
/// )
/// ```
///
/// ## Overlay badge (stacked on an icon)
///
/// ```dart
/// NRawBadge.overlay(
///   badge: NRawBadge(
///     decoration: BoxDecoration(
///       color: Colors.red,
///       shape: BoxShape.circle,
///     ),
///     padding: EdgeInsets.all(4),
///     child: const SizedBox.shrink(),
///   ),
///   child: const Icon(Icons.notifications),
/// )
/// ```
///
/// See also:
/// - [NBadge]: the fully-styled NUI badge.
class NRawBadge extends StatelessWidget {
  /// Creates an unstyled badge container.
  const NRawBadge({
    super.key,
    required this.child,
    this.decoration,
    this.padding,
  });

  /// The content of the badge (typically a short [Text]).
  final Widget child;

  /// Optional decoration applied to the badge container.
  ///
  /// When `null`, no visual container is drawn and [child] is rendered as-is.
  final BoxDecoration? decoration;

  /// Optional padding applied inside the badge container.
  ///
  /// Ignored when [decoration] is `null`.
  final EdgeInsetsGeometry? padding;

  // ---------------------------------------------------------------------------
  // Overlay constructor
  // ---------------------------------------------------------------------------

  /// Stacks a [badge] widget on top of [child] using [Stack] + [Positioned].
  ///
  /// By default, [badge] is placed at the top-right corner with a small
  /// negative offset to overlap the edge of [child]. Override [alignment] and
  /// [offset] to reposition it.
  ///
  /// ```dart
  /// NRawBadge.overlay(
  ///   badge: NRawBadge(
  ///     decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
  ///     padding: EdgeInsets.all(5),
  ///     child: SizedBox.shrink(),
  ///   ),
  ///   child: Icon(Icons.mail),
  /// )
  /// ```
  static Widget overlay({
    required Widget badge,
    required Widget child,
    Alignment badgeAlignment = Alignment.topRight,
    Offset offset = const Offset(4, -4),
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: badgeAlignment.y < 0 ? offset.dy : null,
          bottom: badgeAlignment.y >= 0 ? -offset.dy : null,
          left: badgeAlignment.x < 0 ? offset.dx : null,
          right: badgeAlignment.x >= 0 ? -offset.dx : null,
          child: badge,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    if (decoration != null) {
      result = DecoratedBox(
        decoration: decoration!,
        child:
            padding != null ? Padding(padding: padding!, child: child) : child,
      );
    }
    return result;
  }
}
