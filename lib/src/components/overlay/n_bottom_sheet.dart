import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_spacing.dart';

/// The semantic color role applied to the handle of an [NBottomSheet].
///
/// Currently reserved for future styling; the handle color is not
/// differentiated by color role in the current implementation.
enum NBottomSheetColor { primary, neutral, success, error, warning, info }

/// A styled bottom sheet widget rendered inside [showModalBottomSheet].
///
/// Use the static [NBottomSheet.show] helper instead of constructing this
/// widget directly, unless you need to compose it inside another overlay.
///
/// ```dart
/// NBottomSheet.show(
///   context: context,
///   title: 'Select currency',
///   child: CurrencyPicker(onSelect: _onCurrencySelected),
///   footer: NButton(
///     block: true,
///     label: 'Confirm',
///     onPressed: () => Navigator.pop(context),
///   ),
/// );
/// ```
class NBottomSheet extends StatelessWidget {
  /// An optional title rendered at the top of the sheet.
  final String? title;

  /// An optional subtitle rendered below [title] in a muted style.
  final String? subtitle;

  /// The main scrollable content of the sheet.
  final Widget? child;

  /// An optional footer widget pinned at the bottom of the sheet, above the
  /// safe area inset.
  final Widget? footer;

  /// When `true` (the default), a drag handle is shown at the top of the sheet.
  final bool showHandle;

  /// When `true` (the default), a close icon is shown at the trailing edge of
  /// the title row. Tapping it calls [Navigator.of(context).pop()].
  final bool showCloseButton;

  /// The semantic color role for the sheet. Defaults to [NBottomSheetColor.neutral].
  final NBottomSheetColor color;

  /// Creates an [NBottomSheet].
  ///
  /// Prefer [NBottomSheet.show] for typical usage.
  const NBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    this.child,
    this.footer,
    this.showHandle = true,
    this.showCloseButton = true,
    this.color = NBottomSheetColor.neutral,
  });

  /// Displays an [NBottomSheet] modally using [showModalBottomSheet].
  ///
  /// Returns a [Future] that resolves to the value passed to
  /// [Navigator.pop] when the sheet is dismissed, or `null` if it is
  /// dismissed by tapping outside.
  ///
  /// [child] is required and forms the scrollable body of the sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    required Widget child,
    Widget? footer,
    bool showHandle = true,
    bool showCloseButton = true,
    NBottomSheetColor color = NBottomSheetColor.neutral,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NBottomSheet(
        title: title,
        subtitle: subtitle,
        footer: footer,
        showHandle: showHandle,
        showCloseButton: showCloseButton,
        color: color,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NTokens.bgElevated(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: NTokens.borderDefault(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (title != null || showCloseButton)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: NSpacing.s4, vertical: NSpacing.s2),
              child: Row(
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
                              color: NTokens.textDefault(context),
                            ),
                          ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 13,
                              color: NTokens.textMuted(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showCloseButton)
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(LucideIcons.x,
                          size: 20, color: NTokens.textMuted(context)),
                    ),
                ],
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                NSpacing.s4,
                0,
                NSpacing.s4,
                NSpacing.s4,
              ),
              child: child!,
            ),
          ),
          if (footer != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                NSpacing.s4,
                NSpacing.s2,
                NSpacing.s4,
                MediaQuery.of(context).padding.bottom + NSpacing.s4,
              ),
              child: footer,
            ),
          if (footer == null)
            SizedBox(
                height: MediaQuery.of(context).padding.bottom + NSpacing.s2),
        ],
      ),
    );
  }
}

/// A single action item used inside [NBottomSheetActionList].
class NBottomSheetAction {
  /// The text label for the action.
  final String label;

  /// An optional icon shown to the left of [label].
  final IconData? icon;

  /// When `true`, the label and icon are rendered in the error color to
  /// signal a destructive operation.
  final bool isDestructive;

  /// Called when the user taps the action row.
  final VoidCallback onTap;

  /// Creates an [NBottomSheetAction].
  const NBottomSheetAction({
    required this.label,
    this.icon,
    this.isDestructive = false,
    required this.onTap,
  });
}

/// A pre-built [NBottomSheet] body that renders a list of [NBottomSheetAction]
/// rows. Each row closes the sheet and fires [NBottomSheetAction.onTap].
///
/// Use [NBottomSheetActionList.show] for the typical one-liner pattern:
///
/// ```dart
/// NBottomSheetActionList.show(
///   context: context,
///   title: 'Options',
///   actions: [
///     NBottomSheetAction(label: 'Edit', icon: LucideIcons.pencil, onTap: _edit),
///     NBottomSheetAction(label: 'Delete', icon: LucideIcons.trash2,
///         isDestructive: true, onTap: _delete),
///   ],
/// );
/// ```
class NBottomSheetActionList extends StatelessWidget {
  /// An optional title passed through to [NBottomSheet.title].
  final String? title;

  /// The list of actions to display.
  final List<NBottomSheetAction> actions;

  /// Creates an [NBottomSheetActionList].
  const NBottomSheetActionList({
    super.key,
    this.title,
    required this.actions,
  });

  /// Displays an [NBottomSheetActionList] modally.
  ///
  /// [title] appears at the top of the sheet. Each [NBottomSheetAction] in
  /// [actions] is rendered as a tappable row that closes the sheet before
  /// calling its [NBottomSheetAction.onTap].
  static Future<void> show({
    required BuildContext context,
    String? title,
    required List<NBottomSheetAction> actions,
  }) {
    return NBottomSheet.show(
      context: context,
      title: title,
      child: NBottomSheetActionList(title: title, actions: actions),
      showCloseButton: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        return ListTile(
          leading: action.icon != null
              ? Icon(
                  action.icon,
                  color: action.isDestructive
                      ? NTokens.error(context)
                      : NTokens.textDefault(context),
                )
              : null,
          title: Text(
            action.label,
            style: TextStyle(
              color: action.isDestructive
                  ? NTokens.error(context)
                  : NTokens.textDefault(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
            action.onTap();
          },
        );
      }).toList(),
    );
  }
}
