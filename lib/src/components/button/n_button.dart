import 'package:nui_flutter/nui_flutter.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The size of an [NButton], controlling padding, font size, and icon size.
enum NButtonSize {
  xs,
  sm,
  md,
  lg,
  xl,
}

/// A versatile button component inspired by Nuxt UI's Button.
///
/// Supports six [NVariant] styles, five [NButtonSize] options, and seven
/// [NColorRole] roles. All visual defaults are read from [NButtonTheme],
/// which is automatically registered by [NTheme].
///
/// At least one of [label] or [child] must be provided.
///
/// ```dart
/// NButton(
///   label: 'Save',
///   onPressed: () => save(),
///   color: NColorRole.success,
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
  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final NVariant variant;
  final NButtonSize size;
  final NColorRole color;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;
  final bool disabled;
  final bool block;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool roundedFull;

  const NButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = NVariant.solid,
    this.size = NButtonSize.md,
    this.color = NColorRole.primary,
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

  const NButton.outline({
    Key? key,
    String? label,
    Widget? child,
    required VoidCallback? onPressed,
    NColorRole color = NColorRole.primary,
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
          variant: NVariant.outline,
          color: color,
          size: size,
          leading: leading,
          trailing: trailing,
          loading: loading,
          block: block,
          roundedFull: roundedFull,
        );

  const NButton.ghost({
    Key? key,
    String? label,
    Widget? child,
    required VoidCallback? onPressed,
    NColorRole color = NColorRole.primary,
    NButtonSize size = NButtonSize.md,
    Widget? leading,
    Widget? trailing,
    bool block = false,
  }) : this(
          key: key,
          label: label,
          child: child,
          onPressed: onPressed,
          variant: NVariant.ghost,
          color: color,
          size: size,
          leading: leading,
          trailing: trailing,
          block: block,
          roundedFull: true,
        );

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
          variant: NVariant.solid,
          color: NColorRole.error,
          size: size,
          loading: loading,
          block: block,
          roundedFull: true,
        );

  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> with TickerProviderStateMixin {
  late final AnimationController _loadingCtrl;
  late final Animation<double> _loadingRotation;

  @override
  void initState() {
    super.initState();
    assert(NVariantSupport.button.contains(widget.variant),
        'Variant ${widget.variant} is not supported by NButton.');
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadingRotation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_loadingCtrl);
    if (widget.loading) _loadingCtrl.repeat();
  }

  @override
  void dispose() {
    _loadingCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading != oldWidget.loading) {
      if (widget.loading) {
        _loadingCtrl.repeat();
      } else {
        _loadingCtrl.stop();
      }
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
    final resolved = NVariantResolver.resolve(
        widget.color, widget.variant, context.nui.colors);
    final loadingIcon = theme.loadingIcon;

    Widget buttonChild = Row(
      mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          AnimatedBuilder(
            animation: _loadingCtrl,
            builder: (_, child) => Transform.rotate(
              angle: _loadingRotation.value,
              child: child,
            ),
            child: Icon(
              loadingIcon ?? NIcons.loader,
              size: iconSize,
              color: resolved.foreground,
            ),
          )
        else if (widget.leading != null)
          IconTheme(
            data: IconThemeData(color: resolved.foreground, size: iconSize),
            child: widget.leading!,
          ),
        if ((widget.loading || widget.leading != null) &&
            (widget.label != null || widget.child != null))
          SizedBox(width: context.nui.spacing.s2),
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: resolved.foreground,
            ),
          )
        else if (widget.child != null)
          DefaultTextStyle(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: resolved.foreground,
            ),
            child: IconTheme(
              data: IconThemeData(color: resolved.foreground, size: iconSize),
              child: widget.child!,
            ),
          ),
        if (widget.trailing != null && !widget.loading) ...[
          SizedBox(width: context.nui.spacing.s2),
          IconTheme(
            data: IconThemeData(color: resolved.foreground, size: iconSize),
            child: widget.trailing!,
          ),
        ],
      ],
    );

    if (widget.variant == NVariant.link) {
      return TextButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: resolved.foreground,
          padding: buttonPadding,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: buttonChild,
      );
    }

    return NPressScale(
      onTap: isDisabled ? null : widget.onPressed,
      enabled: !isDisabled,
      child: Semantics(
        button: true,
        enabled: !isDisabled,
        child: SizedBox(
          width: widget.block ? double.infinity : null,
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Container(
              padding: buttonPadding,
              decoration: BoxDecoration(
                color: resolved.background,
                borderRadius: defaultBorderRadius,
                border: resolved.border != null
                    ? Border.all(color: resolved.border!, width: 1)
                    : null,
              ),
              child: buttonChild,
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    const sp = NSpacing.standard;
    switch (widget.size) {
      case NButtonSize.xs:
        return EdgeInsets.symmetric(horizontal: sp.s3, vertical: sp.s2);
      case NButtonSize.sm:
        return EdgeInsets.symmetric(horizontal: sp.s4, vertical: sp.s2_5);
      case NButtonSize.md:
        return EdgeInsets.symmetric(horizontal: sp.s5, vertical: sp.s3);
      case NButtonSize.lg:
        return EdgeInsets.symmetric(horizontal: sp.s6, vertical: sp.s3_5);
      case NButtonSize.xl:
        return EdgeInsets.symmetric(horizontal: sp.s7, vertical: sp.s4);
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
}
