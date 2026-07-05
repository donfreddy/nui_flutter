import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A primitive widget that wraps [child] with tactile press feedback:
/// scale to [scale] and a slight dim to [pressedOpacity] on pointer-down,
/// with an optional haptic tick.
///
/// [NPressScale] is a **standalone primitive**: it adds no theming, colors,
/// or navigation logic. Use it as a building block for custom interactive
/// widgets or wrap existing ones to add press feedback.
///
/// ```dart
/// // Simple tappable surface with press feedback:
/// NPressScale(
///   onTap: () => doSomething(),
///   child: MyCustomWidget(),
/// )
///
/// // Disable feedback (e.g., while loading):
/// NPressScale(
///   onTap: onPressed,
///   enabled: !isLoading,
///   child: MyWidget(),
/// )
/// ```
///
/// See also:
/// - [NButton] which uses [NPressScale] internally.
/// - [NIconButton] which uses [NPressScale] internally.
class NPressScale extends StatefulWidget {
  /// Creates a press-scale wrapper.
  const NPressScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.97,
    this.pressedOpacity = 0.90,
    this.haptic = true,
    this.duration = const Duration(milliseconds: 110),
    this.curve = Curves.easeOut,
    this.enabled = true,
    this.hitTestBehavior = HitTestBehavior.opaque,
  });

  /// The widget to wrap with press feedback.
  final Widget child;

  /// Tap callback. When `null` and [enabled] is `true`, the widget still
  /// consumes touch events (for loading/disabled states with haptic).
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// The scale factor applied while the pointer is down. Defaults to `0.97`.
  final double scale;

  /// The opacity applied while pressed. `1.0` disables the dim effect.
  /// Defaults to `0.90`.
  final double pressedOpacity;

  /// Fire a light haptic tick on press-down. Defaults to `true`.
  /// No-op on platforms without haptics.
  final bool haptic;

  /// Duration of the scale/opacity animation. Defaults to 110 ms.
  final Duration duration;

  /// Curve used for both scale and opacity animations. Defaults to [Curves.easeOut].
  final Curve curve;

  /// Whether press feedback is active. When `false`, taps still pass through
  /// but no visual/haptic feedback is shown. Defaults to `true`.
  final bool enabled;

  /// How the gesture detector hits the widget tree. Defaults to
  /// [HitTestBehavior.opaque] so the full bounding box is tappable.
  final HitTestBehavior hitTestBehavior;

  @override
  State<NPressScale> createState() => _NPressScaleState();
}

class _NPressScaleState extends State<NPressScale> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  void _onDown(TapDownDetails _) {
    if (!widget.enabled) return;
    _setPressed(true);
    if (widget.haptic) HapticFeedback.lightImpact();
  }

  void _onUp(TapUpDetails _) => _setPressed(false);
  void _onCancel() => _setPressed(false);

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && widget.onTap != null;
    return GestureDetector(
      behavior: widget.hitTestBehavior,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: active ? _onDown : null,
      onTapUp: active ? _onUp : null,
      onTapCancel: active ? _onCancel : null,
      child: AnimatedScale(
        scale: (_pressed && widget.enabled) ? widget.scale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: AnimatedOpacity(
          opacity: (_pressed && widget.enabled) ? widget.pressedOpacity : 1.0,
          duration: widget.duration,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}
