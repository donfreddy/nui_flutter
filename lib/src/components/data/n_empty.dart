import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';

/// The size of an [NEmpty] component.
enum NEmptySize {
  xs,
  sm,
  md,
  lg,
  xl,
}

/// The visual variant of an [NEmpty] component.
enum NEmptyVariant {
  outline,
  solid,
  soft,
  subtle,
  naked,
}

/// A component to display an empty state.
///
/// Shows a large icon or avatar, a title, an optional description, and a
/// list of optional action widgets.
///
/// ```dart
/// NEmpty(
///   icon: LucideIcons.inbox,
///   title: 'No projects found',
///   description: 'It looks like you haven\'t added any projects.',
///   actions: [
///     NButton(label: 'Create new', icon: LucideIcons.plus),
///   ],
/// )
/// ```
class NEmpty extends StatelessWidget {
  /// The icon displayed above the title.
  final IconData? icon;

  /// The avatar displayed above the title.
  final Widget? avatar;

  /// The primary title text.
  final String title;

  /// An optional description rendered below [title].
  final String? description;

  /// A list of action widgets rendered at the bottom (e.g., buttons).
  final List<Widget>? actions;

  /// The size of the empty state. Defaults to [NEmptySize.md].
  final NEmptySize size;

  /// The visual variant. Defaults to [NEmptyVariant.outline].
  final NEmptyVariant variant;

  /// Creates an [NEmpty].
  const NEmpty({
    super.key,
    required this.title,
    this.icon,
    this.avatar,
    this.description,
    this.actions,
    this.size = NEmptySize.md,
    this.variant = NEmptyVariant.outline,
  });

  /// Old constructor for backward compatibility. Use [actions] instead of [action].
  @Deprecated('Use actions instead.')
  NEmpty.legacy({
    super.key,
    required this.title,
    required IconData this.icon,
    this.description,
    Widget? action,
  })  : avatar = null,
        actions = action != null ? [action] : null,
        size = NEmptySize.md,
        variant = NEmptyVariant.naked;

  // --- Size configuration ---
  double _getAvatarSize() {
    return switch (size) {
      NEmptySize.xs => 32,
      NEmptySize.sm => 36,
      NEmptySize.md => 40,
      NEmptySize.lg => 44,
      NEmptySize.xl => 48,
    };
  }

  double _getIconSize() {
    return switch (size) {
      NEmptySize.xs => 24,
      NEmptySize.sm => 28,
      NEmptySize.md => 32,
      NEmptySize.lg => 36,
      NEmptySize.xl => 40,
    };
  }

  double _getTitleSize() {
    return switch (size) {
      NEmptySize.xs => 14,
      NEmptySize.sm => 14,
      NEmptySize.md => 16,
      NEmptySize.lg => 16,
      NEmptySize.xl => 18,
    };
  }

  double _getDescriptionSize() {
    return switch (size) {
      NEmptySize.xs => 12,
      NEmptySize.sm => 12,
      NEmptySize.md => 14,
      NEmptySize.lg => 14,
      NEmptySize.xl => 16,
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      NEmptySize.xs => const EdgeInsets.all(16),
      NEmptySize.sm => const EdgeInsets.all(20),
      NEmptySize.md => const EdgeInsets.all(24),
      NEmptySize.lg => const EdgeInsets.all(28),
      NEmptySize.xl => const EdgeInsets.all(32),
    };
  }

  // --- Variant configuration ---
  Color _getBgColor(BuildContext context) {
    return switch (variant) {
      NEmptyVariant.solid => NTokens.bgInverted(context),
      NEmptyVariant.outline => NTokens.bgDefault(context),
      NEmptyVariant.soft => NTokens.bgElevated(context).withValues(alpha: 0.5),
      NEmptyVariant.subtle =>
        NTokens.bgElevated(context).withValues(alpha: 0.5),
      NEmptyVariant.naked => Colors.transparent,
    };
  }

  Border? _getBorder(BuildContext context) {
    return switch (variant) {
      NEmptyVariant.outline =>
        Border.all(color: NTokens.borderDefault(context)),
      NEmptyVariant.subtle => Border.all(color: NTokens.borderDefault(context)),
      _ => null,
    };
  }

  Color _getTitleColor(BuildContext context) {
    return switch (variant) {
      NEmptyVariant.solid => NTokens.textInverted(context),
      _ => NTokens.textHighlighted(context),
    };
  }

  Color _getDescriptionColor(BuildContext context) {
    return switch (variant) {
      NEmptyVariant.solid => NTokens.textInverted(context)
          .withValues(alpha: 0.7), // equivalent to text-dimmed
      NEmptyVariant.soft => NTokens.textToned(context),
      NEmptyVariant.subtle => NTokens.textToned(context),
      NEmptyVariant.outline => NTokens.textMuted(context),
      NEmptyVariant.naked => NTokens.textMuted(context),
    };
  }

  Color _getIconColor(BuildContext context) {
    return switch (variant) {
      NEmptyVariant.solid => NTokens.textInverted(context),
      _ => NTokens.textMuted(context),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _getBgColor(context),
        border: _getBorder(context),
        borderRadius: BorderRadius.circular(NTokens.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header (Icon or Avatar)
          if (avatar != null || icon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: avatar != null
                  ? SizedBox(
                      width: _getAvatarSize(),
                      height: _getAvatarSize(),
                      child: avatar!,
                    )
                  : Icon(
                      icon,
                      size: _getIconSize(),
                      color: _getIconColor(context),
                    ),
            ),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: _getTitleSize(),
              fontWeight: FontWeight.w600,
              color: _getTitleColor(context),
            ),
            textAlign: TextAlign.center,
          ),

          // Description
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(
                fontSize: _getDescriptionSize(),
                color: _getDescriptionColor(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Actions
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }
}
