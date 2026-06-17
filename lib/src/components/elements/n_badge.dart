import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NBadgeColor { primary, secondary, success, info, warning, error, neutral }

enum NBadgeVariant { solid, soft, outline, subtle }

enum NBadgeSize { xs, sm, md, lg, xl }

class NBadge extends StatelessWidget {
  final String label;
  final NBadgeColor color;
  final NBadgeVariant variant;
  final NBadgeSize size;
  final Widget? leading;
  final Widget? trailing;
  final String? emoji;
  final bool dot;
  final VoidCallback? onRemove;
  final bool square;

  const NBadge({
    super.key,
    required this.label,
    this.color = NBadgeColor.primary,
    this.variant = NBadgeVariant.soft,
    this.size = NBadgeSize.md,
    this.leading,
    this.trailing,
    this.emoji,
    this.dot = false,
    this.onRemove,
    this.square = false,
  });

  const NBadge.emoji({
    Key? key,
    required String emoji,
    required String label,
    NBadgeColor color = NBadgeColor.success,
    NBadgeVariant variant = NBadgeVariant.soft,
    NBadgeSize size = NBadgeSize.md,
  }) : this(
          key: key,
          label: label,
          emoji: emoji,
          color: color,
          variant: variant,
          size: size,
        );

  const NBadge.dot({
    Key? key,
    required String label,
    NBadgeColor color = NBadgeColor.success,
    NBadgeSize size = NBadgeSize.md,
  }) : this(
          key: key,
          label: label,
          color: color,
          variant: NBadgeVariant.soft,
          size: size,
          dot: true,
        );

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final borderRadius = square ? 0.0 : 6.0;

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: colors['background'],
        border: variant == NBadgeVariant.outline
            ? Border.all(color: colors['border']!, width: 1)
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: TextStyle(fontSize: _getFontSize() + 2)),
            SizedBox(width: 4),
          ],
          if (dot) _buildDot(context, colors),
          if (dot) SizedBox(width: 4),
          if (leading != null) ...[
            SizedBox(
                width: _getIconSize(), height: _getIconSize(), child: leading),
            SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
              color: colors['foreground'],
              height: 1,
            ),
          ),
          if (trailing != null || onRemove != null) ...[
            SizedBox(width: 4),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close,
                    size: _getIconSize(), color: colors['foreground']),
              )
            else
              SizedBox(
                  width: _getIconSize(),
                  height: _getIconSize(),
                  child: trailing),
          ],
        ],
      ),
    );
  }

  Widget _buildDot(BuildContext context, Map<String, Color> colors) {
    return Container(
      width: 6,
      height: 6,
      decoration:
          BoxDecoration(color: colors['foreground'], shape: BoxShape.circle),
    );
  }

  NComponentColor get _componentColor =>
      NComponentColor.values[color.index];

  Map<String, Color> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor);
    final semanticColor = c.main;

    switch (variant) {
      case NBadgeVariant.solid:
        return {
          'background': semanticColor,
          'foreground': NTokens.textInverted(context),
          'border': semanticColor
        };
      case NBadgeVariant.soft:
        return {
          'background': semanticColor.withValues(alpha: 0.15),
          'foreground': semanticColor,
          'border': semanticColor.withValues(alpha: 0.3)
        };
      case NBadgeVariant.outline:
        return {
          'background': Colors.transparent,
          'foreground': semanticColor,
          'border': semanticColor.withValues(alpha: 0.5)
        };
      case NBadgeVariant.subtle:
        return {
          'background': NTokens.bgMuted(context),
          'foreground': NTokens.textMuted(context),
          'border': NTokens.borderMuted(context)
        };
    }
  }

  double _getFontSize() {
    switch (size) {
      case NBadgeSize.xs:
        return 10;
      case NBadgeSize.sm:
        return 11;
      case NBadgeSize.md:
        return 12;
      case NBadgeSize.lg:
        return 13;
      case NBadgeSize.xl:
        return 14;
    }
  }

  double _getIconSize() {
    switch (size) {
      case NBadgeSize.xs:
        return 10;
      case NBadgeSize.sm:
        return 12;
      case NBadgeSize.md:
        return 14;
      case NBadgeSize.lg:
        return 16;
      case NBadgeSize.xl:
        return 18;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case NBadgeSize.xs:
        return EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case NBadgeSize.sm:
        return EdgeInsets.symmetric(horizontal: 8, vertical: 3);
      case NBadgeSize.md:
        return EdgeInsets.symmetric(horizontal: 10, vertical: 4);
      case NBadgeSize.lg:
        return EdgeInsets.symmetric(horizontal: 12, vertical: 5);
      case NBadgeSize.xl:
        return EdgeInsets.symmetric(horizontal: 14, vertical: 6);
    }
  }
}
