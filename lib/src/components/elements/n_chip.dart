import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The semantic color role applied to an [NChip] in the selected state.
enum NChipColor {
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

  /// Uses a neutral muted color.
  neutral,
}

/// The visual style of an [NChip].
enum NChipVariant {
  /// Selected chip gets a fully filled background using the chip color.
  solid,

  /// Selected chip gets a lightly tinted background.
  soft,

  /// Selected chip uses a transparent background with a colored border.
  outline,
}

/// The size of an [NChip], controlling padding and font size.
enum NChipSize {
  /// Small.
  sm,

  /// Medium. The default size.
  md,

  /// Large.
  lg,
}

/// A selectable filter chip that toggles between a selected and unselected state.
///
/// Supports three [NChipVariant] styles, seven [NChipColor] semantic roles,
/// and three [NChipSize] options. Optional [leading] and [trailing] widgets
/// can be added to the chip row.
///
/// Group multiple chips together using [NChipGroup].
///
/// ```dart
/// NChip(
///   label: 'Mobile Money',
///   selected: _filter == 'momo',
///   onTap: () => setState(() => _filter = 'momo'),
/// )
/// ```
class NChip extends StatelessWidget {
  /// The text label displayed inside the chip.
  final String label;

  /// Whether this chip is currently in the selected (active) state.
  final bool selected;

  /// Called when the user taps the chip.
  final VoidCallback? onTap;

  /// The semantic color role used for the selected state.
  /// Defaults to [NChipColor.primary].
  final NChipColor color;

  /// The visual style. Defaults to [NChipVariant.soft].
  final NChipVariant variant;

  /// The size of the chip. Defaults to [NChipSize.md].
  final NChipSize size;

  /// An optional widget placed before the label (e.g., an icon).
  final Widget? leading;

  /// An optional widget placed after the label.
  final Widget? trailing;

  /// Creates an [NChip].
  const NChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.color = NChipColor.primary,
    this.variant = NChipVariant.soft,
    this.size = NChipSize.md,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: _getPadding(),
          decoration: BoxDecoration(
            color: colors['background'],
            borderRadius: BorderRadius.circular(size == NChipSize.sm ? 16 : 20),
            border: Border.all(color: colors['border']!, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                SizedBox(
                    width: _getIconSize(),
                    height: _getIconSize(),
                    child: leading),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: _getFontSize(),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: colors['foreground'],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                SizedBox(
                    width: _getIconSize(),
                    height: _getIconSize(),
                    child: trailing),
              ],
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case NChipSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case NChipSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case NChipSize.lg:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    }
  }

  double _getFontSize() {
    switch (size) {
      case NChipSize.sm:
        return 12;
      case NChipSize.md:
        return 13;
      case NChipSize.lg:
        return 14;
    }
  }

  double _getIconSize() {
    switch (size) {
      case NChipSize.sm:
        return 14;
      case NChipSize.md:
        return 16;
      case NChipSize.lg:
        return 18;
    }
  }

  NComponentColor get _componentColor => NComponentColor.values[color.index];

  Map<String, Color> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor);
    final semanticColor = c.main;

    switch (variant) {
      case NChipVariant.solid:
        if (selected) {
          return {
            'background': semanticColor,
            'foreground': NTokens.textInverted(context),
            'border': semanticColor
          };
        }
        return {
          'background': NTokens.bgMuted(context),
          'foreground': NTokens.textMuted(context),
          'border': NTokens.borderDefault(context)
        };
      case NChipVariant.soft:
        if (selected) {
          return {
            'background': semanticColor.withValues(alpha: 0.15),
            'foreground': semanticColor,
            'border': semanticColor.withValues(alpha: 0.3)
          };
        }
        return {
          'background': NTokens.bgMuted(context),
          'foreground': NTokens.textMuted(context),
          'border': NTokens.borderDefault(context)
        };
      case NChipVariant.outline:
        if (selected) {
          return {
            'background': Colors.transparent,
            'foreground': semanticColor,
            'border': semanticColor
          };
        }
        return {
          'background': Colors.transparent,
          'foreground': NTokens.textMuted(context),
          'border': NTokens.borderDefault(context)
        };
    }
  }
}

/// A managed group of [NChip] widgets that enforces a single selection.
///
/// Supply [items], the current [selectedValue], and an [onChanged] callback.
/// The group can be scrollable or wrap depending on [scrollable] and [direction].
///
/// ```dart
/// NChipGroup(
///   items: [
///     NChipItem(label: 'All', value: 'all'),
///     NChipItem(label: 'Sent', value: 'sent'),
///     NChipItem(label: 'Received', value: 'received'),
///   ],
///   selectedValue: _filter,
///   onChanged: (v) => setState(() => _filter = v),
/// )
/// ```
class NChipGroup extends StatelessWidget {
  /// The list of chip descriptors to display.
  final List<NChipItem> items;

  /// The value of the currently selected chip.
  final String selectedValue;

  /// Called when the user selects a different chip, passing the new value.
  final ValueChanged<String> onChanged;

  /// The visual style applied to every chip. Defaults to [NChipVariant.solid].
  final NChipVariant variant;

  /// The size applied to every chip. Defaults to [NChipSize.sm].
  final NChipSize size;

  /// When `true` (the default), chips overflow into a scroll view along [direction].
  /// When `false`, chips wrap using a [Wrap] widget.
  final bool scrollable;

  /// The scroll or layout direction. Defaults to [Axis.horizontal].
  final Axis direction;

  /// How chips are aligned in the main axis when not scrollable.
  final MainAxisAlignment mainAxisAlignment;

  /// How chips are aligned in the wrap when [scrollable] is `false`.
  final WrapAlignment wrapAlignment;

  /// Gap between chips along the main axis. Defaults to 8 dp.
  final double spacing;

  /// Gap between chip rows in wrap mode. Defaults to 8 dp.
  final double runSpacing;

  /// Creates an [NChipGroup].
  const NChipGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.variant = NChipVariant.solid,
    this.size = NChipSize.sm,
    this.scrollable = true,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.wrapAlignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final chips = items
        .map((item) => NChip(
              label: item.label,
              selected: selectedValue == item.value,
              onTap: () => onChanged(item.value),
              variant: variant,
              size: size,
              leading: item.leading,
              trailing: item.trailing,
            ))
        .toList();

    if (scrollable && direction == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: _buildChipsWithSpacing(chips, spacing),
        ),
      );
    } else if (scrollable && direction == Axis.vertical) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: _buildChipsWithSpacing(chips, spacing),
        ),
      );
    } else {
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: wrapAlignment,
        children: chips,
      );
    }
  }

  List<Widget> _buildChipsWithSpacing(List<Widget> chips, double spacing) {
    final result = <Widget>[];
    for (var i = 0; i < chips.length; i++) {
      result.add(chips[i]);
      if (i < chips.length - 1) {
        result.add(SizedBox(
          width: direction == Axis.horizontal ? spacing : 0,
          height: direction == Axis.vertical ? spacing : 0,
        ));
      }
    }
    return result;
  }
}

/// A data descriptor for a single chip inside [NChipGroup].
class NChipItem {
  /// The text label displayed on the chip.
  final String label;

  /// The unique value emitted by [NChipGroup.onChanged] when this chip is selected.
  final String value;

  /// An optional widget placed before [label].
  final Widget? leading;

  /// An optional widget placed after [label].
  final Widget? trailing;

  /// Creates an [NChipItem].
  const NChipItem({
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
  });
}
