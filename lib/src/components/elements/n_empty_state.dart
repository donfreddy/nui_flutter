import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';

/// A centered empty-state placeholder displayed when a list or page has no content.
///
/// Shows a large icon, a title, an optional description, and an optional action
/// widget (e.g., a button to create the first item).
///
/// ```dart
/// NEmptyState(
///   icon: LucideIcons.inbox,
///   title: 'No transactions yet',
///   description: 'Your transaction history will appear here.',
///   action: NButton(label: 'Send money', onPressed: _sendMoney),
/// )
/// ```
class NEmptyState extends StatelessWidget {
  /// The icon displayed at the top of the empty state.
  final IconData icon;

  /// The primary title text rendered below the icon.
  final String title;

  /// An optional description rendered below [title] in a muted style.
  final String? description;

  /// An optional action widget rendered at the bottom (e.g., a call-to-action button).
  final Widget? action;

  /// Creates an [NEmptyState].
  const NEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: NTokens.textMuted(context)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: NTokens.textDefault(context),
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: TextStyle(
                  fontSize: 14,
                  color: NTokens.textMuted(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
