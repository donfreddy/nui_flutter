import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The size of an [NRadioGroup] item.
enum NRadioSize {
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

/// The semantic color role applied to an [NRadioGroup].
enum NRadioColor {
  /// Uses [NTokens.primary].
  primary,

  /// Uses [NTokens.secondary].
  secondary,

  /// Uses [NTokens.success].
  success,

  /// Uses [NTokens.warning].
  warning,

  /// Uses [NTokens.error].
  error,

  /// Uses [NTokens.info].
  info,

  /// Uses a neutral color.
  neutral,
}

/// An item model used by [NRadioGroup] to render each option.
///
/// Use [NRadioItem] to provide a label, optional description, and value for
/// each radio option.
class NRadioItem<T> {
  /// The display label for this radio option.
  final String label;

  /// An optional description shown below the label.
  final String? description;

  /// The value associated with this option.
  final T value;

  /// Creates an [NRadioItem].
  const NRadioItem({
    required this.label,
    this.description,
    required this.value,
  });
}

/// A set of radio buttons for selecting a single option from a list.
///
/// ```dart
/// NRadioGroup<String>(
///   items: [
///     NRadioItem(label: 'Option A', value: 'a'),
///     NRadioItem(label: 'Option B', value: 'b'),
///   ],
///   value: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class NRadioGroup<T extends Object> extends StatelessWidget {
  /// The list of radio items to display.
  final List<NRadioItem<T>> items;

  /// The currently selected value.
  final T? value;

  /// Called when the user selects a new value.
  final ValueChanged<T>? onChanged;

  /// An optional legend text displayed above the group.
  final String? legend;

  /// The size of each radio indicator. Defaults to [NRadioSize.md].
  final NRadioSize size;

  /// The semantic color role. Defaults to [NRadioColor.primary].
  final NRadioColor color;

  /// Whether the group is non-interactive. Defaults to false.
  final bool disabled;

  /// The layout orientation. Defaults to [Axis.vertical].
  final Axis orientation;

  /// Creates an [NRadioGroup].
  const NRadioGroup({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.legend,
    this.size = NRadioSize.md,
    this.color = NRadioColor.primary,
    this.disabled = false,
    this.orientation = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor());
    final radioSize = _getRadioSize();
    final dotSize = _getDotSize();
    final fontSize = _getFontSize();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (legend != null) ...[
          Text(
            legend!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: NTokens.textDefault(context),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Flex(
          direction: orientation,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) {
            final selected = item.value == value;
            return _NRadioItem<T>(
              item: item,
              selected: selected,
              onChanged: disabled ? null : onChanged,
              radioSize: radioSize,
              dotSize: dotSize,
              fontSize: fontSize,
              activeColor: c.main,
              borderColor: NTokens.borderDefault(context),
            );
          }).toList(),
        ),
      ],
    );
  }

  NComponentColor _componentColor() {
    return switch (color) {
      NRadioColor.primary => NComponentColor.primary,
      NRadioColor.secondary => NComponentColor.secondary,
      NRadioColor.success => NComponentColor.success,
      NRadioColor.warning => NComponentColor.warning,
      NRadioColor.error => NComponentColor.error,
      NRadioColor.info => NComponentColor.info,
      NRadioColor.neutral => NComponentColor.neutral,
    };
  }

  double _getRadioSize() {
    switch (size) {
      case NRadioSize.xs:
        return 16;
      case NRadioSize.sm:
        return 18;
      case NRadioSize.md:
        return 20;
      case NRadioSize.lg:
        return 22;
      case NRadioSize.xl:
        return 24;
    }
  }

  double _getDotSize() {
    switch (size) {
      case NRadioSize.xs:
        return 8;
      case NRadioSize.sm:
        return 10;
      case NRadioSize.md:
        return 12;
      case NRadioSize.lg:
        return 14;
      case NRadioSize.xl:
        return 16;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NRadioSize.xs:
      case NRadioSize.sm:
        return 13;
      case NRadioSize.md:
      case NRadioSize.lg:
        return 14;
      case NRadioSize.xl:
        return 16;
    }
  }
}

/// Internal radio item widget.
class _NRadioItem<T extends Object> extends StatelessWidget {
  final NRadioItem<T> item;
  final bool selected;
  final ValueChanged<T>? onChanged;
  final double radioSize;
  final double dotSize;
  final double fontSize;
  final Color activeColor;
  final Color borderColor;

  const _NRadioItem({
    required this.item,
    required this.selected,
    this.onChanged,
    required this.radioSize,
    required this.dotSize,
    required this.fontSize,
    required this.activeColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(item.value) : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              checked: selected,
              enabled: onChanged != null,
              child: Container(
                width: radioSize,
                height: radioSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: selected ? activeColor : borderColor,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: dotSize,
                          height: dotSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: NTokens.textDefault(context),
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: NTokens.textMuted(context),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
