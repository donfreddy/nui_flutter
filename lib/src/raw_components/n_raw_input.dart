import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A completely unstyled text-input primitive.
///
/// [NRawInput] is a thin, opinionated wrapper around [TextField] that:
/// - Removes all Material decoration (no border, no underline, no fill).
/// - Exposes the full [TextField] API.
/// - Forwards [focusNode], [controller], and all text-input options unchanged.
///
/// Use this when the built-in [NInput] doesn't fit your design, or when
/// building a custom input field from scratch.
///
/// ## Example
///
/// ```dart
/// NRawInput(
///   controller: _ctrl,
///   placeholder: 'Search…',
///   style: TextStyle(fontSize: 16, color: Colors.white),
///   decoration: BoxDecoration(
///     color: Colors.black54,
///     borderRadius: BorderRadius.circular(12),
///   ),
///   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
/// )
/// ```
///
/// See also:
/// - [NInput]: the fully-styled NUI text input.
/// - [TextField]: the underlying Flutter widget.
class NRawInput extends StatelessWidget {
  /// Creates an unstyled text-input primitive.
  const NRawInput({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.placeholderStyle,
    this.style,
    this.decoration,
    this.contentPadding,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.enabled = true,
    this.readOnly = false,
    this.showCursor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionControls,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableInteractiveSelection = true,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.expands = false,
    this.autofocus = false,
    this.buildCounter,
    this.inputFormatters,
  });

  /// Controls the text being edited. When `null`, an internal controller is used.
  final TextEditingController? controller;

  /// An optional focus node for controlling focus programmatically.
  final FocusNode? focusNode;

  /// Placeholder text shown when the field is empty.
  final String? placeholder;

  /// Style applied to the placeholder text.
  final TextStyle? placeholderStyle;

  /// Style applied to the entered text.
  final TextStyle? style;

  /// Optional [BoxDecoration] to wrap the field. When `null`, no decoration
  /// is applied: the [TextField] renders inline.
  final BoxDecoration? decoration;

  /// Content padding inside the field. Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? contentPadding;

  /// The keyboard type to display (text, number, email, …).
  final TextInputType? keyboardType;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// How text is auto-capitalized.
  final TextCapitalization textCapitalization;

  /// Whether to hide the text (password mode).
  final bool obscureText;

  /// The character used to obscure text. Defaults to `•`.
  final String obscuringCharacter;

  /// Whether autocorrect is enabled.
  final bool autocorrect;

  /// Whether to show input suggestions.
  final bool enableSuggestions;

  /// Maximum number of lines. `null` for unlimited.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum number of characters.
  final int? maxLength;

  /// Enforcement for [maxLength].
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Called each time the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (presses the action key).
  final ValueChanged<String>? onSubmitted;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the user taps the field.
  final GestureTapCallback? onTap;

  /// Called when the user taps outside the field.
  final TapRegionCallback? onTapOutside;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the field is read-only (no keyboard popup).
  final bool readOnly;

  /// Whether to show the cursor. `null` follows the platform default.
  final bool? showCursor;

  /// Width of the cursor.
  final double cursorWidth;

  /// Height of the cursor. Defaults to the font size.
  final double? cursorHeight;

  /// Radius of the cursor corners.
  final Radius? cursorRadius;

  /// Color of the cursor.
  final Color? cursorColor;

  /// Custom text selection controls.
  final TextSelectionControls? selectionControls;

  /// Optional scroll controller for the text field's scrollable content.
  final ScrollController? scrollController;

  /// Scroll physics.
  final ScrollPhysics? scrollPhysics;

  /// Autofill hints for OS-level autofill.
  final Iterable<String>? autofillHints;

  /// Restoration ID for state restoration.
  final String? restorationId;

  /// Whether Apple Pencil scribble is enabled.
  final bool scribbleEnabled;

  /// Whether interactive selection (cut/copy/paste) is enabled.
  final bool enableInteractiveSelection;

  /// Strut style for text layout.
  final StrutStyle? strutStyle;

  /// Text alignment.
  final TextAlign textAlign;

  /// Vertical text alignment.
  final TextAlignVertical? textAlignVertical;

  /// Text direction.
  final TextDirection? textDirection;

  /// Whether the field should expand to fill its parent.
  final bool expands;

  /// Whether the field should auto-focus.
  final bool autofocus;

  /// Custom counter widget builder.
  final InputCounterWidgetBuilder? buildCounter;

  /// Input formatters.
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    Widget field = TextField(
      controller: controller,
      focusNode: focusNode,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      onTapOutside: onTapOutside,
      enabled: enabled,
      readOnly: readOnly,
      showCursor: showCursor,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionControls: selectionControls,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      restorationId: restorationId,
      enableInteractiveSelection: enableInteractiveSelection,
      expands: expands,
      autofocus: autofocus,
      buildCounter: buildCounter,
      inputFormatters: inputFormatters,
      // Strip all Material decoration
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: placeholderStyle,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        filled: false,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.zero,
      ),
    );

    if (decoration != null) {
      field = DecoratedBox(
        decoration: decoration!,
        child: field,
      );
    }

    return field;
  }
}
