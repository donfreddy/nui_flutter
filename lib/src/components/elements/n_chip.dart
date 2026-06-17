import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NChipColor { primary, secondary, success, info, warning, error, neutral }

enum NChipVariant { solid, soft, outline }

enum NChipSize { sm, md, lg }

class NChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final NChipColor color;
  final NChipVariant variant;
  final NChipSize size;
  final Widget? leading;
  final Widget? trailing;

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
            borderRadius:
                BorderRadius.circular(size == NChipSize.sm ? 16 : 20),
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
                SizedBox(width: 6),
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
                SizedBox(width: 6),
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
        return EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case NChipSize.md:
        return EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case NChipSize.lg:
        return EdgeInsets.symmetric(horizontal: 20, vertical: 10);
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

  NComponentColor get _componentColor =>
      NComponentColor.values[color.index];

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

class NChipGroup extends StatelessWidget {
  final List<NChipItem> items;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final NChipVariant variant;
  final NChipSize size;
  final bool scrollable;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final WrapAlignment wrapAlignment;
  final double spacing;
  final double runSpacing;

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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: _buildChipsWithSpacing(chips, spacing),
        ),
      );
    } else if (scrollable && direction == Axis.vertical) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 16),
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

class NChipItem {
  final String label;
  final String value;
  final Widget? leading;
  final Widget? trailing;

  const NChipItem({
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
  });
}
