import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// The size of an [NCheckbox].
enum NCheckboxSize {
  /// Extra small.
  xs,

  /// Small.
  sm,

  /// Medium. The default size.
  md,

  /// Large.
  lg,

  /// Extra large.
  xl,
}



/// A checkbox input element with optional label and description.
///
/// Supports a checked, unchecked, and indeterminate state. The checkbox
/// indicator can be positioned at the start (default) or end of the label.
///
/// ```dart
/// NCheckbox(
///   value: true,
///   onChanged: (v) => setState(() => _checked = v),
///   label: 'Accept terms',
///   description: 'I agree to the terms and conditions.',
/// )
/// ```
class NCheckbox extends StatelessWidget {
  /// The current checked state. When null, the checkbox shows an
  /// indeterminate state.
  final bool? value;

  /// Called when the checkbox state changes, with the new value.
  ///
  /// When [value] is null (indeterminate), toggling sets it to true.
  final ValueChanged<bool?>? onChanged;

  /// The text label displayed next to the checkbox.
  final String? label;

  /// A description text displayed below [label] in a smaller muted style.
  final String? description;

  /// The size of the checkbox. Defaults to [NCheckboxSize.md].
  final NCheckboxSize size;

  /// The semantic color role. Defaults to [NColorRole.primary].
  final NColorRole color;

  /// Whether the checkbox is non-interactive. Defaults to false.
  final bool disabled;

  /// Creates an [NCheckbox].
  const NCheckbox({
    super.key,
    this.value = false,
    this.onChanged,
    this.label,
    this.description,
    this.size = NCheckboxSize.md,
    this.color = NColorRole.primary,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final checkboxSize = _getSize();
    final iconSize = _getIconSize();
    final fontSize = _getFontSize();
    final descriptionSize = _getDescriptionSize();
    final activeColor = context.nui.colors.role(color);
    final isActive = onChanged != null && !disabled;

    return GestureDetector(
      onTap: isActive
          ? () {
              if (value == null) {
                onChanged!(true);
              } else {
                onChanged!(!value!);
              }
            }
          : null,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              checked: value ?? false,
              enabled: isActive,
              child: Container(
                width: checkboxSize,
                height: checkboxSize,
                decoration: BoxDecoration(
                  color: value == true ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:
                        value == true ? activeColor : context.nui.colors.border,
                    width: 1.5,
                  ),
                ),
                child: value == true
                    ? Icon(
                        Icons.check,
                        size: iconSize,
                        color: context.nui.colors.textInverted,
                      )
                    : (value == null
                        ? Center(
                            child: Container(
                              width: iconSize,
                              height: 2,
                              color: activeColor,
                            ),
                          )
                        : null),
              ),
            ),
            if (label != null || description != null) ...[
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (label != null)
                      Text(
                        label!,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                          color: context.nui.colors.text,
                        ),
                      ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: descriptionSize,
                          color: context.nui.colors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case NCheckboxSize.xs:
        return 14;
      case NCheckboxSize.sm:
        return 16;
      case NCheckboxSize.md:
        return 18;
      case NCheckboxSize.lg:
        return 20;
      case NCheckboxSize.xl:
        return 22;
    }
  }

  double _getIconSize() {
    switch (size) {
      case NCheckboxSize.xs:
        return 10;
      case NCheckboxSize.sm:
        return 12;
      case NCheckboxSize.md:
        return 14;
      case NCheckboxSize.lg:
        return 16;
      case NCheckboxSize.xl:
        return 18;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NCheckboxSize.xs:
      case NCheckboxSize.sm:
        return 13;
      case NCheckboxSize.md:
      case NCheckboxSize.lg:
        return 14;
      case NCheckboxSize.xl:
        return 16;
    }
  }

  double _getDescriptionSize() {
    switch (size) {
      case NCheckboxSize.xs:
      case NCheckboxSize.sm:
        return 11;
      case NCheckboxSize.md:
      case NCheckboxSize.lg:
        return 12;
      case NCheckboxSize.xl:
        return 13;
    }
  }
}
