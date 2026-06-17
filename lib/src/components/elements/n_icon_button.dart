import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NIconButtonVariant { solid, soft, outline, ghost }

enum NIconButtonColor {
  primary,
  secondary,
  success,
  info,
  warning,
  error,
  neutral
}

enum NIconButtonSize { sm, md, lg }

class NIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final NIconButtonVariant variant;
  final NIconButtonColor color;
  final NIconButtonSize size;
  final bool disabled;
  final String? tooltip;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const NIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = NIconButtonVariant.soft,
    this.color = NIconButtonColor.neutral,
    this.size = NIconButtonSize.md,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  });

  const NIconButton.sm({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = NIconButtonVariant.soft,
    this.color = NIconButtonColor.neutral,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  }) : size = NIconButtonSize.sm;

  const NIconButton.lg({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = NIconButtonVariant.soft,
    this.color = NIconButtonColor.neutral,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  }) : size = NIconButtonSize.lg;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final iconSize = _getIconSize();
    final pad = padding ?? _getPadding();
    final radius = borderRadius ?? _getBorderRadius();

    final resolvedIconColor = iconColor ?? colors['foreground'];
    final resolvedBg = backgroundColor ?? colors['background'];
    final resolvedBorder = borderColor ?? colors['border'];

    final button = Material(
      color: resolvedBg,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: pad,
          decoration: BoxDecoration(
            border: resolvedBorder != null
                ? Border.all(color: resolvedBorder, width: 1)
                : null,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Semantics(
            button: true,
            enabled: !disabled,
            child: Icon(
              icon,
              color: disabled
                  ? resolvedIconColor?.withValues(alpha: 0.5)
                  : resolvedIconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  NComponentColor get _componentColor =>
      NComponentColor.values[color.index];

  Map<String, Color?> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor,
        neutralMain: (ctx) => NTokens.textMuted(ctx));
    final semanticColor = c.main;

    switch (variant) {
      case NIconButtonVariant.solid:
        return {
          'background': semanticColor,
          'foreground': NTokens.textInverted(context),
          'border': null
        };
      case NIconButtonVariant.soft:
        return {
          'background': semanticColor.withValues(alpha: 0.1),
          'foreground': semanticColor,
          'border': null
        };
      case NIconButtonVariant.outline:
        return {
          'background': Colors.transparent,
          'foreground': semanticColor,
          'border': semanticColor.withValues(alpha: 0.3)
        };
      case NIconButtonVariant.ghost:
        return {
          'background': Colors.transparent,
          'foreground': semanticColor,
          'border': null
        };
    }
  }

  double _getIconSize() {
    switch (size) {
      case NIconButtonSize.sm:
        return 16;
      case NIconButtonSize.md:
        return 20;
      case NIconButtonSize.lg:
        return 24;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case NIconButtonSize.sm:
        return EdgeInsets.all(8);
      case NIconButtonSize.md:
        return EdgeInsets.all(10);
      case NIconButtonSize.lg:
        return EdgeInsets.all(12);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case NIconButtonSize.sm:
        return 8;
      case NIconButtonSize.md:
        return 10;
      case NIconButtonSize.lg:
        return 12;
    }
  }
}
