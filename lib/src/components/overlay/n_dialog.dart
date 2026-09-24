import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// # NDialog
///
/// A modal dialog component mirroring Nuxt UI's `UModal`.
///
/// ## Features
/// - Header with icon, title, and description
/// - Scrollable content area, divided from header/footer by a hairline
/// - Footer for action buttons
/// - Fullscreen mode support
/// - Themed overlay/backdrop
/// - Symmetric fade + scale open/close animation, driven by the dialog's
///   own [PopupRoute] so it plays correctly on every dismissal path
///   (barrier tap, back gesture, or `Navigator.pop`)
/// - Optional built-in close button, independent from [dismissible]
///
/// Usually shown via [showNuiDialog].
class NDialog extends StatelessWidget {
  /// Optional title displayed in the header.
  final String? title;

  /// Optional description displayed below title.
  final String? description;

  /// Optional icon in a tinted circle above the title.
  ///
  /// This icon-circle header is a NUI extension; Nuxt UI's `UModal` has no
  /// equivalent slot.
  final IconData? icon;

  /// Icon-circle color role. Defaults to `primary`.
  final NColorRole color;

  /// Main content of the modal.
  final Widget? child;

  /// Action buttons displayed in the footer.
  final List<Widget>? actions;

  /// Custom padding for the body content.
  final EdgeInsetsGeometry? padding;

  /// When `true`, a close button is rendered in the top-end corner.
  ///
  /// Independent from [dismissible]: a modal can be non-dismissible by
  /// outside tap or back gesture while still offering an explicit close
  /// action. Defaults to `true`.
  final bool closable;

  /// Whether to display in fullscreen mode.
  final bool fullscreen;

  /// Maximum width constraint (ignored in fullscreen). Defaults to `512`.
  final double? maxWidth;

  const NDialog({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.color = NColorRole.primary,
    this.child,
    this.actions,
    this.padding,
    this.closable = true,
    this.fullscreen = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.nui.colors;

    Widget content = Container(
      constraints: fullscreen ? null : BoxConstraints(maxWidth: maxWidth ?? 512),
      decoration: fullscreen
          ? null
          : BoxDecoration(
              color: colors.bg,
              borderRadius: context.nui.radius.radiusLg,
              border: Border.all(color: colors.border),
              boxShadow: context.nui.shadows.lg,
            ),
      child: ClipRRect(
        borderRadius: fullscreen ? BorderRadius.zero : context.nui.radius.radiusLg,
        child: fullscreen ? _buildFullscreenContent(context) : _buildStandardContent(context),
      ),
    );

    if (fullscreen) {
      return Material(color: colors.bg, child: content);
    }

    return content;
  }

  Widget _buildStandardContent(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _sections(context),
        ),
        if (closable) _buildCloseButton(context),
      ],
    );
  }

  Widget _buildFullscreenContent(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _sections(context, expandBody: true),
        ),
        if (closable) _buildCloseButton(context),
      ],
    );
  }

  List<Widget> _sections(BuildContext context, {bool expandBody = false}) {
    final hasHeader = icon != null || title != null || description != null;
    final body = child == null
        ? null
        : SingleChildScrollView(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          );

    final sections = <Widget>[
      if (hasHeader) _buildHeader(context),
      if (body != null) (expandBody ? Expanded(child: body) : Flexible(child: body)),
      if (actions != null && actions!.isNotEmpty) _buildFooter(context),
    ];

    return [
      for (var i = 0; i < sections.length; i++) ...[
        if (i > 0) Divider(height: 1, thickness: 1, color: context.nui.colors.border),
        sections[i],
      ],
    ];
  }

  Widget _buildCloseButton(BuildContext context) {
    return PositionedDirectional(
      top: 16,
      end: 16,
      child: NIconButton.sm(
        icon: Icons.close,
        variant: NVariant.ghost,
        color: NColorRole.neutral,
        // `pop()`, not `maybePop()`: an explicit close tap must always work,
        // even when `dismissible: false` blocks the back gesture via
        // PopScope (which only intercepts system-initiated pop requests).
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final c = context.nui.colors;
    final accent = color == NColorRole.neutral ? c.textHighlighted : c.role(color);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon!, size: 26, color: accent),
              ),
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: c.textHighlighted,
                ),
              ),
            if (description != null) ...[
              SizedBox(height: context.nui.spacing.s1),
              Text(
                description!,
                style: TextStyle(fontSize: 14, color: c.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var i = 0; i < actions!.length; i++)
            Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
              child: actions![i],
            ),
        ],
      ),
    );
  }
}

// ============================================================
// ANIMATED ROUTE
// ============================================================

/// A [PopupRoute] that drives [NDialog]'s open/close animation from the
/// route's own [Animation], so both directions (push and pop, whatever
/// triggers the pop) stay symmetric. Mirrors Nuxt UI's
/// `scale-in`/`scale-out 200ms` pair.
class _NDialogRoute<T> extends PopupRoute<T> {
  _NDialogRoute({
    required this.pageBuilder,
    required this.barrierDismissible,
    required this.barrierColor,
    required this.barrierLabel,
    required this.dismissible,
    required Duration transitionDuration,
  }) : _transitionDuration = transitionDuration;

  final WidgetBuilder pageBuilder;
  final bool dismissible;
  final Duration _transitionDuration;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return PopScope(
      canPop: dismissible,
      child: Builder(builder: pageBuilder),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut, reverseCurve: Curves.easeIn);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
        child: child,
      ),
    );
  }
}

// ============================================================
// HELPER FUNCTIONS
// ============================================================

/// Shows a modal dialog with customizable content.
///
/// **Parameters:**
/// - [context]: BuildContext required for navigation
/// - [icon]: Optional icon displayed in header
/// - [title]: Optional title displayed in header
/// - [description]: Optional description below title
/// - [child]: Main content widget
/// - [actions]: Optional action buttons for footer
/// - [padding]: Custom padding for body content
/// - [closable]: Show the built-in close button (default: true)
/// - [dismissible]: Allow dismiss by tapping outside or the back gesture (default: true)
/// - [overlay]: Show backdrop overlay (default: true)
/// - [transition]: Enable fade/scale animations (default: true)
/// - [fullscreen]: Display in fullscreen mode (default: false)
/// - [maxWidth]: Maximum width constraint (default: 512)
///
/// **Example:**
/// ```dart
/// await showNuiDialog(
///   context: context,
///   title: 'Settings',
///   child: SettingsForm(),
///   actions: [
///     NButton(label: 'Cancel', onPressed: () => Navigator.pop(context)),
///     NButton(label: 'Save', onPressed: () => save()),
///   ],
/// );
/// ```
Future<T?> showNuiDialog<T>({
  required BuildContext context,
  IconData? icon,
  String? title,
  String? description,
  Widget? child,
  List<Widget>? actions,
  EdgeInsetsGeometry? padding,
  bool closable = true,
  bool dismissible = true,
  bool overlay = true,
  bool transition = true,
  bool fullscreen = false,
  double? maxWidth,
}) {
  assert(
    closable || dismissible || (actions != null && actions.isNotEmpty),
    'NDialog would be impossible to close: closable and dismissible are '
    'both false, and no actions were provided.',
  );

  final colors = context.nui.colors;
  final spacing = context.nui.spacing;
  final barrierLabel = MaterialLocalizations.of(context).modalBarrierDismissLabel;

  return Navigator.of(context, rootNavigator: true).push<T>(
    _NDialogRoute<T>(
      barrierDismissible: dismissible,
      barrierLabel: barrierLabel,
      dismissible: dismissible,
      barrierColor: overlay ? colors.bgElevated.withValues(alpha: 0.75) : Colors.transparent,
      transitionDuration: transition ? const Duration(milliseconds: 200) : Duration.zero,
      pageBuilder: (context) {
        final dialog = NDialog(
          icon: icon,
          title: title,
          description: description,
          actions: actions,
          padding: padding,
          closable: closable,
          fullscreen: fullscreen,
          maxWidth: maxWidth,
          child: child,
        );

        // Mirrors Flutter's own Dialog: SafeArea keeps the header/close
        // button clear of notches, AnimatedPadding + removeViewInsets keep
        // the keyboard from double-shifting content that reads viewInsets
        // itself (e.g. a TextField in the body).
        if (fullscreen) {
          return SafeArea(
            child: Material(type: MaterialType.transparency, child: dialog),
          );
        }

        return SafeArea(
          child: AnimatedPadding(
            padding: MediaQuery.viewInsetsOf(context) +
                EdgeInsets.symmetric(horizontal: spacing.comfortable, vertical: spacing.spacious),
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: MediaQuery.removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
              context: context,
              child: Material(
                type: MaterialType.transparency,
                child: Align(alignment: Alignment.center, child: dialog),
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// Shows a confirmation dialog with Cancel and Confirm buttons.
///
/// Returns `true` if confirmed, `false` if cancelled, `null` if dismissed.
///
/// **Parameters:**
/// - [context]: BuildContext required for navigation
/// - [title]: Dialog title (required)
/// - [description]: Optional description text
/// - [confirmText]: Text for confirm button (default: 'Confirm')
/// - [cancelText]: Text for cancel button (default: 'Cancel')
/// - [confirmColor]: Color of confirm button (default: neutral)
/// - [isDangerous]: Use error color for confirm button (default: false)
/// - [dismissible]: Allow dismiss by tapping outside or the back gesture (default: true)
///
/// **Example:**
/// ```dart
/// final confirmed = await showNuiConfirmDialog(
///   context: context,
///   title: 'Delete Account',
///   description: 'This action cannot be undone',
///   isDangerous: true,
///   confirmText: 'Delete',
/// );
///
/// if (confirmed == true) {
///   // User confirmed
///   deleteAccount();
/// }
/// ```
Future<bool?> showNuiConfirmDialog({
  required BuildContext context,
  required String title,
  String? description,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  NColorRole confirmColor = NColorRole.neutral,
  bool isDangerous = false,
  bool dismissible = true,
}) {
  return showNuiDialog<bool>(
    context: context,
    title: title,
    description: description,
    dismissible: dismissible,
    actions: [
      NButton(
        label: cancelText,
        variant: NVariant.ghost,
        color: NColorRole.neutral,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      NButton(
        label: confirmText,
        color: isDangerous ? NColorRole.error : confirmColor,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
      ),
    ],
  );
}

/// Shows an alert dialog with a single OK button.
///
/// **Parameters:**
/// - [context]: BuildContext required for navigation
/// - [title]: Dialog title (required)
/// - [description]: Optional description text
/// - [okText]: Text for OK button (default: 'OK')
/// - [dismissible]: Allow dismiss by tapping outside or the back gesture (default: true)
///
/// **Example:**
/// ```dart
/// await showNuiAlertDialog(
///   context: context,
///   title: 'Success',
///   description: 'Your changes have been saved',
/// );
/// ```
Future<void> showNuiAlertDialog({
  required BuildContext context,
  required String title,
  String? description,
  String okText = 'OK',
  bool dismissible = true,
}) {
  return showNuiDialog(
    context: context,
    title: title,
    description: description,
    dismissible: dismissible,
    actions: [
      NButton(
        label: okText,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
      ),
    ],
  );
}
