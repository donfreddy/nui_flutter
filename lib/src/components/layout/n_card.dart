import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// A flexible card container with optional header, body, and footer slots.
///
/// Visual style is controlled by [variant] and the optional [color] role.
/// When [color] is provided the card uses semantic tinted backgrounds and
/// borders from [NTokens]; otherwise neutral surface colors are used.
/// Set [naked] to `true` to remove padding, background, borders, and dividers.
///
/// ```dart
/// NCard(
///   header: NCardHeader(title: 'Balance', subtitle: 'Available funds'),
///   child: Text('5 000 FCFA'),
///   footer: NCardFooter(actions: [NButton(label: 'Send', onPressed: () {})]),
/// )
/// ```
class NCard extends StatelessWidget {
  /// The main body content of the card.
  final Widget? child;

  /// Inner padding applied to [header], [child], and [footer] sections.
  ///
  /// Defaults to `EdgeInsets.all(16.0)`.
  final EdgeInsetsGeometry? padding;

  /// Called when the card is tapped. Wraps the card in an [InkWell] when set.
  final VoidCallback? onTap;

  /// An optional widget rendered at the top of the card, separated by a divider
  /// (depending on [variant]).
  final Widget? header;

  /// An optional widget rendered at the bottom of the card, separated by a
  /// divider (depending on [variant]).
  final Widget? footer;

  /// The visual style of the card. Defaults to [NVariant.outline].
  final NVariant variant;

  /// An optional semantic color role that applies tinted backgrounds and borders.
  ///
  /// When `null`, neutral surface colors are used.
  final NColorRole? color;

  /// Overrides the card's corner radius.
  final BorderRadius? borderRadius;

  /// When `true`, removes padding, background, borders, and section dividers.
  final bool naked;

  /// Creates an [NCard] with the default [NVariant.outline] style.
  const NCard({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
    this.variant = NVariant.outline,
    this.color,
    this.borderRadius,
    this.naked = false,
  });

  /// Creates a solid-variant card with an inverted background.
  const NCard.solid({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  }) : variant = NVariant.solid, naked = false;

  /// Creates a soft-variant card with an elevated background and no border.
  const NCard.soft({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  }) : variant = NVariant.soft, naked = false;

  /// Creates a subtle-variant card with an elevated background and a border.
  const NCard.subtle({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  }) : variant = NVariant.subtle, naked = false;

  /// Creates a ghost-variant card with a transparent background and no border.
  const NCard.ghost({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  }) : variant = NVariant.ghost, naked = false;

  /// Creates a card with no background, no padding, no border, and no dividers.
  const NCard.naked({
    super.key,
    this.child,
    this.onTap,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  }) : variant = NVariant.ghost, naked = true, padding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(8.0);
    final styles = _getStyles(context);
    final effectivePadding = naked
        ? EdgeInsets.zero
        : (padding ?? const EdgeInsets.all(16.0));

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) ...[
          Padding(
            padding: effectivePadding,
            child: DefaultTextStyle(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(data: IconThemeData(color: styles.textColor), child: header!),
            ),
          ),
          if (styles.showDivider) _buildDivider(context),
        ],
        if (child != null)
          Padding(
            padding: effectivePadding,
            child: DefaultTextStyle(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(data: IconThemeData(color: styles.textColor), child: child!),
            ),
          ),
        if (footer != null) ...[
          if (styles.showDivider) _buildDivider(context),
          Padding(
            padding: effectivePadding,
            child: DefaultTextStyle(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(data: IconThemeData(color: styles.textColor), child: footer!),
            ),
          ),
        ],
      ],
    );

    final container = Container(
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        borderRadius: defaultBorderRadius,
        border: styles.border,
      ),
      child: cardContent,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, borderRadius: defaultBorderRadius, child: container),
      );
    }

    return container;
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: context.nui.colors.border);
  }

  _NCardStyles _getStyles(BuildContext context) {
    final resolved = color != null
        ? NVariantResolver.resolve(color!, variant, context.nui.colors)
        : _surfaceResolved(context.nui.colors, variant);
    return _NCardStyles(
      backgroundColor:
          naked ? Colors.transparent : (resolved.background ?? Colors.transparent),
      textColor: resolved.foreground,
      border: naked
          ? null
          : (resolved.border != null
              ? Border.all(color: resolved.border!, width: 1)
              : null),
      showDivider: !naked,
    );
  }

  static NResolvedColors _surfaceResolved(NColors colors, NVariant variant) {
    switch (variant) {
      case NVariant.solid:
        return NResolvedColors(
          foreground: colors.textInverted,
          background: colors.bgInverted,
        );
      case NVariant.outline:
        return NResolvedColors(
          foreground: colors.text,
          background: colors.bg,
          border: colors.border,
        );
      case NVariant.soft:
        return NResolvedColors(
          foreground: colors.text,
          background: colors.bgElevated.withValues(alpha: 0.5),
        );
      case NVariant.subtle:
        return NResolvedColors(
          foreground: colors.text,
          background: colors.bgElevated.withValues(alpha: 0.5),
          border: colors.border,
        );
      case NVariant.ghost:
        return NResolvedColors(foreground: colors.text);
      case NVariant.link:
        return NResolvedColors(foreground: colors.text);
    }
  }
}

class _NCardStyles {
  final Color backgroundColor;
  final Color textColor;
  final Border? border;
  final bool showDivider;
  _NCardStyles({
    required this.backgroundColor,
    required this.textColor,
    this.border,
    required this.showDivider,
  });
}

/// A pre-built header row with an optional leading widget, title, subtitle,
/// and trailing widget.
///
/// Intended for use with [NCard.header].
class NCardHeader extends StatelessWidget {
  /// An optional widget placed before the title (e.g., an [NAvatar]).
  final Widget? leading;

  /// The primary title text.
  final String? title;

  /// An optional subtitle rendered below [title] in a smaller, muted style.
  final String? subtitle;

  /// An optional widget placed at the trailing edge of the header row.
  final Widget? trailing;

  /// Creates an [NCardHeader].
  const NCardHeader({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(title!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.nui.colors.textMuted)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}

/// A pre-built footer row that lays out [actions] along a horizontal axis.
///
/// Intended for use with [NCard.footer].
class NCardFooter extends StatelessWidget {
  /// The action widgets to display (e.g., [NButton] instances).
  final List<Widget> actions;

  /// How the actions are aligned along the main axis.
  /// Defaults to [MainAxisAlignment.end].
  final MainAxisAlignment alignment;

  const NCardFooter({
    super.key,
    required this.actions,
    this.alignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: actions.map((action) => Padding(padding: const EdgeInsets.only(left: 8), child: action)).toList(),
    );
  }
}
