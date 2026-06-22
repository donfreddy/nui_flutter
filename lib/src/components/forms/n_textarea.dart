import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';
import '../../theme/n_spacing.dart';
import 'n_input_theme.dart';

/// The size of an [NTextarea], affecting padding and font size.
enum NTextareaSize {
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

/// The visual style of an [NTextarea].
enum NTextareaVariant {
  /// White background with a full border.
  outline,

  /// Lightly filled background without a border.
  soft,

  /// White background with a border only at the bottom.
  subtle,

  /// Fully transparent with no border.
  ghost,

  /// Bare textarea with no decoration.
  none,
}

/// The semantic color role applied to the focused border of an [NTextarea].
enum NTextareaColor {
  /// Uses [NTokens.primary] for the focus border.
  primary,

  /// Uses a neutral border color.
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

/// A multi-line text input component for longer form content.
///
/// Wraps a Flutter [TextField] configured as a textarea with NUI theming.
/// Supports labels, error text, leading icons, and auto-resize behavior.
///
/// Visual defaults are read from [NInputTheme], which is automatically
/// registered by [NTheme].
///
/// ```dart
/// NTextarea(
///   label: 'Notes',
///   placeholder: 'Add your notes here...',
///   maxLines: 5,
/// )
/// ```
class NTextarea extends StatefulWidget {
  /// An optional label displayed above the textarea.
  final String? label;

  /// Placeholder text shown when the textarea is empty.
  final String? placeholder;

  /// Helper text shown below the textarea in a muted style.
  final String? helperText;

  /// Error message shown below the textarea in red.
  final String? errorText;

  /// An external controller for reading and writing the input value.
  final TextEditingController? controller;

  /// Initial value set on the internal controller when [controller] is null.
  final String? initialValue;

  /// The size of the textarea. Defaults to [NTextareaSize.md].
  final NTextareaSize size;

  /// The visual style. Defaults to [NTextareaVariant.outline].
  final NTextareaVariant variant;

  /// The semantic color role for the focus border. Defaults to
  /// [NTextareaColor.primary].
  final NTextareaColor color;

  /// An optional widget placed at the start of the field (e.g., an icon).
  final Widget? leading;

  /// When true, the field is non-interactive and rendered with a muted style.
  final bool disabled;

  /// When true, adds a red asterisk after [label] to mark the field as
  /// required.
  final bool required;

  /// When true, shows a loading indicator in the leading position.
  final bool loading;

  /// When true, renders the focus-state border even when unfocused.
  final bool highlight;

  /// The number of visible lines. Defaults to 5.
  final int? maxLines;

  /// The minimum number of visible lines.
  final int? minLines;

  /// Maximum number of characters allowed.
  final int? maxLength;

  /// Called whenever the value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the textarea is tapped.
  final VoidCallback? onTap;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the user submits the textarea.
  final ValueChanged<String>? onSubmitted;

  /// An optional external [FocusNode].
  final FocusNode? focusNode;

  /// When true, the textarea requests focus on first build.
  final bool autofocus;

  /// Creates an [NTextarea].
  const NTextarea({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.size = NTextareaSize.md,
    this.variant = NTextareaVariant.outline,
    this.color = NTextareaColor.primary,
    this.leading,
    this.disabled = false,
    this.required = false,
    this.loading = false,
    this.highlight = false,
    this.maxLines = 5,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<NTextarea> createState() => _NTextareaState();
}

class _NTextareaState extends State<NTextarea> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode
        .addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  double _getFontSize() {
    switch (widget.size) {
      case NTextareaSize.xs:
        return 12;
      case NTextareaSize.sm:
        return 13;
      case NTextareaSize.md:
        return 14;
      case NTextareaSize.lg:
        return 15;
      case NTextareaSize.xl:
        return 16;
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    switch (widget.size) {
      case NTextareaSize.xs:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      case NTextareaSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case NTextareaSize.md:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
      case NTextareaSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
      case NTextareaSize.xl:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 16);
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.disabled) return NTokens.bgMuted(context);
    switch (widget.variant) {
      case NTextareaVariant.outline:
      case NTextareaVariant.subtle:
        return NTokens.bgDefault(context);
      case NTextareaVariant.soft:
        return NTokens.bgElevated(context).withValues(alpha: 0.5);
      case NTextareaVariant.ghost:
      case NTextareaVariant.none:
        return Colors.transparent;
    }
  }

  Color _getBorderColor(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    if (hasError) return NTokens.error(context);
    if (_isFocused || widget.highlight) {
      final c = NComponentColors.resolve(context, _textareaComponentColor(),
          neutralMain: (ctx) => NTokens.borderDefault(ctx));
      return c.main;
    }
    return NTokens.borderDefault(context);
  }

  NComponentColor _textareaComponentColor() {
    return switch (widget.color) {
      NTextareaColor.primary => NComponentColor.primary,
      NTextareaColor.neutral => NComponentColor.neutral,
      NTextareaColor.success => NComponentColor.success,
      NTextareaColor.error => NComponentColor.error,
      NTextareaColor.warning => NComponentColor.warning,
      NTextareaColor.info => NComponentColor.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final fontSize = _getFontSize();
    final contentPadding = _getContentPadding();
    final theme =
        Theme.of(context).extension<NInputTheme>() ?? const NInputTheme();
    final borderRadius = BorderRadius.circular(theme.radius);
    final backgroundColor = _getBackgroundColor(context);
    final borderColor = _getBorderColor(context);

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
                  color: NTokens.textDefault(context),
                ),
              ),
              if (widget.required)
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 14,
                    color: NTokens.error(context),
                  ),
                ),
            ],
          ),
          NSpacing.vertical(NSpacing.s2 - 2),
        ],
        Semantics(
          textField: true,
          enabled: !widget.disabled && !widget.loading,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: !widget.disabled && !widget.loading,
            keyboardType: TextInputType.multiline,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            autofocus: widget.autofocus,
            style: TextStyle(
              fontSize: fontSize,
              color: widget.disabled || widget.loading
                  ? NTokens.textDisabled(context)
                  : NTokens.textDefault(context),
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: fontSize,
                color: NTokens.textMuted(context),
              ),
              prefixIcon: widget.loading
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        theme.loadingIcon ?? Icons.hourglass_empty,
                        size: 16,
                        color: NTokens.textMuted(context),
                      ),
                    )
                  : (widget.leading != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: widget.leading!,
                        )
                      : null),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              filled: true,
              fillColor: backgroundColor,
              contentPadding: contentPadding,
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: borderColor,
                  width: _isFocused || hasError || widget.highlight ? 2 : 1,
                ),
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
          NSpacing.vertical(NSpacing.s2 - 2),
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
