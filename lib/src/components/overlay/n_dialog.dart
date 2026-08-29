import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// # NDialog
///
/// A modal dialog component inspired by NuxtUI's Modal design system.
/// Provides customizable dialogs with header, body, footer, and animations.
///
/// ## Features
/// - Header with icon, title, and description
/// - Scrollable content area
/// - Footer for action buttons
/// - Fullscreen mode support
/// - Customizable overlay/backdrop
/// - Smooth fade and scale animations
/// - Dismissible or non-dismissible
///
/// Usually shown via [showNuiDialog].
class NDialog extends StatefulWidget {
  /// Optional title displayed in the header
  final String? title;

  /// Optional description displayed below title
  final String? description;

  /// Optional icon in a tinted circle above the title.
  final IconData? icon;

  /// Icon-circle color role. Defaults to `primary`.
  final NColorRole color;

  /// Main content of the modal
  final Widget? child;

  /// Action buttons displayed in the footer
  final List<Widget>? actions;

  /// Custom padding for the body content
  final EdgeInsetsGeometry? padding;

  /// Whether the modal can be dismissed by tapping outside or pressing back
  final bool dismissible;

  /// Whether to show overlay/backdrop
  final bool overlay;

  /// Whether to enable fade/scale animations
  final bool transition;

  /// Whether to display in fullscreen mode
  final bool fullscreen;

  /// Maximum width constraint (ignored in fullscreen)
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
    this.dismissible = true,
    this.overlay = true,
    this.transition = true,
    this.fullscreen = false,
    this.maxWidth,
  });

  @override
  State<NDialog> createState() => _NDialogState();
}

class _NDialogState extends State<NDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.transition) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget modalContent = Container(
      constraints: widget.fullscreen
          ? null
          : BoxConstraints(
              maxWidth: widget.maxWidth ?? 500,
            ),
      decoration: widget.fullscreen
          ? null
          : BoxDecoration(
              color: context.nui.colors.bg,
              borderRadius: context.nui.radius.radiusLg,
              border: Border.all(
                color: context.nui.colors.border,
              ),
              boxShadow: context.nui.shadows.lg,
            ),
      child: widget.fullscreen ? _buildFullscreenContent() : _buildStandardContent(),
    );

    // Apply animations if enabled
    if (widget.transition) {
      modalContent = FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: modalContent,
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: widget.fullscreen
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: context.nui.spacing.comfortable, vertical: context.nui.spacing.spacious),
      child: modalContent,
    );
  }

  Widget _buildStandardContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        if (widget.icon != null || widget.title != null) _buildHeader(),

        // Body
        if (widget.child != null)
          Flexible(
            child: SingleChildScrollView(
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: context.nui.spacing.spacious,
                    vertical: context.nui.spacing.comfortable,
                  ),
              child: widget.child,
            ),
          ),

        // Footer
        if (widget.actions != null && widget.actions!.isNotEmpty) _buildFooter(),
      ],
    );
  }

  Widget _buildFullscreenContent() {
    return Material(
      color: context.nui.colors.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(),

          // Body (scrollable)
          Expanded(
            child: widget.child != null
                ? SingleChildScrollView(
                    padding: widget.padding ??
                        EdgeInsets.symmetric(
                          horizontal: context.nui.spacing.spacious,
                          vertical: context.nui.spacing.comfortable,
                        ),
                    child: widget.child,
                  )
                : const SizedBox.shrink(),
          ),

          // Footer
          if (widget.actions != null && widget.actions!.isNotEmpty) ...[
            _buildFooter(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final c = context.nui.colors;
    final accent = widget.color == NColorRole.neutral ? c.textHighlighted : c.role(widget.color);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null)
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon!, size: 26, color: accent),
            ),
          if (widget.title != null)
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.text,
              ),
            ),
          if (widget.description != null) ...[
            SizedBox(height: context.nui.spacing.base),
            Text(
              widget.description!,
              style: TextStyle(
                fontSize: 14,
                color: c.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: context.nui.spacing.pagePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var i = 0; i < widget.actions!.length; i++)
            Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
              child: widget.actions![i],
            ),
        ],
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
/// - [dismissible]: Allow dismiss by tapping outside (default: true)
/// - [overlay]: Show backdrop overlay (default: true)
/// - [transition]: Enable fade/scale animations (default: true)
/// - [fullscreen]: Display in fullscreen mode (default: false)
/// - [maxWidth]: Maximum width constraint (default: 500)
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
  bool dismissible = true,
  bool overlay = true,
  bool transition = true,
  bool fullscreen = false,
  double? maxWidth,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: overlay ? Colors.black.withValues(alpha: 0.5) : Colors.transparent,
    builder: (context) => NDialog(
      icon: icon,
      title: title,
      description: description,
      actions: actions,
      padding: padding,
      dismissible: dismissible,
      overlay: overlay,
      transition: transition,
      fullscreen: fullscreen,
      maxWidth: maxWidth,
      child: child,
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
/// - [dismissible]: Allow dismiss by tapping outside (default: true)
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
/// - [dismissible]: Allow dismiss by tapping outside (default: true)
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
