import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';

/// A pre-built full-screen error page component.
///
/// Displays a centered layout with an optional icon, a status code, a status
/// message, an explanatory message, and an action button to navigate away.
///
/// Designed to be used as the body of a dedicated error route or inside a
/// modal when a critical operation fails.
///
/// ```dart
/// NError(
///   statusCode: 404,
///   statusMessage: 'Page not found',
///   message: 'The page you are looking for does not exist.',
///   onClear: () => Navigator.of(context).pushReplacementNamed('/'),
/// )
/// ```
class NError extends StatelessWidget {
  /// The HTTP status code displayed prominently below the icon.
  /// Common values: `404`, `500`, `403`.
  final int? statusCode;

  /// A short status label rendered below [statusCode].
  /// e.g. `'Page not found'`, `'Internal server error'`.
  final String? statusMessage;

  /// A longer explanatory message rendered below [statusMessage] in a muted
  /// style.
  final String? message;

  /// An optional icon displayed above [statusCode].
  ///
  /// Defaults to an appropriate icon based on [statusCode]:
  /// - `404` → `Icons.search_off_rounded`
  /// - `403` → `Icons.lock_outline_rounded`
  /// - `500` → `Icons.cloud_off_rounded`
  /// - Other  → `Icons.error_outline_rounded`
  final IconData? icon;

  /// A custom widget rendered above the status code instead of [icon].
  /// Useful for displaying a logo or avatar.
  final Widget? leading;

  /// Label of the action button. Defaults to `'Back to home'`.
  final String clearLabel;

  /// Called when the user taps the action button.
  /// Typically used to pop the navigation stack or push the home route.
  final VoidCallback? onClear;

  /// When `false`, hides the action button entirely.
  final bool showClear;

  /// Creates an [NError].
  const NError({
    super.key,
    this.statusCode,
    this.statusMessage,
    this.message,
    this.icon,
    this.leading,
    this.clearLabel = 'Back to home',
    this.onClear,
    this.showClear = true,
  });

  IconData _resolveIcon() {
    if (icon != null) return icon!;
    return switch (statusCode) {
      404 => Icons.search_off_rounded,
      403 => Icons.lock_outline_rounded,
      401 => Icons.lock_outline_rounded,
      500 => Icons.cloud_off_rounded,
      503 => Icons.cloud_off_rounded,
      _ => Icons.error_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = NTokens.primary(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading: custom widget or icon
            if (leading != null) ...[
              leading!,
              const SizedBox(height: 16),
            ] else ...[
              _IconBadge(icon: _resolveIcon(), color: primaryColor),
              const SizedBox(height: 20),
            ],

            // Status code
            if (statusCode != null) ...[
              Text(
                statusCode.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Status message (big headline)
            if (statusMessage != null) ...[
              Text(
                statusMessage!,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: NTokens.textHighlighted(context),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Detail message
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 15,
                  color: NTokens.textMuted(context),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (showClear && onClear != null) ...[
              const SizedBox(height: 32),
              _ClearButton(
                label: clearLabel,
                onTap: onClear!,
                color: primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon badge
// ---------------------------------------------------------------------------

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, size: 32, color: color),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Clear button
// ---------------------------------------------------------------------------

class _ClearButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ClearButton({
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.88)
                : widget.color,
            borderRadius: BorderRadius.circular(NTokens.radiusDefault),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_rounded,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
