import 'package:flutter/material.dart';

/// A completely unstyled tooltip primitive.
///
/// [NRawTooltip] wraps [child] and shows a custom [tooltipBuilder] widget in a
/// floating overlay when the user long-presses (mobile) or hovers (desktop/web).
/// **No color, shape, or typography** is applied: the visual is entirely
/// defined by [tooltipBuilder].
///
/// For simple cases, use [NRawTooltip.text] which accepts a plain [String].
///
/// ## Custom tooltip widget
///
/// ```dart
/// NRawTooltip(
///   tooltipBuilder: (context) => Container(
///     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
///     decoration: BoxDecoration(
///       color: Colors.black87,
///       borderRadius: BorderRadius.circular(6),
///     ),
///     child: const Text(
///       'More info',
///       style: TextStyle(color: Colors.white, fontSize: 12),
///     ),
///   ),
///   child: const Icon(Icons.info_outline),
/// )
/// ```
///
/// ## Simple text tooltip
///
/// ```dart
/// NRawTooltip.text(
///   message: 'This is a tooltip',
///   child: const Icon(Icons.help_outline),
/// )
/// ```
///
/// See also:
/// - Flutter's built-in [Tooltip] widget.
/// - [NCard] for richer tooltip shells.
class NRawTooltip extends StatefulWidget {
  /// Creates a custom-widget tooltip.
  const NRawTooltip({
    super.key,
    required this.child,
    required this.tooltipBuilder,
    this.preferBelow = false,
    this.verticalOffset = 20.0,
    this.waitDuration = const Duration(milliseconds: 600),
    this.showDuration = const Duration(milliseconds: 1500),
    this.triggerMode = TooltipTriggerMode.longPress,
    this.enableFeedback = true,
  });

  /// Creates a tooltip showing a plain text message, styled by the platform.
  ///
  /// This is a thin convenience factory that delegates to Flutter's [Tooltip].
  factory NRawTooltip.text({
    Key? key,
    required Widget child,
    required String message,
    bool preferBelow = false,
    double verticalOffset = 20.0,
    Duration waitDuration = const Duration(milliseconds: 600),
    Duration showDuration = const Duration(milliseconds: 1500),
    TooltipTriggerMode triggerMode = TooltipTriggerMode.longPress,
  }) {
    return _NRawTooltipText(
      key: key,
      message: message,
      preferBelow: preferBelow,
      verticalOffset: verticalOffset,
      waitDuration: waitDuration,
      showDuration: showDuration,
      triggerMode: triggerMode,
      child: child,
    ) as NRawTooltip;
  }

  /// The widget the tooltip is anchored to.
  final Widget child;

  /// Builds the tooltip overlay content. Called once when shown.
  final WidgetBuilder tooltipBuilder;

  /// Whether to prefer showing the tooltip below [child]. Defaults to `false`
  /// (prefers above, but flips automatically if there's not enough space).
  final bool preferBelow;

  /// Vertical distance between [child] and the tooltip. Defaults to `20`.
  final double verticalOffset;

  /// Delay before showing the tooltip on hover (desktop).
  final Duration waitDuration;

  /// How long to show the tooltip before auto-dismissing.
  final Duration showDuration;

  /// When to trigger the tooltip on touch devices.
  final TooltipTriggerMode triggerMode;

  /// Whether to fire haptic feedback on show.
  final bool enableFeedback;

  @override
  State<NRawTooltip> createState() => _NRawTooltipState();
}

class _NRawTooltipState extends State<NRawTooltip> {
  OverlayEntry? _overlay;
  bool _visible = false;

  void _show(BuildContext anchorContext) {
    if (_visible) return;
    _visible = true;

    final box = anchorContext.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final anchorOffset = box.localToGlobal(Offset.zero);
    final anchorSize = box.size;

    _overlay = OverlayEntry(builder: (ctx) {
      return _TooltipOverlay(
        anchorOffset: anchorOffset,
        anchorSize: anchorSize,
        preferBelow: widget.preferBelow,
        verticalOffset: widget.verticalOffset,
        builder: widget.tooltipBuilder,
        onDismiss: _hide,
      );
    });

    Overlay.of(anchorContext).insert(_overlay!);

    Future.delayed(widget.showDuration, _hide);
  }

  void _hide() {
    if (!_visible) return;
    _visible = false;
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.triggerMode == TooltipTriggerMode.longPress
          ? () => _show(context)
          : null,
      onTap: widget.triggerMode == TooltipTriggerMode.tap
          ? () => _show(context)
          : null,
      child: MouseRegion(
        onEnter: (_) => _show(context),
        onExit: (_) => Future.delayed(widget.waitDuration, _hide),
        child: widget.child,
      ),
    );
  }
}

/// Internal overlay widget that positions the tooltip above/below the anchor.
class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.anchorOffset,
    required this.anchorSize,
    required this.preferBelow,
    required this.verticalOffset,
    required this.builder,
    required this.onDismiss,
  });

  final Offset anchorOffset;
  final Size anchorSize;
  final bool preferBelow;
  final double verticalOffset;
  final WidgetBuilder builder;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final showBelow = preferBelow || anchorOffset.dy < screenSize.height / 2;

    final top =
        showBelow ? anchorOffset.dy + anchorSize.height + verticalOffset : null;
    final bottom = !showBelow
        ? screenSize.height - anchorOffset.dy + verticalOffset
        : null;
    final left = (anchorOffset.dx + anchorSize.width / 2)
        .clamp(8.0, screenSize.width - 8);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(
        children: [
          Positioned(
            top: top,
            bottom: bottom,
            left: left,
            child: FractionalTranslation(
              translation: const Offset(-0.5, 0),
              child: Material(
                type: MaterialType.transparency,
                child: builder(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Private subclass used by NRawTooltip.text factory to delegate to Flutter's Tooltip.
class _NRawTooltipText extends NRawTooltip {
  _NRawTooltipText({
    super.key,
    required super.child,
    required String message,
    required super.preferBelow,
    required super.verticalOffset,
    required super.waitDuration,
    required super.showDuration,
    required super.triggerMode,
  }) : super(
          tooltipBuilder: (_) => Tooltip(
            message: message,
            child: const SizedBox.shrink(),
          ),
        );
}
