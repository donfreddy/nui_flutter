import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The visual style of an [NAlert].
enum NAlertVariant {
  /// Filled background using the alert color. The most visually prominent variant.
  solid,

  /// Transparent background with a colored border.
  outline,

  /// Lightly tinted background using a low-opacity version of the alert color.
  soft,

  /// Lightly tinted background with a colored border.
  subtle,
}

/// The semantic color role applied to an [NAlert].
enum NAlertColor {
  /// Uses the primary brand color.
  primary,

  /// Uses the secondary accent color.
  secondary,

  /// Uses the success color. Suitable for positive feedback messages.
  success,

  /// Uses the informational color. Suitable for neutral notices.
  info,

  /// Uses the warning color. Suitable for cautionary messages.
  warning,

  /// Uses the error color. Suitable for failure or destructive feedback.
  error,

  /// Uses a neutral color.
  neutral,
}

/// The layout orientation of an [NAlert]'s icon and content.
enum NAlertOrientation {
  /// Icon and text are arranged side by side in a row.
  horizontal,

  /// Icon and text are stacked in a column.
  vertical,
}

/// An inline alert banner for displaying contextual feedback.
///
/// Supports four [NAlertVariant] styles and seven [NAlertColor] semantic roles.
/// An icon, title, description, custom child, close button, and action widgets
/// can all be composed freely.
///
/// ```dart
/// NAlert(
///   color: NAlertColor.success,
///   variant: NAlertVariant.soft,
///   title: 'Payment sent',
///   description: 'Your transfer of 5 000 FCFA was processed successfully.',
/// )
/// ```
class NAlert extends StatelessWidget {
  /// The bold title text shown at the top of the alert.
  final String? title;

  /// A secondary description shown below [title].
  final String? description;

  /// A custom widget rendered below the title and description.
  ///
  /// Useful when you need more than simple text inside the alert body.
  final Widget? child;

  /// The semantic color role. Defaults to [NAlertColor.primary].
  final NAlertColor color;

  /// The visual style. Defaults to [NAlertVariant.solid].
  final NAlertVariant variant;

  /// The layout orientation of the icon relative to the content.
  /// Defaults to [NAlertOrientation.vertical].
  final NAlertOrientation orientation;

  /// A custom icon. When null a default icon matching [color] is used.
  final IconData? icon;

  /// When `true` (the default), the icon is rendered to the left of the content.
  final bool showIcon;

  /// When `true`, a close button is rendered at the trailing edge.
  /// Tapping it calls [onClose].
  final bool closable;

  /// When `true`, [description] text is center-aligned.
  final bool centerDesc;

  /// Called when the user taps the close button. Only relevant when [closable] is `true`.
  final VoidCallback? onClose;

  /// Optional action widgets (e.g., buttons) displayed at the bottom of the alert.
  final List<Widget>? actions;

  /// Creates an [NAlert].
  const NAlert({
    super.key,
    this.title,
    this.description,
    this.child,
    this.color = NAlertColor.primary,
    this.variant = NAlertVariant.solid,
    this.orientation = NAlertOrientation.vertical,
    this.icon,
    this.showIcon = true,
    this.closable = false,
    this.centerDesc = false,
    this.onClose,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final defaultIcon = _getDefaultIcon();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(8),
        border:
            variant == NAlertVariant.outline || variant == NAlertVariant.subtle
                ? Border.all(
                    color: colors['border']!,
                    width: variant == NAlertVariant.outline ? 1.5 : 1)
                : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(icon ?? defaultIcon, color: colors['icon'], size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors['text']),
                  ),
                if (description != null) ...[
                  if (title != null) const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                        fontSize: 13,
                        color: colors['text']!.withValues(alpha: 0.9)),
                    textAlign: centerDesc ? TextAlign.center : null,
                  ),
                ],
                if (child != null) ...[
                  if (title != null || description != null)
                    const SizedBox(height: 8),
                  DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 13,
                        color: colors['text']!.withValues(alpha: 0.9)),
                    child: child!,
                  ),
                ],
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: actions!),
                ],
              ],
            ),
          ),
          if (closable) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close,
                  size: 18, color: colors['text']!.withValues(alpha: 0.6)),
            ),
          ],
        ],
      ),
    );
  }

  NComponentColor get _componentColor => NComponentColor.values[color.index];

  Map<String, Color> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor);
    final baseColor = c.main;
    final softBg = baseColor.withValues(alpha: 0.1);
    final borderColor = baseColor.withValues(alpha: 0.3);
    final textColor = baseColor;

    switch (variant) {
      case NAlertVariant.solid:
        return {
          'background': baseColor,
          'border': baseColor,
          'text': NTokens.textInverted(context),
          'icon': NTokens.textInverted(context)
        };
      case NAlertVariant.outline:
        return {
          'background': Colors.transparent,
          'border': borderColor,
          'text': textColor,
          'icon': textColor
        };
      case NAlertVariant.soft:
        return {
          'background': softBg,
          'border': softBg,
          'text': textColor,
          'icon': textColor
        };
      case NAlertVariant.subtle:
        return {
          'background': softBg,
          'border': borderColor,
          'text': textColor,
          'icon': textColor
        };
    }
  }

  IconData _getDefaultIcon() {
    switch (color) {
      case NAlertColor.info:
        return Icons.info_outline;
      case NAlertColor.success:
        return Icons.check_circle_outline;
      case NAlertColor.warning:
        return Icons.warning_amber_outlined;
      case NAlertColor.error:
        return Icons.error_outline;
      case NAlertColor.primary:
        return Icons.lightbulb_outline;
      case NAlertColor.secondary:
        return Icons.stars_outlined;
      case NAlertColor.neutral:
        return Icons.info_outline;
    }
  }
}
