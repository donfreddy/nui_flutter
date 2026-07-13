import 'package:nui_flutter/nui_flutter.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The size of an [NToggle], controlling its width, height, and thumb diameter.
enum NToggleSize {
  /// Extra small (28 x 16 dp).
  xs,

  /// Small (36 x 20 dp).
  sm,

  /// Medium (44 x 24 dp). The default size.
  md,

  /// Large (52 x 28 dp).
  lg,

  /// Extra large (60 x 32 dp).
  xl,
}

/// An animated on/off toggle switch.
///
/// Supports five [NToggleSize] options and seven [NToggleColor] semantic roles.
/// An optional [label] and [helperText] can be displayed beside the switch.
/// While [loading] is `true`, a spinner replaces the thumb icon.
///
/// ```dart
/// NToggle(
///   value: _isEnabled,
///   onChanged: (v) => setState(() => _isEnabled = v),
///   label: 'Enable notifications',
///   color: NToggleColor.primary,
/// )
/// ```
class NToggle extends StatefulWidget {
  /// The current state of the toggle. `true` means on.
  final bool value;

  /// Called with the new value when the user taps the toggle.
  /// Set to `null` to make the toggle non-interactive.
  final ValueChanged<bool>? onChanged;

  /// The semantic color role used for the active (on) background.
  /// Defaults to [NColorRole.primary].
  final NColorRole color;

  /// The size of the toggle. Defaults to [NToggleSize.md].
  final NToggleSize size;

  /// When `true`, reduces opacity and blocks interaction.
  final bool disabled;

  /// When `true`, shows a circular progress indicator inside the thumb
  /// and blocks interaction.
  final bool loading;

  /// A custom icon displayed inside the thumb when the toggle is on.
  final Widget? checkedIcon;

  /// A custom icon displayed inside the thumb when the toggle is off.
  final Widget? uncheckedIcon;

  /// An optional label rendered to the right of the toggle.
  final String? label;

  /// Helper text shown below the [label].
  final String? helperText;

  /// Creates an [NToggle].
  const NToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.color = NColorRole.primary,
    this.size = NToggleSize.md,
    this.disabled = false,
    this.loading = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.label,
    this.helperText,
  });

  @override
  State<NToggle> createState() => _NToggleState();
}

class _NToggleState extends State<NToggle> with TickerProviderStateMixin {
  late final AnimationController _loadingCtrl;
  late final Animation<double> _loadingRotation;

  @override
  void initState() {
    super.initState();
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadingRotation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_loadingCtrl);
    if (widget.loading) _loadingCtrl.repeat();
  }

  @override
  void dispose() {
    _loadingCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading != oldWidget.loading) {
      if (widget.loading) {
        _loadingCtrl.repeat();
      } else {
        _loadingCtrl.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget toggle = _buildToggle(context);
    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              toggle,
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: (widget.disabled || widget.loading)
                      ? null
                      : () => widget.onChanged?.call(!widget.value),
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.disabled
                          ? context.nui.colors.textMuted
                          : context.nui.colors.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.helperText != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.only(left: _getWidth() + 12),
              child: Text(
                widget.helperText!,
                style: TextStyle(
                    fontSize: 12, color: context.nui.colors.textMuted),
              ),
            ),
          ],
        ],
      );
    }
    return toggle;
  }

  Widget _buildToggle(BuildContext context) {
    final width = _getWidth();
    final height = _getHeight();
    final thumbSize = _getThumbSize();
    final activeColor = _getActiveColor(context);

    Color backgroundColor;
    if (widget.disabled) {
      backgroundColor = context.nui.colors.borderMuted;
    } else if (widget.value) {
      backgroundColor = activeColor;
    } else {
      backgroundColor = context.nui.colors.border;
    }

    return Semantics(
      toggled: widget.value,
      enabled: !widget.disabled,
      child: GestureDetector(
        onTap: (widget.disabled || widget.loading)
            ? null
            : () => widget.onChanged?.call(!widget.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(2),
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Center(
                child: widget.loading
                    ? AnimatedBuilder(
                        animation: _loadingCtrl,
                        builder: (_, child) => Transform.rotate(
                          angle: _loadingRotation.value,
                          child: child,
                        ),
                        child: Icon(
                          NIcons.loader,
                          size: _getLoadingIconSize(),
                          color: activeColor,
                        ),
                      )
                    : (widget.value ? widget.checkedIcon : widget.uncheckedIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getActiveColor(BuildContext context) {
    return context.nui.colors.role(widget.color);
  }

  double _getLoadingIconSize() {
    switch (widget.size) {
      case NToggleSize.xs:
        return 8;
      case NToggleSize.sm:
        return 10;
      case NToggleSize.md:
        return 12;
      case NToggleSize.lg:
        return 14;
      case NToggleSize.xl:
        return 16;
    }
  }

  double _getWidth() {
    switch (widget.size) {
      case NToggleSize.xs:
        return 28;
      case NToggleSize.sm:
        return 36;
      case NToggleSize.md:
        return 44;
      case NToggleSize.lg:
        return 52;
      case NToggleSize.xl:
        return 60;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case NToggleSize.xs:
        return 16;
      case NToggleSize.sm:
        return 20;
      case NToggleSize.md:
        return 24;
      case NToggleSize.lg:
        return 28;
      case NToggleSize.xl:
        return 32;
    }
  }

  double _getThumbSize() {
    switch (widget.size) {
      case NToggleSize.xs:
        return 12;
      case NToggleSize.sm:
        return 16;
      case NToggleSize.md:
        return 20;
      case NToggleSize.lg:
        return 24;
      case NToggleSize.xl:
        return 28;
    }
  }
}
