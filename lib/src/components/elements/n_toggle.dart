import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The semantic color role applied to an [NToggle] in the on state.
enum NToggleColor {
  /// Uses the primary brand color.
  primary,

  /// Uses the secondary accent color.
  secondary,

  /// Uses the success color.
  success,

  /// Uses the informational color.
  info,

  /// Uses the warning color.
  warning,

  /// Uses the error color.
  error,

  /// Uses a neutral color.
  neutral,
}

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
class NToggle extends StatelessWidget {
  /// The current state of the toggle. `true` means on.
  final bool value;

  /// Called with the new value when the user taps the toggle.
  /// Set to `null` to make the toggle non-interactive.
  final ValueChanged<bool>? onChanged;

  /// The semantic color role used for the active (on) background.
  /// Defaults to [NToggleColor.primary].
  final NToggleColor color;

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
    this.color = NToggleColor.primary,
    this.size = NToggleSize.md,
    this.disabled = false,
    this.loading = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.label,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    Widget toggle = _buildToggle(context);
    if (label != null) {
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
                  onTap: (disabled || loading)
                      ? null
                      : () => onChanged?.call(!value),
                  child: Text(
                    label!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: disabled
                          ? NTokens.textDisabled(context)
                          : NTokens.textDefault(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (helperText != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.only(left: _getWidth() + 12),
              child: Text(
                helperText!,
                style: TextStyle(
                    fontSize: 12, color: NTokens.textMuted(context)),
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
    if (disabled) {
      backgroundColor = NTokens.borderMuted(context);
    } else if (value) {
      backgroundColor = activeColor;
    } else {
      backgroundColor = NTokens.borderDefault(context);
    }

    return Semantics(
      toggled: value,
      enabled: !disabled,
      child: GestureDetector(
        onTap: (disabled || loading) ? null : () => onChanged?.call(!value),
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
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
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
                child: loading
                    ? SizedBox(
                        width: thumbSize * 0.5,
                        height: thumbSize * 0.5,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(activeColor),
                        ),
                      )
                    : (value ? checkedIcon : uncheckedIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getActiveColor(BuildContext context) {
    return NComponentColors.resolve(
      context,
      NComponentColor.values[color.index],
    ).main;
  }

  double _getWidth() {
    switch (size) {
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
    switch (size) {
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
    switch (size) {
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
