import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// A completely unstyled card container primitive.
///
/// [NRawCard] is a [DecoratedBox] + optional [Padding] + optional
/// [InkWell] tap handler with **no color, border, shadow, or typography**.
/// You own 100% of the visual rendering via [decoration].
///
/// Use this when the built-in [NCard] variants don't match your design, or
/// when building custom card components on top of NUI layout primitives.
///
/// ## Static card
///
/// ```dart
/// NRawCard(
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.circular(16),
///     boxShadow: context.nui.shadows.md,
///   ),
///   padding: EdgeInsets.all(20),
///   child: Text('Card content'),
/// )
/// ```
///
/// ## Tappable card with splash
///
/// ```dart
/// NRawCard(
///   onTap: () => openDetail(),
///   borderRadius: BorderRadius.circular(16),
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.circular(16),
///   ),
///   padding: EdgeInsets.all(20),
///   child: Text('Tappable'),
/// )
/// ```
///
/// See also:
/// - [NCard]: the fully-styled NUI card.
class NRawCard extends StatelessWidget {
  /// Creates an unstyled card container.
  const NRawCard({
    super.key,
    required this.child,
    this.decoration,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.semanticLabel,
  });

  /// The content of the card.
  final Widget child;

  /// Optional decoration. When `null`, no container is drawn.
  final BoxDecoration? decoration;

  /// Optional padding applied inside the card.
  final EdgeInsetsGeometry? padding;

  /// Called when the card is tapped. When non-null, an [InkWell] is added.
  final VoidCallback? onTap;

  /// Called on long-press.
  final VoidCallback? onLongPress;

  /// Border radius used by the [InkWell] splash clipping when [onTap] is set.
  ///
  /// Should match the `borderRadius` in [decoration] for correct clipping.
  final BorderRadius? borderRadius;

  /// How to clip the card content. Defaults to [Clip.antiAlias].
  final Clip clipBehavior;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    if (decoration != null) {
      content = DecoratedBox(
        decoration: decoration!,
        child: content,
      );
    }

    if (onTap != null || onLongPress != null) {
      content = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipBehavior: clipBehavior,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: borderRadius,
            child: content,
          ),
        ),
      );
    }

    if (semanticLabel != null) {
      content = Semantics(label: semanticLabel, child: content);
    }

    return content;
  }
}
