import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/n_tokens.dart';

/// A Material [AppBar] styled with NUI design tokens.
///
/// [NAppBar] reads colors from [NTokens] and implements [PreferredSizeWidget]
/// so it can be used directly as the `appBar` parameter of [Scaffold].
///
/// ```dart
/// Scaffold(
///   appBar: NAppBar(
///     title: 'Wallet',
///     showBack: true,
///     actions: [NIconButton(icon: LucideIcons.bell, onPressed: () {})],
///   ),
/// )
/// ```
class NAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Plain string title rendered with the NUI heading style.
  ///
  /// Ignored when [titleWidget] is provided.
  final String? title;

  /// A custom widget rendered as the app bar title.
  ///
  /// Takes precedence over [title].
  final Widget? titleWidget;

  /// Action widgets placed at the trailing edge of the app bar.
  final List<Widget>? actions;

  /// A custom leading widget.
  ///
  /// When null and [showBack] is true, a back arrow is shown.
  /// When both are null, no leading widget is rendered.
  final Widget? leading;

  /// When `true`, renders an [LucideIcons.arrowLeft] back button as the
  /// leading widget. Has no effect when [leading] is provided.
  ///
  /// Defaults to `false`.
  final bool showBack;

  /// Called when the back button is tapped.
  ///
  /// When null, [Navigator.of(context).pop()] is called automatically.
  final VoidCallback? onBack;

  /// The elevation of the app bar surface. Defaults to 0.
  final double elevation;

  /// Overrides the background color. Defaults to [NTokens.bgDefault].
  final Color? backgroundColor;

  /// Overrides the foreground (text and icon) color. Defaults to [NTokens.textDefault].
  final Color? foregroundColor;

  /// Creates an [NAppBar].
  const NAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBack = false,
    this.onBack,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The preferred height of the app bar (56 dp).
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? NTokens.textDefault(context);
    final bg = backgroundColor ?? NTokens.bgDefault(context);

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
      leading: leading ??
          (showBack
              ? IconButton(
                  icon: Icon(LucideIcons.arrowLeft, color: fg),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    );
  }
}
