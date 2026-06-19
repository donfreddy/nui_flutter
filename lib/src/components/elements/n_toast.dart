import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';
import '../../theme/n_spacing.dart';

/// The semantic color role applied to an [NToast].
enum NToastColor {
  /// Uses the primary brand color.
  primary,

  /// Uses the success color. Suitable for positive feedback.
  success,

  /// Uses the warning color. Suitable for cautionary messages.
  warning,

  /// Uses the error color. Suitable for failure or destructive feedback.
  error,

  /// Uses the info color. Suitable for neutral notices.
  info,

  /// Uses a neutral surface color.
  neutral,
}

/// The layout orientation of an [NToast] icon and message content.
enum NToastOrientation {
  /// Icon and message are arranged side by side in a row.
  horizontal,

  /// Icon and message are stacked in a column.
  vertical,
}

/// A succinct message that provides information or feedback to the user.
///
/// Display [NToast] by calling [NToast.show] with a [BuildContext]. The toast
/// appears as an overlay at the bottom of the screen and auto-dismisses after
/// a configurable duration.
///
/// ```dart
/// NToast.show(
///   context,
///   title: 'Payment sent',
///   description: 'Your transfer was successful.',
///   color: NToastColor.success,
/// )
/// ```
class NToast extends StatelessWidget {
  /// The bold title text shown in the toast.
  final String? title;

  /// A secondary description shown below [title].
  final String? description;

  /// An optional icon displayed before the text.
  final IconData? icon;

  /// The semantic color role. Defaults to [NToastColor.primary].
  final NToastColor color;

  /// The layout orientation of the icon relative to the content.
  /// Defaults to [NToastOrientation.horizontal].
  final NToastOrientation orientation;

  /// When true, a close button is rendered at the trailing edge.
  final bool closable;

  /// Called when the close button is tapped.
  final VoidCallback? onClose;

  /// Called when the toast is tapped.
  final VoidCallback? onTap;

  /// Creates an [NToast] widget.
  const NToast({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.color = NToastColor.primary,
    this.orientation = NToastOrientation.horizontal,
    this.closable = true,
    this.onClose,
    this.onTap,
  });

  /// Shows a toast overlay at the bottom of the screen.
  ///
  /// The toast automatically dismisses after [duration] (defaults to 4
  /// seconds). Pass [duration] as Duration.zero to make it persistent until
  /// manually dismissed.
  static void show(
    BuildContext context, {
    String? title,
    String? description,
    IconData? icon,
    NToastColor color = NToastColor.primary,
    NToastOrientation orientation = NToastOrientation.horizontal,
    bool closable = true,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _NToastOverlay(
        title: title,
        description: description,
        icon: icon,
        color: color,
        orientation: orientation,
        closable: closable,
        duration: duration,
        onClose: () => entry.remove(),
        onTap: onTap,
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final defaultIcon = _getDefaultIcon();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors['background'],
          borderRadius: BorderRadius.circular(NTokens.radiusDefault),
          border: Border.all(color: colors['border']!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null || defaultIcon != null) ...[
              Icon(
                icon ?? defaultIcon,
                size: 20,
                color: colors['icon'],
              ),
              NSpacing.horizontal(NSpacing.s2),
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
                        color: colors['text'],
                      ),
                    ),
                  if (description != null) ...[
                    if (title != null) const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors['text']!.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (closable) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: colors['text']!.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  NComponentColor? get _componentColor {
    final map = {
      NToastColor.primary: NComponentColor.primary,
      NToastColor.success: NComponentColor.success,
      NToastColor.warning: NComponentColor.warning,
      NToastColor.error: NComponentColor.error,
      NToastColor.info: NComponentColor.info,
    };
    return map[color];
  }

  Map<String, Color> _getColors(BuildContext context) {
    if (_componentColor != null) {
      final c = NComponentColors.resolve(context, _componentColor!);
      return {
        'background': c.softBg,
        'border': c.border,
        'text': c.text,
        'icon': c.main,
      };
    }
    return {
      'background': NTokens.bgElevated(context),
      'border': NTokens.borderDefault(context),
      'text': NTokens.textDefault(context),
      'icon': NTokens.textMuted(context),
    };
  }

  IconData? _getDefaultIcon() {
    switch (color) {
      case NToastColor.info:
        return Icons.info_outline;
      case NToastColor.success:
        return Icons.check_circle_outline;
      case NToastColor.warning:
        return Icons.warning_amber_outlined;
      case NToastColor.error:
        return Icons.error_outline;
      case NToastColor.primary:
        return Icons.lightbulb_outline;
      case NToastColor.neutral:
        return null;
    }
  }
}

/// Internal widget that manages toast overlay lifecycle with animation.
class _NToastOverlay extends StatefulWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  final NToastColor color;
  final NToastOrientation orientation;
  final bool closable;
  final Duration duration;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  const _NToastOverlay({
    this.title,
    this.description,
    this.icon,
    required this.color,
    required this.orientation,
    required this.closable,
    required this.duration,
    this.onClose,
    this.onTap,
  });

  @override
  State<_NToastOverlay> createState() => _NToastOverlayState();
}

class _NToastOverlayState extends State<_NToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    if (widget.duration > Duration.zero) {
      Future.delayed(widget.duration, _dismiss);
    }
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: NToast(
            title: widget.title,
            description: widget.description,
            icon: widget.icon,
            color: widget.color,
            orientation: widget.orientation,
            closable: widget.closable,
            onClose: _dismiss,
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
