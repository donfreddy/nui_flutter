import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// A flexible card container with optional header, body, and footer slots.
///
/// Mirrors Nuxt UI's `UCard`: pass [title] and/or [description] for the
/// common case, or a fully custom [header] widget when you need a leading
/// icon, avatar, or trailing action. Visual style is controlled by [variant]
/// ([NVariant.outline] by default) and the optional [color] role; when
/// [color] is `null`, neutral surface colors are used. Set [naked] to `true`
/// to remove padding, background, borders, and dividers entirely.
///
/// ```dart
/// NCard(
///   title: 'Balance',
///   description: 'Available funds',
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

  /// Shorthand title rendered in the header when [header] is not provided.
  final String? title;

  /// Shorthand description rendered below [title] when [header] is not provided.
  final String? description;

  /// An optional widget rendered at the top of the card, separated by a divider.
  ///
  /// Takes precedence over [title] / [description] when provided.
  final Widget? header;

  /// An optional widget rendered at the bottom of the card, separated by a
  /// divider.
  final Widget? footer;

  /// The visual style of the card. Defaults to [NVariant.outline].
  ///
  /// Supports [NVariant.outline], [NVariant.solid], [NVariant.soft], and
  /// [NVariant.subtle] (see [NVariantSupport.card]).
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
    this.title,
    this.description,
    this.header,
    this.footer,
    this.variant = NVariant.outline,
    this.color,
    this.borderRadius,
    this.naked = false,
  }) : assert(
          variant != NVariant.ghost && variant != NVariant.link,
          'NCard supports outline, solid, soft, and subtle only.',
        );

  /// Creates a solid-variant card with an inverted background.
  const NCard.solid({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  })  : variant = NVariant.solid,
        naked = false;

  /// Creates a soft-variant card with an elevated background and no border.
  const NCard.soft({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  })  : variant = NVariant.soft,
        naked = false;

  /// Creates a subtle-variant card with an elevated background and a border.
  const NCard.subtle({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  })  : variant = NVariant.subtle,
        naked = false;

  /// Creates a card with no background, no padding, no border, and no dividers.
  const NCard.naked({
    super.key,
    this.child,
    this.onTap,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  })  : variant = NVariant.outline,
        naked = true,
        padding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    final colors = context.nui.colors;
    final cardTheme = Theme.of(context).extension<NCardTheme>();
    final defaultBorderRadius = borderRadius ?? cardTheme?.borderRadius ?? context.nui.radius.radiusLg;
    final styles = _getStyles(context);
    final effectivePadding =
        naked ? EdgeInsets.zero : (padding ?? cardTheme?.padding ?? EdgeInsets.all(context.nui.spacing.s4));

    final shape = RoundedRectangleBorder(
      borderRadius: defaultBorderRadius,
      side: styles.border ?? BorderSide.none,
    );

    final effectiveHeader = header ?? _buildTitleDescription(context);
    final sections = [effectiveHeader, child, footer].whereType<Widget>().toList();

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0 && styles.showDivider) _buildDivider(context),
          Padding(
            padding: effectivePadding,
            child: DefaultTextStyle.merge(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(data: IconThemeData(color: styles.textColor), child: sections[i]),
            ),
          ),
        ],
      ],
    );

    if (onTap != null) {
      return Material(
        color: styles.backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          splashColor: colors.primary.withValues(alpha: 0.02),
          highlightColor: colors.primary.withValues(alpha: 0.01),
          child: cardContent,
        ),
      );
    }

    return Material(
      color: styles.backgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: shape,
      child: cardContent,
    );
  }

  /// Builds a shorthand header from [title] / [description] when no custom
  /// [header] widget was provided.
  Widget? _buildTitleDescription(BuildContext context) {
    if (title == null && description == null) return null;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        if (description != null) ...[
          if (title != null) SizedBox(height: context.nui.spacing.s1),
          Text(description!, style: textTheme.bodySmall?.copyWith(color: context.nui.colors.textMuted)),
        ],
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: context.nui.colors.border);
  }

  _NCardStyles _getStyles(BuildContext context) {
    final colors = context.nui.colors;
    final resolved = color != null ? NVariantResolver.resolve(color!, variant, colors) : _surfaceResolved(colors, variant);
    // NVariantResolver leaves `outline` transparent (right for buttons/badges
    // sitting on an existing surface), but a card is the surface itself, so
    // it always needs an opaque fill, tinted or not.
    final background = variant == NVariant.outline ? (resolved.background ?? colors.bg) : resolved.background;
    return _NCardStyles(
      backgroundColor: naked ? Colors.transparent : (background ?? Colors.transparent),
      textColor: resolved.foreground,
      border: naked ? null : (resolved.border != null ? BorderSide(color: resolved.border!, width: 1) : null),
      // Nuxt UI's `solid` variant has no `divide-y` between sections; only
      // outline/soft/subtle separate header/body/footer with a divider.
      showDivider: !naked && variant != NVariant.solid,
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
  final BorderSide? border;
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
