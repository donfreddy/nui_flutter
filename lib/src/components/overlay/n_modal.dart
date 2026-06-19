import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_spacing.dart';

/// A dialog window that displays a message or requests user input.
///
/// [NModal] provides a modal overlay with a header, body, and footer section.
/// Use named constructors for convenience or configure the full API through
/// the default constructor.
///
/// ```dart
/// NModal.dialog(
///   context: context,
///   title: 'Confirm deletion',
///   body: 'Are you sure you want to delete this item?',
///   onConfirm: () => deleteItem(),
/// )
/// ```
///
/// For programmatic control, use [NModal.show] to display an [NModal] and
/// await its result.
class NModal extends StatelessWidget {
  /// The title text displayed in the modal header.
  final String? title;

  /// The description text displayed below the title in the header.
  final String? description;

  /// The body content of the modal.
  final Widget? body;

  /// The footer content of the modal, typically containing action buttons.
  final Widget? footer;

  /// When true, the close button is shown in the header. Defaults to true.
  final bool showClose;

  /// Called when the modal is dismissed.
  final VoidCallback? onClose;

  /// Creates an [NModal] with fine-grained control over all sections.
  const NModal({
    super.key,
    this.title,
    this.description,
    this.body,
    this.footer,
    this.showClose = true,
    this.onClose,
  });

  /// Displays an [NModal] as a full-screen dialog and returns the result of
  /// [onConfirm] or false when dismissed.
  ///
  /// ```dart
  /// final confirmed = await NModal.dialog(
  ///   context: context,
  ///   title: 'Delete item',
  ///   body: 'This action cannot be undone.',
  /// );
  /// if (confirmed == true) { ... }
  /// ```
  static Future<bool?> dialog({
    required BuildContext context,
    String? title,
    String? description,
    String? body,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _NModalDialog(
        title: title,
        description: description,
        body: body,
        confirmLabel: confirmLabel ?? (destructive ? 'Delete' : 'Confirm'),
        cancelLabel: cancelLabel ?? 'Cancel',
        onConfirm: onConfirm,
        destructive: destructive,
      ),
    ).then((r) => r ?? false);
  }

  /// Shows a full custom [NModal] with a builder pattern.
  ///
  /// Use this when you need full control over the modal content beyond the
  /// simple dialog helper.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext context, VoidCallback close) builder,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _NModalCustom(builder: builder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NTokens.bgElevated(context),
        borderRadius: BorderRadius.circular(NTokens.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || showClose) _buildHeader(context),
          if (body != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                NSpacing.s4,
                0,
                NSpacing.s4,
                NSpacing.s4,
              ),
              child: DefaultTextStyle(
                style: TextStyle(color: NTokens.textDefault(context)),
                child: body!,
              ),
            ),
          if (footer != null)
            Container(
              padding: EdgeInsets.all(NSpacing.s4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: NTokens.borderDefault(context)),
                ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(color: NTokens.textDefault(context)),
                child: footer!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        NSpacing.s4,
        NSpacing.s4,
        NSpacing.s2,
        NSpacing.s2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: NTokens.textHighlighted(context),
                    ),
                  ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: NTokens.textMuted(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showClose)
            IconButton(
              icon: Icon(Icons.close, size: 20, color: NTokens.textMuted(context)),
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}

/// Internal dialog used by [NModal.dialog].
class _NModalDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? body;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final bool destructive;

  const _NModalDialog({
    this.title,
    this.description,
    this.body,
    required this.confirmLabel,
    required this.cancelLabel,
    this.onConfirm,
    required this.destructive,
  });

  @override
  Widget build(BuildContext context) {
    return NModal(
      title: title,
      description: description,
      body: body != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                body!,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: NTokens.textDefault(context),
                ),
              ),
            )
          : null,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          const SizedBox(width: 12),
          _NModalActionButton(
            label: confirmLabel,
            destructive: destructive,
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}

/// Internal custom modal used by [NModal.show].
class _NModalCustom<T> extends StatelessWidget {
  final Widget Function(BuildContext context, VoidCallback close) builder;

  const _NModalCustom({required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, () => Navigator.of(context).pop());
  }
}

/// Internal styled button for modal actions.
class _NModalActionButton extends StatelessWidget {
  final String label;
  final bool destructive;
  final VoidCallback? onPressed;

  const _NModalActionButton({
    required this.label,
    required this.destructive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = destructive ? NTokens.error(context) : NTokens.primary(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(NTokens.radiusDefault),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: NTokens.textInverted(context),
          ),
        ),
      ),
    );
  }
}
