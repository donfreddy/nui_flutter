import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The visual style of an [NCard].
enum NCardVariant {
  /// White/surface background with a border.
  outline,

  /// Slightly elevated background with no border.
  soft,

  /// Elevated background with a border.
  subtle,

  /// Transparent background with no border, inheriting the parent surface.
  ghost,

  /// Completely transparent, no padding, no border.
  naked,
}

/// The semantic color role applied to an [NCard] when [NCard.color] is set.
enum NCardColor {
  /// Uses primary semantic tint tokens.
  primary,

  /// Uses neutral/secondary semantic tint tokens.
  neutral,

  /// Uses success semantic tint tokens.
  success,

  /// Uses error semantic tint tokens.
  error,

  /// Uses warning semantic tint tokens.
  warning,
}

/// A flexible card container with optional header, body, and footer slots.
///
/// Visual style is controlled by [variant] and the optional [color] role.
/// When [color] is provided the card uses semantic tinted backgrounds and
/// borders from [NTokens]; otherwise neutral surface colors are used.
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
  /// Defaults to `EdgeInsets.all(NTokens.paddingDefault)`.
  final EdgeInsetsGeometry? padding;

  /// Called when the card is tapped. Wraps the card in an [InkWell] when set.
  final VoidCallback? onTap;

  /// An optional widget rendered at the top of the card, separated by a divider
  /// (depending on [variant]).
  final Widget? header;

  /// An optional widget rendered at the bottom of the card, separated by a
  /// divider (depending on [variant]).
  final Widget? footer;

  /// The visual style of the card. Defaults to [NCardVariant.outline].
  final NCardVariant variant;

  /// An optional semantic color role that applies tinted backgrounds and borders.
  ///
  /// When `null`, neutral surface colors are used.
  final NCardColor? color;

  /// Overrides the card's corner radius. Defaults to [NTokens.radiusDefault].
  final BorderRadius? borderRadius;

  /// Creates an [NCard] with the default [NCardVariant.outline] style.
  const NCard({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
    this.variant = NCardVariant.outline,
    this.color,
    this.borderRadius,
  });

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
  }) : variant = NCardVariant.soft;

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
  }) : variant = NCardVariant.subtle;

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
  }) : variant = NCardVariant.ghost;

  /// Creates a naked card with no background, no padding, and no border.
  const NCard.naked({
    super.key,
    this.child,
    this.onTap,
    this.header,
    this.footer,
    this.color,
    this.borderRadius,
  })  : variant = NCardVariant.naked,
        padding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius =
        borderRadius ?? BorderRadius.circular(NTokens.radiusDefault);
    final styles = _getStyles(context);

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) ...[
          Padding(
            padding: padding ?? const EdgeInsets.all(NTokens.paddingDefault),
            child: DefaultTextStyle(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(
                  data: IconThemeData(color: styles.textColor), child: header!),
            ),
          ),
          if (styles.showDivider) _buildDivider(context),
        ],
        if (child != null)
          Padding(
            padding: padding ?? const EdgeInsets.all(NTokens.paddingDefault),
            child: DefaultTextStyle(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(
                  data: IconThemeData(color: styles.textColor), child: child!),
            ),
          ),
        if (footer != null) ...[
          if (styles.showDivider) _buildDivider(context),
          Padding(
            padding: padding ?? const EdgeInsets.all(NTokens.paddingDefault),
            child: DefaultTextStyle(
              style: TextStyle(color: styles.textColor),
              child: IconTheme(
                  data: IconThemeData(color: styles.textColor), child: footer!),
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
        child: InkWell(
            onTap: onTap, borderRadius: defaultBorderRadius, child: container),
      );
    }

    return container;
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
        height: 1, thickness: 1, color: NTokens.borderDefault(context));
  }

  _NCardStyles _getStyles(BuildContext context) {
    if (color != null) {
      return _coloredStyles(context);
    }
    return _defaultStyles(context);
  }

  NComponentColor _cardComponentColor() {
    return switch (color!) {
      NCardColor.primary => NComponentColor.primary,
      NCardColor.neutral => NComponentColor.neutral,
      NCardColor.success => NComponentColor.success,
      NCardColor.error => NComponentColor.error,
      NCardColor.warning => NComponentColor.warning,
    };
  }

  _NCardStyles _coloredStyles(BuildContext context) {
    final c = NComponentColors.resolve(context, _cardComponentColor(),
        neutralSoftBg: (ctx) => NTokens.secondaryBg(ctx),
        neutralBorder: (ctx) => NTokens.secondaryBorder(ctx),
        neutralText: (ctx) => NTokens.secondaryText(ctx));
    final bg = c.softBg;
    final border = c.border;
    final text = c.text;

    switch (variant) {
      case NCardVariant.outline:
        return _NCardStyles(
            backgroundColor: bg,
            textColor: text,
            border: Border.all(color: border, width: 1),
            showDivider: true);
      case NCardVariant.soft:
        return _NCardStyles(
            backgroundColor: bg,
            textColor: text,
            border: null,
            showDivider: true);
      case NCardVariant.subtle:
        return _NCardStyles(
            backgroundColor: bg,
            textColor: text,
            border: Border.all(color: border, width: 1),
            showDivider: true);
      case NCardVariant.ghost:
        return _NCardStyles(
            backgroundColor: Colors.transparent,
            textColor: text,
            border: null,
            showDivider: true);
      case NCardVariant.naked:
        return _NCardStyles(
            backgroundColor: Colors.transparent,
            textColor: text,
            border: null,
            showDivider: false);
    }
  }

  _NCardStyles _defaultStyles(BuildContext context) {
    switch (variant) {
      case NCardVariant.outline:
        return _NCardStyles(
          backgroundColor: NTokens.bgDefault(context),
          textColor: NTokens.textDefault(context),
          border: Border.all(color: NTokens.borderDefault(context), width: 1),
          showDivider: true,
        );
      case NCardVariant.soft:
        return _NCardStyles(
          backgroundColor: NTokens.bgElevated(context),
          textColor: NTokens.textDefault(context),
          border: null,
          showDivider: true,
        );
      case NCardVariant.subtle:
        return _NCardStyles(
          backgroundColor: NTokens.bgElevated(context),
          textColor: NTokens.textDefault(context),
          border: Border.all(color: NTokens.borderDefault(context), width: 1),
          showDivider: true,
        );
      case NCardVariant.ghost:
        return _NCardStyles(
          backgroundColor: Colors.transparent,
          textColor: NTokens.textDefault(context),
          border: null,
          showDivider: true,
        );
      case NCardVariant.naked:
        return _NCardStyles(
          backgroundColor: Colors.transparent,
          textColor: NTokens.textDefault(context),
          border: null,
          showDivider: false,
        );
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
                Text(title!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: NTokens.textMuted(context))),
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
      children: actions
          .map((action) =>
              Padding(padding: const EdgeInsets.only(left: 8), child: action))
          .toList(),
    );
  }
}
