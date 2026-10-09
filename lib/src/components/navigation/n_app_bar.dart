import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

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
///     actions: [NIconButton(icon: NIcons.bell, onPressed: () {})],
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

  /// When `true`, renders an [NIcons.arrowLeft] back button as the
  /// leading widget. Has no effect when [leading] is provided.
  ///
  /// Defaults to `true`.
  final bool showBackButton;

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

  /// Whether center title. Defaults to false.
  final bool centerTitle;

  /// The width allocated for the leading widget.
  ///
  /// The leading widget is centered within this area, so with a 40 dp
  /// [NIconButton] (size [NIconButtonSize.md]) a [leadingWidth] of 56
  /// yields 8 dp padding on each side.
  ///
  /// Set to `null` to use Flutter's default (56 dp).
  final double? leadingWidth;

  /// Spacing between the leading area and the title. Defaults to Flutter's
  /// default (16 dp).
  final double? titleSpacing;

  /// Creates an [NAppBar].
  const NAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = false,
    this.onBack,
    this.elevation = 5,
    this.backgroundColor,
    this.foregroundColor,
    this.leadingWidth,
    this.titleSpacing,
  });

  /// The preferred height of the app bar (56 dp).
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? context.nui.colors.text;
    final bg = backgroundColor ?? context.nui.colors.bg;

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
      leading: leading ??
          (showBackButton
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: NIconButton(
                    icon: NIcons.arrowLeft,
                    variant: NVariant.soft,
                    onPressed: onBack ?? () => Navigator.of(context).pop(),
                  ),
                )
              : null),
      actions: actions,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevation,
      scrolledUnderElevation: 10,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      surfaceTintColor: Colors.transparent,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
    );
  }
}
