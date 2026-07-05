import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

/// A completely unstyled swipe-to-dismiss primitive.
///
/// [NRawDismissible] wraps Flutter's built-in [Dismissible] and exposes the
/// same API with **no background styling**. You control the visual entirely
/// via [background] and [secondaryBackground].
///
/// Use this instead of [Dismissible] when you want dismissible behaviour
/// without the Material defaults, or when building custom list-item actions
/// (delete, archive, mark-as-read, etc.).
///
/// ## Example: delete action
///
/// ```dart
/// NRawDismissible(
///   key: ValueKey(item.id),
///   onDismissed: (_) => deleteItem(item),
///   confirmDismiss: (_) => showConfirmDialog(context),
///   background: Container(
///     color: Colors.red,
///     alignment: Alignment.centerRight,
///     padding: EdgeInsets.only(right: 20),
///     child: Icon(Icons.delete, color: Colors.white),
///   ),
///   child: MyListItem(item),
/// )
/// ```
///
/// ## Example: dual direction (archive ← → delete)
///
/// ```dart
/// NRawDismissible(
///   key: ValueKey(item.id),
///   background: ArchiveBackground(),   // swipe right
///   secondaryBackground: DeleteBackground(), // swipe left
///   onDismissed: (dir) => dir == DismissDirection.startToEnd
///     ? archiveItem(item)
///     : deleteItem(item),
///   child: MyListItem(item),
/// )
/// ```
///
/// See also:
/// - [Dismissible]: Flutter's built-in widget.
class NRawDismissible extends StatelessWidget {
  /// Creates an unstyled dismissible wrapper.
  const NRawDismissible({
    required super.key, // Dismissible requires a key
    required this.child,
    required this.onDismissed,
    this.background,
    this.secondaryBackground,
    this.confirmDismiss,
    this.direction = DismissDirection.horizontal,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.dismissThresholds = const {},
    this.movementDuration = const Duration(milliseconds: 200),
    this.crossAxisEndOffset = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.behavior = HitTestBehavior.opaque,
    this.onUpdate,
  });

  /// The content to make dismissible.
  final Widget child;

  /// Called when the item has been dismissed. [direction] indicates which way.
  final DismissDirectionCallback onDismissed;

  /// Widget drawn behind [child] on start-to-end swipe (left-to-right in LTR).
  ///
  /// When `null`, no background is drawn for that direction.
  final Widget? background;

  /// Widget drawn behind [child] on end-to-start swipe.
  ///
  /// When `null`, [background] is used for both directions.
  final Widget? secondaryBackground;

  /// Called before dismissal to confirm. Return `true` to allow, `false` to
  /// cancel. Async so you can show a confirmation dialog.
  final ConfirmDismissCallback? confirmDismiss;

  /// The direction(s) in which the child can be dismissed.
  final DismissDirection direction;

  /// Duration of the resize animation after dismissal.
  final Duration? resizeDuration;

  /// Per-direction thresholds (0.0–1.0) that trigger dismissal.
  final Map<DismissDirection, double> dismissThresholds;

  /// Duration of the slide-out animation.
  final Duration movementDuration;

  /// How far to offset in the cross-axis during dismissal.
  final double crossAxisEndOffset;

  /// How drag-start is detected.
  final DragStartBehavior dragStartBehavior;

  /// Hit-test behavior.
  final HitTestBehavior behavior;

  /// Called when the dismiss state updates (useful for progress indicators).
  final DismissUpdateCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      direction: direction,
      resizeDuration: resizeDuration,
      dismissThresholds: dismissThresholds,
      movementDuration: movementDuration,
      crossAxisEndOffset: crossAxisEndOffset,
      dragStartBehavior: dragStartBehavior,
      behavior: behavior,
      onUpdate: onUpdate,
      background: background ?? const SizedBox.shrink(),
      secondaryBackground: secondaryBackground,
      child: child,
    );
  }
}
