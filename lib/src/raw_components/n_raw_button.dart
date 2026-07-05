import 'package:flutter/material.dart';
import '../primitives/n_press_scale.dart';

/// A completely unstyled, interactive button primitive.
///
/// [NRawButton] handles **only** interaction semantics (tap, long-press,
/// focus, hover, disabled state, press-scale feedback) with **no color,
/// border, padding, or typography**. You own 100% of the visual rendering
/// via [builder].
///
/// Use this when you need interactive behaviour without NUI styling, for
/// example when building a custom design-system on top of NUI primitives,
/// or when the built-in [NButton] variants don't fit your use case.
///
/// ## Example
///
/// ```dart
/// NRawButton(
///   onPressed: () => launch(url),
///   builder: (context, states) => Container(
///     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
///     decoration: BoxDecoration(
///       color: states.isPressed
///           ? Colors.purple.shade700
///           : Colors.purple,
///       borderRadius: BorderRadius.circular(8),
///     ),
///     child: Text(
///       'Custom button',
///       style: TextStyle(
///         color: Colors.white,
///         fontWeight: FontWeight.w600,
///       ),
///     ),
///   ),
/// )
/// ```
///
/// See also:
/// - [NButton]: the fully-styled NUI button with variants/colors.
/// - [NPressScale]: the press-feedback primitive used internally.
class NRawButton extends StatefulWidget {
  /// Creates an unstyled interactive button.
  const NRawButton({
    super.key,
    required this.builder,
    this.onPressed,
    this.onLongPress,
    this.disabled = false,
    this.pressScale = 0.97,
    this.haptic = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.hitTestBehavior = HitTestBehavior.opaque,
  });

  /// Builds the button content given the current [NRawButtonStates].
  ///
  /// Called on every state change so you can react to `isPressed`,
  /// `isFocused`, `isHovered`, and `isDisabled`.
  final Widget Function(BuildContext context, NRawButtonStates states) builder;

  /// Called when the button is tapped. `null` makes the button non-interactive.
  final VoidCallback? onPressed;

  /// Called on long-press.
  final VoidCallback? onLongPress;

  /// When `true`, blocks interaction and sets `isDisabled` in [NRawButtonStates].
  final bool disabled;

  /// The scale factor applied while pressed. Pass `1.0` to disable.
  final double pressScale;

  /// Whether to fire a light haptic tick on press-down.
  final bool haptic;

  /// Semantic label passed to [Semantics]. Defaults to `null`.
  final String? semanticLabel;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Whether this button should auto-focus.
  final bool autofocus;

  /// Hit-test behavior for the underlying [GestureDetector].
  final HitTestBehavior hitTestBehavior;

  @override
  State<NRawButton> createState() => _NRawButtonState();
}

class _NRawButtonState extends State<NRawButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  NRawButtonStates get _states => NRawButtonStates(
        isPressed: _pressed,
        isHovered: _hovered,
        isFocused: _focused,
        isDisabled: widget.disabled,
      );

  @override
  Widget build(BuildContext context) {
    final interactive = !widget.disabled && widget.onPressed != null;
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      enabled: !widget.disabled,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (v) => setState(() => _focused = v),
        child: MouseRegion(
          cursor: interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: NPressScale(
            onTap: widget.disabled ? null : widget.onPressed,
            onLongPress: widget.disabled ? null : widget.onLongPress,
            scale: widget.pressScale,
            haptic: widget.haptic,
            enabled: !widget.disabled,
            hitTestBehavior: widget.hitTestBehavior,
            child: Builder(
              builder: (ctx) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: interactive
                      ? (_) => setState(() => _pressed = true)
                      : null,
                  onTapUp: (_) => setState(() => _pressed = false),
                  onTapCancel: () => setState(() => _pressed = false),
                  child: widget.builder(ctx, _states),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Snapshot of an [NRawButton]'s interactive states.
///
/// Passed to the [NRawButton.builder] on every state change.
@immutable
class NRawButtonStates {
  /// Creates a states snapshot.
  const NRawButtonStates({
    required this.isPressed,
    required this.isHovered,
    required this.isFocused,
    required this.isDisabled,
  });

  /// `true` while the pointer is held down.
  final bool isPressed;

  /// `true` while the pointer is hovering (desktop/web).
  final bool isHovered;

  /// `true` while the button has keyboard focus.
  final bool isFocused;

  /// `true` when [NRawButton.disabled] is `true`.
  final bool isDisabled;

  /// `true` if the button is interactive (not disabled, not in a loading state).
  bool get isInteractive => !isDisabled;

  @override
  String toString() =>
      'NRawButtonStates(pressed:$isPressed, hovered:$isHovered, '
      'focused:$isFocused, disabled:$isDisabled)';
}
