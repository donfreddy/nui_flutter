import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The semantic color role applied to an [NBadge].
enum NBadgeColor {
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

/// The visual style of an [NBadge].
enum NBadgeVariant {
  /// Filled background using the badge color. The most prominent variant.
  solid,

  /// Lightly tinted background using a low-opacity version of the badge color.
  soft,

  /// Transparent background with a colored border.
  outline,

  /// Neutral muted background regardless of the chosen color.
  subtle,
}

/// The size of an [NBadge], controlling padding, font size, and icon size.
enum NBadgeSize {
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

/// A compact label used to display status, categories, or counts.
///
/// Supports four [NBadgeVariant] styles, seven [NBadgeColor] semantic roles,
/// and five [NBadgeSize] options. Optional [leading] and [trailing] widgets,
/// an emoji prefix, a dot indicator, and a remove button are all composable.
///
/// Use named constructors for common patterns:
/// ```dart
/// NBadge.dot(label: 'Online', color: NBadgeColor.success)
/// NBadge.emoji(emoji: 'flame', label: 'Hot')
/// ```
class NBadge extends StatelessWidget {
  /// The text label displayed inside the badge.
  final String label;

  /// The semantic color role. Defaults to [NBadgeColor.primary].
  final NBadgeColor color;

  /// The visual style. Defaults to [NBadgeVariant.soft].
  final NBadgeVariant variant;

  /// The size of the badge. Defaults to [NBadgeSize.md].
  final NBadgeSize size;

  /// An optional widget placed before the label (e.g., an icon).
  final Widget? leading;

  /// An optional widget placed after the label.
  final Widget? trailing;

  /// An emoji character displayed before [label]. Use [NBadge.emoji] for convenience.
  final String? emoji;

  /// When `true`, a small filled dot is rendered before [label].
  /// Use [NBadge.dot] for convenience.
  final bool dot;

  /// Called when the user taps the remove (X) button.
  /// When set, a close icon replaces [trailing].
  final VoidCallback? onRemove;

  /// When `true`, the badge uses square corners instead of rounded ones.
  final bool square;

  /// Creates an [NBadge].
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

  /// Creates an emoji-prefixed badge.
  ///
  /// Shorthand for `NBadge(emoji: ..., label: ..., ...)`.
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

  /// Creates a dot-indicator badge.
  ///
  /// Shorthand for `NBadge(dot: true, label: ..., ...)`.
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
            const SizedBox(width: 4),
          ],
          if (dot) _buildDot(context, colors),
          if (dot) const SizedBox(width: 4),
          if (leading != null) ...[
            SizedBox(
                width: _getIconSize(), height: _getIconSize(), child: leading),
            const SizedBox(width: 4),
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
            const SizedBox(width: 4),
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
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case NBadgeSize.sm:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
      case NBadgeSize.md:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
      case NBadgeSize.lg:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 5);
      case NBadgeSize.xl:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 6);
    }
  }
}
