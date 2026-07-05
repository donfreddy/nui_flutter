import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

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
/// Supports four [NVariant] styles, seven [NColorRole] semantic roles,
/// and five [NBadgeSize] options. Optional [leading] and [trailing] widgets,
/// an emoji prefix, a dot indicator, and a remove button are all composable.
///
/// Use named constructors for common patterns:
/// ```dart
/// NBadge.dot(label: 'Online', color: NColorRole.success)
/// NBadge.emoji(emoji: 'flame', label: 'Hot')
/// ```
class NBadge extends StatelessWidget {
  /// The text label displayed inside the badge.
  final String label;

  /// The semantic color role. Defaults to [NColorRole.primary].
  final NColorRole color;

  /// The visual style. Defaults to [NVariant.soft].
  final NVariant variant;

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
    this.color = NColorRole.primary,
    this.variant = NVariant.soft,
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
    NColorRole color = NColorRole.success,
    NVariant variant = NVariant.soft,
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
    NColorRole color = NColorRole.success,
    NBadgeSize size = NBadgeSize.md,
  }) : this(
          key: key,
          label: label,
          color: color,
          variant: NVariant.soft,
          size: size,
          dot: true,
        );

  @override
  Widget build(BuildContext context) {
    final resolved = NVariantResolver.resolve(color, variant, context.nui.colors);
    final borderRadius = square ? 0.0 : 6.0;

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: resolved.background,
        border: variant == NVariant.outline
            ? Border.all(color: resolved.border!, width: 1)
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
          if (dot) _buildDot(context, resolved.foreground),
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
              color: resolved.foreground,
              height: 1,
            ),
          ),
          if (trailing != null || onRemove != null) ...[
            const SizedBox(width: 4),
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close,
                    size: _getIconSize(), color: resolved.foreground),
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

  Widget _buildDot(BuildContext context, Color foregroundColor) {
    return Container(
      width: 6,
      height: 6,
      decoration:
          BoxDecoration(color: foregroundColor, shape: BoxShape.circle),
    );
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
