import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// The layout orientation of an [NAlert]'s icon and content.
enum NAlertOrientation {
  /// Icon and text are arranged side by side in a row.
  horizontal,

  /// Icon and text are stacked in a column.
  vertical,
}

/// An inline alert banner for displaying contextual feedback.
///
/// Supports four [NVariant] styles and seven [NColorRole] semantic roles.
/// An icon, title, description, custom child, close button, and action widgets
/// can all be composed freely.
///
/// ```dart
/// NAlert(
///   color: NColorRole.success,
///   variant: NVariant.soft,
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

  /// The semantic color role. Defaults to [NColorRole.primary].
  final NColorRole color;

  /// The visual style. Defaults to [NVariant.solid].
  final NVariant variant;

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
    this.color = NColorRole.primary,
    this.variant = NVariant.solid,
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
    final resolved = NVariantResolver.resolve(color, variant, context.nui.colors);
    final defaultIcon = _getDefaultIcon();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: resolved.background,
        borderRadius: context.nui.radius.radiusMd,
        border:
            variant == NVariant.outline || variant == NVariant.subtle
                ? Border.all(
                    color: resolved.border!,
                    width: variant == NVariant.outline ? 1.5 : 1)
                : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(icon ?? defaultIcon, color: resolved.foreground, size: 20),
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
                        color: resolved.foreground),
                  ),
                if (description != null) ...[
                  if (title != null) const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                        fontSize: 13,
                        color: resolved.foreground.withValues(alpha: 0.9)),
                    textAlign: centerDesc ? TextAlign.center : null,
                  ),
                ],
                if (child != null) ...[
                  if (title != null || description != null)
                    const SizedBox(height: 8),
                  DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 13,
                        color: resolved.foreground.withValues(alpha: 0.9)),
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
                  size: 18, color: resolved.foreground.withValues(alpha: 0.6)),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getDefaultIcon() {
    switch (color) {
      case NColorRole.info:
        return Icons.info_outline;
      case NColorRole.success:
        return Icons.check_circle_outline;
      case NColorRole.warning:
        return Icons.warning_amber_outlined;
      case NColorRole.error:
        return Icons.error_outline;
      case NColorRole.primary:
        return Icons.lightbulb_outline;
      case NColorRole.secondary:
        return Icons.stars_outlined;
      case NColorRole.neutral:
        return Icons.info_outline;
    }
  }
}
