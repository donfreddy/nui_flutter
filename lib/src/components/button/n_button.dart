import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_spacing.dart';
import '../../theme/n_component_colors.dart';
import 'n_button_theme.dart';

/// The visual style of an [NButton].
enum NButtonVariant {
  /// Filled background using the button color. The most prominent variant.
  solid,

  /// Transparent background with a colored border.
  outline,

  /// Lightly tinted background using a low-opacity version of the button color.
  soft,

  /// Lightly tinted background with a colored border.
  subtle,

  /// Fully transparent background with no border. Shows color on press.
  ghost,

  /// Renders as a [TextButton] with no background or border.
  link,
}

/// The size of an [NButton], controlling padding, font size, and icon size.
enum NButtonSize {
  /// Extra small.
  xs,

  /// Small.
  sm,

  /// Medium. The default size.
  md,

  /// Large.
  lg,

  /// Extra large.
  xl,
}

/// The semantic color role applied to an [NButton].
enum NButtonColor {
  /// Uses [NTokens.primary].
  primary,

  /// Uses [NTokens.secondary].
  secondary,

  /// Uses [NTokens.success].
  success,

  /// Uses [NTokens.warning].
  warning,

  /// Uses [NTokens.error].
  error,

  /// Uses [NTokens.info].
  info,

  /// Uses a neutral text color with an inverted background.
  neutral,
}

/// A versatile button component inspired by Nuxt UI's Button.
///
/// Supports six [NButtonVariant] styles, five [NButtonSize] options, and seven
/// [NButtonColor] roles. All visual defaults are read from [NButtonTheme],
/// which is automatically registered by [NTheme].
///
/// At least one of [label] or [child] must be provided.
///
/// ```dart
/// NButton(
///   label: 'Save',
///   onPressed: () => save(),
///   color: NButtonColor.success,
/// )
/// ```
///
/// Use named constructors for common patterns:
/// ```dart
/// NButton.outline(label: 'Cancel', onPressed: () {})
/// NButton.ghost(label: 'Skip', onPressed: () {})
/// NButton.destructive(label: 'Delete', onPressed: _delete)
/// ```
class NButton extends StatefulWidget {
  /// The text label rendered inside the button.
  ///
  /// Either [label] or [child] must be provided.
  final String? label;

  /// A custom widget rendered as the button content.
  ///
  /// Either [label] or [child] must be provided.
  final Widget? child;

  /// Called when the button is tapped.
  ///
  /// Set to `null` to make the button appear interactive but do nothing,
  /// or set [disabled] to `true` to also reduce opacity.
  final VoidCallback? onPressed;

  /// The visual style of the button. Defaults to [NButtonVariant.solid].
  final NButtonVariant variant;

  /// The size of the button, affecting padding and font size.
  /// Defaults to [NButtonSize.md].
  final NButtonSize size;

  /// The semantic color role for the button. Defaults to [NButtonColor.primary].
  final NButtonColor color;

  /// An optional widget placed before the label (e.g., an icon).
  final Widget? leading;

  /// An optional widget placed after the label.
  final Widget? trailing;

  /// When `true`, shows a loading spinner in the leading position and
  /// prevents the button from firing [onPressed]. Defaults to `false`.
  final bool loading;

  /// When `true`, reduces button opacity to 50% and blocks interaction.
  /// Defaults to `false`.
  final bool disabled;

  /// When `true`, the button expands to fill its parent's width.
  /// Defaults to `false`.
  final bool block;

  /// Overrides the button's corner radius. Has no effect when [roundedFull]
  /// is `true`.
  final BorderRadius? borderRadius;

  /// Overrides the button's inner padding.
  final EdgeInsetsGeometry? padding;

  /// When `true` (the default), the button uses a fully rounded pill shape
  /// regardless of [NButtonTheme.radius] or [borderRadius].
  final bool roundedFull;

  /// Creates an [NButton].
  ///
  /// At least one of [label] or [child] must be non-null.
  const NButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = NButtonVariant.solid,
    this.size = NButtonSize.md,
    this.color = NButtonColor.primary,
    this.leading,
    this.trailing,
    this.loading = false,
    this.disabled = false,
    this.block = false,
    this.borderRadius,
    this.padding,
    this.roundedFull = true,
  }) : assert(label != null || child != null,
            'Either label or child must be provided');

  /// Creates an outline-variant button.
  ///
  /// Shorthand for `NButton(variant: NButtonVariant.outline, ...)`.
  const NButton.outline({
    Key? key,
    String? label,
    Widget? child,
    required VoidCallback? onPressed,
    NButtonColor color = NButtonColor.primary,
    NButtonSize size = NButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool loading = false,
    bool block = false,
    bool roundedFull = true,
  }) : this(
          key: key,
          label: label,
          child: child,
          onPressed: onPressed,
          variant: NButtonVariant.outline,
          color: color,
          size: size,
          leading: leading,
          trailing: trailing,
          loading: loading,
          block: block,
          roundedFull: roundedFull,
        );

  /// Creates a ghost-variant button.
  ///
  /// Shorthand for `NButton(variant: NButtonVariant.ghost, ...)`.
  const NButton.ghost({
    Key? key,
    String? label,
    Widget? child,
    required VoidCallback? onPressed,
    NButtonColor color = NButtonColor.primary,
    NButtonSize size = NButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool block = false,
  }) : this(
          key: key,
          label: label,
          child: child,
          onPressed: onPressed,
          variant: NButtonVariant.ghost,
          color: color,
          size: size,
          leading: leading,
          trailing: trailing,
          block: block,
          roundedFull: true,
        );

  /// Creates a destructive (solid error-colored) button.
  ///
  /// Shorthand for `NButton(variant: NButtonVariant.solid, color: NButtonColor.error, ...)`.
  const NButton.destructive({
    Key? key,
    String? label,
    Widget? child,
    required VoidCallback? onPressed,
    NButtonSize size = NButtonSize.md,
    bool loading = false,
    bool block = false,
  }) : this(
          key: key,
          label: label,
          child: child,
          onPressed: onPressed,
          variant: NButtonVariant.solid,
          color: NButtonColor.error,
          size: size,
          loading: loading,
          block: block,
          roundedFull: true,
        );

  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _tapping = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_tapping || widget.onPressed == null || widget.loading) return;
    _tapping = true;
    try {
      await _ctrl.forward();
      await _ctrl.reverse();
      widget.onPressed!();
    } finally {
      _tapping = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.loading;
    final theme =
        Theme.of(context).extension<NButtonTheme>() ?? const NButtonTheme();
    final buttonPadding = widget.padding ?? _getPadding();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();
    final defaultBorderRadius = widget.roundedFull
        ? BorderRadius.circular(999)
        : (widget.borderRadius ?? BorderRadius.circular(theme.radius));
    final colors = _getColors(context);
    final loadingIcon = theme.loadingIcon;

    Widget buttonChild = Row(
      mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          Icon(
            loadingIcon ?? LucideIcons.loader,
            size: iconSize,
            color: colors['foreground'],
          )
        else if (widget.leading != null)
          IconTheme(
            data: IconThemeData(color: colors['foreground'], size: iconSize),
            child: widget.leading!,
          ),
        if ((widget.loading || widget.leading != null) &&
            (widget.label != null || widget.child != null))
          SizedBox(width: NSpacing.s2),
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: colors['foreground'],
            ),
          )
        else if (widget.child != null)
          DefaultTextStyle(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: colors['foreground'],
            ),
            child: IconTheme(
              data: IconThemeData(color: colors['foreground'], size: iconSize),
              child: widget.child!,
            ),
          ),
        if (widget.trailing != null && !widget.loading) ...[
          SizedBox(width: NSpacing.s2),
          IconTheme(
            data: IconThemeData(color: colors['foreground'], size: iconSize),
            child: widget.trailing!,
          ),
        ],
      ],
    );

    if (widget.variant == NButtonVariant.link) {
      return TextButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: colors['foreground'],
          padding: buttonPadding,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: buttonChild,
      );
    }

    return Semantics(
      button: true,
      enabled: !isDisabled,
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          width: widget.block ? double.infinity : null,
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Material(
              color: colors['background'],
              borderRadius: defaultBorderRadius,
              child: InkWell(
                onTap: _onTap,
                onTapDown: (_) => _ctrl.forward(),
                onTapCancel: () => _ctrl.reverse(),
                borderRadius: defaultBorderRadius,
                child: Container(
                  padding: buttonPadding,
                  decoration: BoxDecoration(
                    borderRadius: defaultBorderRadius,
                    border: colors['border'] != null
                        ? Border.all(color: colors['border']!, width: 1)
                        : null,
                  ),
                  child: buttonChild,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case NButtonSize.xs:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case NButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case NButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case NButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case NButtonSize.xl:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 16);
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case NButtonSize.xs:
        return 12;
      case NButtonSize.sm:
        return 14;
      case NButtonSize.md:
        return 16;
      case NButtonSize.lg:
        return 18;
      case NButtonSize.xl:
        return 20;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case NButtonSize.xs:
      case NButtonSize.sm:
        return 16;
      case NButtonSize.md:
      case NButtonSize.lg:
        return 20;
      case NButtonSize.xl:
        return 24;
    }
  }

  NComponentColor get _componentColor =>
      NComponentColor.values[widget.color.index];

  Map<String, Color?> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor);
    final neutralFg = widget.color == NButtonColor.neutral
        ? NTokens.bgDefault(context)
        : c.foreground;

    switch (widget.variant) {
      case NButtonVariant.solid:
        return {'background': c.main, 'foreground': neutralFg, 'border': null};
      case NButtonVariant.outline:
        return {
          'background': Colors.transparent,
          'foreground': c.main,
          'border': NTokens.borderDefault(context)
        };
      case NButtonVariant.soft:
        return {'background': c.softBg, 'foreground': c.main, 'border': null};
      case NButtonVariant.subtle:
        return {
          'background': c.softBg,
          'foreground': c.main,
          'border': c.main.withValues(alpha: 0.3)
        };
      case NButtonVariant.ghost:
        return {
          'background': Colors.transparent,
          'foreground': c.main,
          'border': null
        };
      case NButtonVariant.link:
        return {
          'background': Colors.transparent,
          'foreground': c.main,
          'border': null
        };
    }
  }
}
