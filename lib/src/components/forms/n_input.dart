import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';
import 'n_input_theme.dart';

/// The size of an [NInput], affecting padding and font size.
enum NInputSize {
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

/// The visual style of an [NInput].
enum NInputVariant {
  /// White background with a full border.
  outline,

  /// Lightly filled background without a border.
  soft,

  /// White background with a border only at the bottom.
  subtle,

  /// Fully transparent with no border.
  ghost,

  /// Bare text field with no decoration.
  none,
}

/// The semantic color role applied to the focused/active border of an [NInput].
enum NInputColor {
  /// Uses [NTokens.primary] for the focus border.
  primary,

  /// Uses [NTokens.borderDefault] for the focus border.
  neutral,

  /// Uses [NTokens.success] for the focus border.
  success,

  /// Uses [NTokens.error] for the focus border.
  error,

  /// Uses [NTokens.warning] for the focus border.
  warning,

  /// Uses [NTokens.info] for the focus border.
  info,
}

/// A full-featured text input component inspired by Nuxt UI's Input.
///
/// Wraps a Flutter [TextField] with NUI theming, label, helper/error text,
/// leading/trailing widgets, and password/clear/character-count utilities.
///
/// Visual defaults are read from [NInputTheme], which is automatically
/// registered by [NTheme].
///
/// ```dart
/// NInput(
///   label: 'Email',
///   placeholder: 'you@example.com',
///   controller: _emailController,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
///
/// Use named constructors for common patterns:
/// ```dart
/// NInput.amount(label: 'Amount', controller: _ctrl)
/// NInput.phone(label: 'Phone number', controller: _ctrl)
/// NInput.otp(controller: _ctrl, onSubmitted: _verify)
/// ```
class NInput extends StatefulWidget {
  /// An optional label displayed above the field.
  final String? label;

  /// Placeholder text shown when the field is empty.
  final String? placeholder;

  /// Helper text shown below the field in a muted style.
  final String? helperText;

  /// Error message shown below the field in red.
  ///
  /// When non-null and non-empty, it overrides [helperText] and changes the
  /// border color to the error token.
  final String? errorText;

  /// An external controller for reading and writing the input value.
  ///
  /// When `null`, an internal controller is created automatically.
  final TextEditingController? controller;

  /// Initial value set on the internal controller when [controller] is `null`.
  final String? initialValue;

  /// The size of the input. Defaults to [NInputSize.md].
  final NInputSize size;

  /// The visual style of the input. Defaults to [NInputVariant.outline].
  final NInputVariant variant;

  /// The semantic color role for the focus/active border.
  /// Defaults to [NInputColor.primary].
  final NInputColor color;

  /// An optional widget placed at the start of the field (e.g., an icon).
  final Widget? leading;

  /// An optional widget placed at the end of the field (e.g., an icon or button).
  final Widget? trailing;

  /// Static text displayed as a prefix inside the field (e.g., a currency symbol).
  final String? leadingText;

  /// Static text displayed as a suffix inside the field (e.g., a unit label).
  final String? trailingText;

  /// When `true`, the field is non-interactive and rendered with a muted style.
  final bool disabled;

  /// When `true`, adds a red asterisk after [label] to mark the field as required.
  final bool required;

  /// When `true`, the input text is obscured. Combine with [passwordToggle] for a
  /// visibility toggle button.
  final bool obscureText;

  /// When `true` and [obscureText] is also `true`, renders an eye icon that
  /// toggles visibility.
  final bool passwordToggle;

  /// When `true`, shows a loading indicator in the leading position.
  final bool loading;

  /// When `true`, renders a clear button when the field has content.
  final bool clearable;

  /// When `true` and [maxLength] is set, shows a character count badge.
  final bool showCharacterCount;

  /// When `true`, renders the focus-state border even when the field is not focused.
  final bool highlight;

  /// The keyboard type to display. Passed directly to [TextField.keyboardType].
  final TextInputType? keyboardType;

  /// The action button on the keyboard. Passed to [TextField.textInputAction].
  final TextInputAction? textInputAction;

  /// Maximum number of visible lines. Defaults to 1. Set to `null` for unlimited.
  final int? maxLines;

  /// Minimum number of visible lines.
  final int? minLines;

  /// Maximum number of characters allowed. When set, [showCharacterCount] can
  /// display progress.
  final int? maxLength;

  /// Additional input formatters applied to the field.
  final List<TextInputFormatter>? inputFormatters;

  /// Called whenever the value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Called when editing is complete (e.g., user presses Done).
  final VoidCallback? onEditingComplete;

  /// Called when the user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Overrides the field's corner radius.
  final BorderRadius? borderRadius;

  /// An optional external [FocusNode]. When `null`, an internal one is created.
  final FocusNode? focusNode;

  /// When `true`, the field requests focus on first build.
  final bool autofocus;

  /// When `true`, the field is visible but not editable.
  final bool readOnly;

  /// Creates a general-purpose [NInput].
  const NInput({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.size = NInputSize.md,
    this.variant = NInputVariant.outline,
    this.color = NInputColor.primary,
    this.leading,
    this.trailing,
    this.leadingText,
    this.trailingText,
    this.disabled = false,
    this.required = false,
    this.obscureText = false,
    this.passwordToggle = false,
    this.loading = false,
    this.clearable = false,
    this.showCharacterCount = false,
    this.highlight = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
  });

  /// Creates an input pre-configured for monetary amounts.
  ///
  /// Sets [keyboardType] to [TextInputType.number], defaults [size] to
  /// [NInputSize.lg], and accepts an optional trailing currency label via
  /// [trailingText].
  NInput.amount({
    super.key,
    required String this.label,
    this.controller,
    this.focusNode,
    this.onChanged,
    String? error,
    this.disabled = false,
    this.helperText,
    this.placeholder,
    this.initialValue,
    this.size = NInputSize.lg,
    this.variant = NInputVariant.outline,
    this.color = NInputColor.primary,
    this.leading,
    this.trailing,
    this.leadingText,
    String trailingText = '',
    this.required = false,
    this.obscureText = false,
    this.passwordToggle = false,
    this.loading = false,
    this.clearable = false,
    this.showCharacterCount = false,
    this.highlight = false,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.borderRadius,
    this.autofocus = false,
    this.readOnly = false,
  })  : errorText = error,
        keyboardType = TextInputType.number,
        trailingText = trailingText.isNotEmpty ? trailingText : null;

  /// Creates an input pre-configured for phone number entry.
  ///
  /// Sets [keyboardType] to [TextInputType.phone] and prepends `+237 ` as
  /// [leadingText]. Override [leadingText] is not available through this
  /// constructor; use the base [NInput] constructor instead.
  const NInput.phone({
    super.key,
    required String this.label,
    this.controller,
    this.focusNode,
    this.onChanged,
    String? error,
    this.disabled = false,
    this.helperText,
    this.placeholder,
    this.initialValue,
    this.size = NInputSize.md,
    this.variant = NInputVariant.outline,
    this.color = NInputColor.primary,
    this.leading,
    this.trailing,
    this.trailingText,
    this.required = false,
    this.obscureText = false,
    this.passwordToggle = false,
    this.loading = false,
    this.clearable = false,
    this.showCharacterCount = false,
    this.highlight = false,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.borderRadius,
    this.autofocus = false,
    this.readOnly = false,
  })  : errorText = error,
        keyboardType = TextInputType.phone,
        leadingText = '+237 ';

  /// Creates an input pre-configured for one-time password (OTP) entry.
  ///
  /// Sets [keyboardType] to [TextInputType.number], enables digit-only
  /// formatting, defaults [maxLength] to 6, and enables [autofocus].
  NInput.otp({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    String? error,
    this.disabled = false,
    this.helperText,
    this.placeholder,
    this.initialValue,
    this.size = NInputSize.lg,
    this.variant = NInputVariant.outline,
    this.color = NInputColor.primary,
    this.leading,
    this.trailing,
    this.leadingText,
    this.trailingText,
    this.required = false,
    this.obscureText = false,
    this.passwordToggle = false,
    this.loading = false,
    this.clearable = false,
    this.showCharacterCount = false,
    this.highlight = false,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onTap,
    this.onEditingComplete,
    this.borderRadius,
    this.autofocus = true,
    this.readOnly = false,
  })  : label = null,
        errorText = error,
        keyboardType = TextInputType.number,
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null)
            LengthLimitingTextInputFormatter(maxLength)
          else
            LengthLimitingTextInputFormatter(6),
        ];

  @override
  State<NInput> createState() => _NInputState();
}

class _NInputState extends State<NInput> with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late final AnimationController _loadingCtrl;
  late final Animation<double> _loadingRotation;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
    _controller.addListener(() => setState(() {}));
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
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _loadingCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading != oldWidget.loading) {
      if (widget.loading) {
        _loadingCtrl.repeat();
      } else {
        _loadingCtrl.stop();
      }
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  double _getFontSize() {
    switch (widget.size) {
      case NInputSize.xs:
        return 12;
      case NInputSize.sm:
        return 13;
      case NInputSize.md:
        return 14;
      case NInputSize.lg:
        return 15;
      case NInputSize.xl:
        return 16;
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    switch (widget.size) {
      case NInputSize.xs:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
      case NInputSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case NInputSize.md:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 10);
      case NInputSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case NInputSize.xl:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 14);
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.disabled) return NTokens.bgMuted(context);
    switch (widget.variant) {
      case NInputVariant.outline:
      case NInputVariant.subtle:
        return NTokens.bgDefault(context);
      case NInputVariant.soft:
        return NTokens.bgElevated(context).withValues(alpha: 0.5);
      case NInputVariant.ghost:
      case NInputVariant.none:
        return Colors.transparent;
    }
  }

  NComponentColor _getInputComponentColor() {
    return switch (widget.color) {
      NInputColor.primary => NComponentColor.primary,
      NInputColor.neutral => NComponentColor.neutral,
      NInputColor.success => NComponentColor.success,
      NInputColor.error => NComponentColor.error,
      NInputColor.warning => NComponentColor.warning,
      NInputColor.info => NComponentColor.info,
    };
  }

  Color _getBorderColor(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    if (hasError) return NTokens.error(context);
    if (_isFocused || widget.highlight) {
      return NComponentColors.resolve(
        context,
        _getInputComponentColor(),
        neutralMain: (ctx) => NTokens.borderDefault(ctx),
      ).main;
    }
    if (widget.variant == NInputVariant.outline ||
        widget.variant == NInputVariant.subtle) {
      return NTokens.borderDefault(context);
    }
    return Colors.transparent;
  }

  Widget? _buildLeading(BuildContext context) {
    if (widget.loading) {
      final theme =
          Theme.of(context).extension<NInputTheme>() ?? const NInputTheme();
      return AnimatedBuilder(
        animation: _loadingCtrl,
        builder: (_, child) => Transform.rotate(
          angle: _loadingRotation.value,
          child: child,
        ),
        child: Icon(
          theme.loadingIcon ?? LucideIcons.loader,
          size: 16,
          color: NTokens.textMuted(context),
        ),
      );
    }
    return widget.leading;
  }

  Widget? _buildTrailing(BuildContext context) {
    final children = <Widget>[];
    if (widget.showCharacterCount && widget.maxLength != null) {
      children.add(
        Text(
          '${_controller.text.length}/${widget.maxLength}',
          style: TextStyle(fontSize: 12, color: NTokens.textMuted(context)),
        ),
      );
    }
    if (widget.clearable && _controller.text.isNotEmpty && !widget.disabled) {
      children.add(
        GestureDetector(
          onTap: _handleClear,
          child:
              Icon(LucideIcons.x, size: 16, color: NTokens.textMuted(context)),
        ),
      );
    }
    if (widget.obscureText && widget.passwordToggle) {
      children.add(
        GestureDetector(
          onTap: () => setState(() => _obscureText = !_obscureText),
          child: Icon(
            _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
            size: 18,
            color: NTokens.textMuted(context),
          ),
        ),
      );
    }
    if (widget.trailing != null) children.add(widget.trailing!);
    if (children.isEmpty) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children
          .map(
              (w) => Padding(padding: const EdgeInsets.only(left: 8), child: w))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final fontSize = _getFontSize();
    final contentPadding = _getContentPadding();
    final theme =
        Theme.of(context).extension<NInputTheme>() ?? const NInputTheme();
    final borderRadius =
        widget.borderRadius ?? BorderRadius.circular(theme.radius);
    final backgroundColor = _getBackgroundColor(context);
    final borderColor = _getBorderColor(context);
    final leadingWidget = _buildLeading(context);
    final trailingWidget = _buildTrailing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: NTokens.textDefault(context)),
              ),
              if (widget.required)
                Text(' *',
                    style:
                        TextStyle(fontSize: 14, color: NTokens.error(context))),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Semantics(
          textField: true,
          enabled: !widget.disabled && !widget.loading,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: !widget.disabled && !widget.loading,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            style: TextStyle(
              fontSize: fontSize,
              color: widget.disabled || widget.loading
                  ? NTokens.textDisabled(context)
                  : NTokens.textDefault(context),
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                  fontSize: fontSize, color: NTokens.textMuted(context)),
              prefixIcon: leadingWidget != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: leadingWidget)
                  : (widget.leadingText != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            widget.leadingText!,
                            style: TextStyle(
                                fontSize: fontSize,
                                color: NTokens.textMuted(context)),
                          ),
                        )
                      : null),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: trailingWidget != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12, left: 8),
                      child: trailingWidget)
                  : (widget.trailingText != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            widget.trailingText!,
                            style: TextStyle(
                                fontSize: fontSize,
                                color: NTokens.textMuted(context)),
                          ),
                        )
                      : null),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              filled: true,
              fillColor: backgroundColor,
              contentPadding: contentPadding,
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                    color: borderColor,
                    width: _isFocused || hasError || widget.highlight ? 2 : 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                    color: borderColor, width: widget.highlight ? 2 : 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: NTokens.error(context), width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: NTokens.error(context), width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide:
                    BorderSide(color: NTokens.borderMuted(context), width: 1),
              ),
              counterText: '',
            ),
          ),
        ),
        if (widget.helperText != null || hasError) ...[
          const SizedBox(height: 6),
          Text(
            hasError ? widget.errorText! : widget.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: hasError
                  ? NTokens.error(context)
                  : NTokens.textMuted(context),
            ),
          ),
        ],
      ],
    );
  }
}
