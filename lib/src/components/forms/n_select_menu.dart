import 'package:nui_flutter/nui_flutter.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The size of an [NSelectMenu], affecting padding and font size.
///
/// Mirrors [NInputSize] and Nuxt UI's `USelect` size scale so a select
/// trigger lines up visually with a sibling [NInput] in the same form.
enum NSelectMenuSize {
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

/// The visual style of an [NSelectMenu].
///
/// Mirrors [NInputVariant]: form fields in this design system use this
/// 5-value set (not the shared [NVariant]) because `none` has no equivalent
/// there and a field never needs `link`.
enum NSelectMenuVariant {
  /// White background with a full border.
  outline,

  /// Lightly filled background without a border.
  soft,

  /// White background with a muted border.
  subtle,

  /// Transparent background with no border.
  ghost,

  /// No background, no border, and no decoration.
  none,
}

/// The row type of an entry in an [NSelectMenu]'s item list.
enum NSelectMenuItemType {
  /// A selectable value row.
  item,

  /// A non-selectable section header label.
  label,

  /// A horizontal rule separating item groups.
  separator,
}

/// A single entry in the list rendered by an [NSelectMenu].
///
/// Three special factory constructors simplify creating separators and labels:
/// ```dart
/// NSelectMenuItem.separator()
/// NSelectMenuItem.label('Group A')
/// NSelectMenuItem(value: 'usd', label: 'US Dollar')
/// ```
class NSelectMenuItem<T> {
  final T? _value;

  /// The value of the item.
  ///
  /// Throws a [StateError] if accessed on an item where [type] is
  /// [NSelectMenuItemType.separator] or [NSelectMenuItemType.label].
  T get value {
    if (type == NSelectMenuItemType.item) return _value as T;
    throw StateError('Separator or label items do not have a value.');
  }

  /// The text displayed in the menu row.
  final String label;

  /// The type of this entry. Defaults to [NSelectMenuItemType.item].
  final NSelectMenuItemType type;

  /// An optional icon shown to the left of [label].
  final IconData? icon;

  /// An optional avatar widget shown to the left of [label].
  final Widget? avatar;

  /// An optional widget shown at the trailing edge of the row.
  final Widget? trailing;

  /// When `true`, this item cannot be selected.
  final bool disabled;

  /// An optional secondary description shown below [label].
  final String? description;

  /// Creates a selectable [NSelectMenuItem] with the given [value] and [label].
  const NSelectMenuItem({
    required T value,
    required this.label,
    this.type = NSelectMenuItemType.item,
    this.icon,
    this.avatar,
    this.trailing,
    this.disabled = false,
    this.description,
  }) : _value = value;

  const NSelectMenuItem._internal({
    required this.type,
    required this.label,
    this.icon,
    this.avatar,
    this.trailing,
    this.disabled = false,
    this.description,
  }) : _value = null;

  /// Creates a horizontal separator row.
  factory NSelectMenuItem.separator() {
    return const NSelectMenuItem._internal(
        label: '', type: NSelectMenuItemType.separator);
  }

  /// Creates a non-selectable group label row.
  factory NSelectMenuItem.label(String label) {
    return NSelectMenuItem._internal(
        label: label, type: NSelectMenuItemType.label);
  }
}

/// A styled select / dropdown form field, mirroring Nuxt UI's `USelect`
/// (single/multiple selection) with `USelectMenu`'s search feature layered
/// on top.
///
/// Wraps a tap-triggered overlay menu that shows a list of [NSelectMenuItem]
/// values. Supports single and multiple selection, optional search, clearable
/// values, loading state, and validation error display. Sizing, variants, and
/// the focus-border/error/disabled treatment mirror [NInput] so the two read
/// as siblings in the same form.
///
/// ```dart
/// NSelectMenu<String>(
///   label: 'Currency',
///   placeholder: 'Select a currency',
///   items: [
///     NSelectMenuItem(value: 'xaf', label: 'FCFA'),
///     NSelectMenuItem(value: 'usd', label: 'USD'),
///   ],
///   value: _currency,
///   onChanged: (v) => setState(() => _currency = v),
/// )
/// ```
class NSelectMenu<T> extends StatefulWidget {
  /// An optional label displayed above the field.
  final String? label;

  /// Placeholder text shown when no value is selected.
  final String? placeholder;

  /// Helper text shown below the field in a muted style.
  final String? helperText;

  /// Error message shown below the field in red.
  ///
  /// When non-null and non-empty, it overrides [helperText] and changes the
  /// focus border color to the error token.
  final String? errorText;

  /// The list of selectable items.
  final List<NSelectMenuItem<T>> items;

  /// The currently selected value (single-select mode).
  final T? value;

  /// The currently selected values (multi-select mode). Use alongside [onChangedMultiple].
  final List<T>? values;

  /// Called when the selected value changes in single-select mode.
  final ValueChanged<T?>? onChanged;

  /// Called when the selected values change in multi-select mode.
  final ValueChanged<List<T>>? onChangedMultiple;

  /// When `true`, adds a red asterisk after [label] to mark the field as required.
  final bool required;

  /// When `true`, the field is non-interactive.
  final bool disabled;

  /// When `true`, shows a loading spinner as the leading widget.
  final bool loading;

  /// An optional icon shown as a static prefix inside the field.
  final IconData? leadingIcon;

  /// When `true`, an inline search input is shown at the top of the menu.
  final bool searchable;

  /// Placeholder text inside the search field. Defaults to `'Search...'`.
  final String searchPlaceholder;

  /// When `true`, a clear (X) button appears when the field has a value.
  final bool clearable;

  /// The size of the dropdown trigger field. Defaults to [NSelectMenuSize.md].
  final NSelectMenuSize size;

  /// The visual style of the trigger field. Defaults to [NSelectMenuVariant.outline].
  final NSelectMenuVariant variant;

  /// The semantic color role applied to the focused/open border. Defaults to
  /// [NColorRole.primary].
  final NColorRole color;

  /// When `true`, renders the open-state border even while closed.
  final bool highlight;

  /// When `true`, multiple items can be selected simultaneously.
  /// Use [values] and [onChangedMultiple] in multi-select mode.
  final bool multiple;

  /// Creates an [NSelectMenu].
  const NSelectMenu({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    required this.items,
    this.value,
    this.values,
    this.onChanged,
    this.onChangedMultiple,
    this.required = false,
    this.disabled = false,
    this.loading = false,
    this.leadingIcon,
    this.searchable = false,
    this.searchPlaceholder = 'Search...',
    this.clearable = true,
    this.size = NSelectMenuSize.md,
    this.variant = NSelectMenuVariant.outline,
    this.color = NColorRole.primary,
    this.highlight = false,
    this.multiple = false,
  });

  @override
  State<NSelectMenu<T>> createState() => _NSelectMenuState<T>();
}

class _NSelectMenuState<T> extends State<NSelectMenu<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _loadingCtrl;
  late final Animation<double> _loadingRotation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
    _loadingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadingRotation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_loadingCtrl);
    if (widget.loading) _loadingCtrl.repeat();
  }

  @override
  void didUpdateWidget(NSelectMenu<T> oldWidget) {
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
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.dispose();
    _loadingCtrl.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (widget.disabled || widget.loading) return;
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  void _handleClear() {
    if (widget.multiple) {
      widget.onChangedMultiple?.call([]);
    } else {
      widget.onChanged?.call(null);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    final borderRadius = context.nui.radius.radiusMd;
    final shadows = context.nui.shadows.lg;

    return OverlayEntry(
      // A CallbackShortcuts of its own: when `searchable` is true, the
      // search NInput autofocuses, moving keyboard focus into this overlay
      // and out of the trigger's CallbackShortcuts subtree. Flutter's
      // shortcut resolution walks up the *focus* tree from whatever node is
      // currently focused, so binding Escape here (an ancestor of the
      // search field) keeps it working regardless of which descendant has
      // focus.
      builder: (context) => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): _removeOverlay,
        },
        child: GestureDetector(
          onTap: _removeOverlay,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height + 4),
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    child: _DropdownMenu<T>(
                      items: widget.items,
                      selectedValue: widget.value,
                      selectedValues: widget.values ?? [],
                      multiple: widget.multiple,
                      borderRadius: borderRadius,
                      shadows: shadows,
                      onSelected: (value) {
                        if (widget.multiple) {
                          final currentValues = List<T>.from(widget.values ?? []);
                          if (currentValues.contains(value)) {
                            currentValues.remove(value);
                          } else {
                            currentValues.add(value);
                          }
                          widget.onChangedMultiple?.call(currentValues);
                        } else {
                          widget.onChanged?.call(value);
                          _removeOverlay();
                        }
                      },
                      searchable: widget.searchable,
                      searchPlaceholder: widget.searchPlaceholder,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getFontSize() {
    switch (widget.size) {
      case NSelectMenuSize.xs:
        return 12;
      case NSelectMenuSize.sm:
        return 13;
      case NSelectMenuSize.md:
        return 14;
      case NSelectMenuSize.lg:
        return 15;
      case NSelectMenuSize.xl:
        return 16;
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    const sp = NSpacing.standard;
    switch (widget.size) {
      case NSelectMenuSize.xs:
        return EdgeInsets.symmetric(horizontal: sp.s2_5, vertical: sp.s1_5);
      case NSelectMenuSize.sm:
        return EdgeInsets.symmetric(horizontal: sp.s3, vertical: sp.s2);
      case NSelectMenuSize.md:
        return EdgeInsets.symmetric(horizontal: sp.s3_5, vertical: sp.s2_5);
      case NSelectMenuSize.lg:
        return EdgeInsets.symmetric(horizontal: sp.s4, vertical: sp.s3);
      case NSelectMenuSize.xl:
        return EdgeInsets.symmetric(horizontal: sp.s4, vertical: sp.s3_5);
    }
  }

  Color _getBackgroundColor() {
    if (widget.disabled) return context.nui.colors.bgMuted;
    switch (widget.variant) {
      case NSelectMenuVariant.outline:
      case NSelectMenuVariant.subtle:
        return context.nui.colors.bg;
      case NSelectMenuVariant.soft:
        return context.nui.colors.bgElevated.withValues(alpha: 0.5);
      case NSelectMenuVariant.ghost:
      case NSelectMenuVariant.none:
        return Colors.transparent;
    }
  }

  bool _showBorder() =>
      widget.variant == NSelectMenuVariant.outline ||
      widget.variant == NSelectMenuVariant.subtle;

  Color _getBorderColor() {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    if (hasError) return context.nui.colors.error;
    if (_isOpen || _isFocused || widget.highlight) {
      return context.nui.colors.role(widget.color);
    }
    if (!_showBorder()) return Colors.transparent;
    return context.nui.colors.border;
  }

  String _getDisplayText() {
    if (widget.multiple) {
      if (widget.values == null || widget.values!.isEmpty) {
        return widget.placeholder ?? '';
      }
      return widget.items
          .where((i) =>
              i.type == NSelectMenuItemType.item &&
              widget.values!.contains(i.value))
          .map((i) => i.label)
          .join(', ');
    }
    if (widget.value == null) return widget.placeholder ?? '';
    final match = widget.items.cast<NSelectMenuItem<T>?>().firstWhere(
          (i) => i!.type == NSelectMenuItemType.item && i.value == widget.value,
          orElse: () => null,
        );
    return match?.label ?? widget.placeholder ?? '';
  }

  Widget? _getLeadingWidget() {
    if (widget.loading) {
      final theme = Theme.of(context).extension<NInputTheme>() ?? const NInputTheme();
      return AnimatedBuilder(
        animation: _loadingCtrl,
        builder: (_, child) => Transform.rotate(
          angle: _loadingRotation.value,
          child: child,
        ),
        child: Icon(
          theme.loadingIcon ?? NIcons.loader,
          size: 16,
          color: context.nui.colors.textMuted,
        ),
      );
    }
    if (widget.leadingIcon != null) {
      return Icon(widget.leadingIcon,
          size: 18, color: context.nui.colors.textMuted);
    }
    if (!widget.multiple && widget.value != null) {
      final selectedItem = widget.items.cast<NSelectMenuItem<T>?>().firstWhere(
            (i) =>
                i!.type == NSelectMenuItemType.item && i.value == widget.value,
            orElse: () => null,
          );
      if (selectedItem?.avatar != null) return selectedItem!.avatar;
      if (selectedItem?.icon != null) {
        return Icon(selectedItem!.icon,
            size: 18, color: context.nui.colors.textMuted);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final hasValue = widget.multiple
        ? (widget.values != null && widget.values!.isNotEmpty)
        : widget.value != null;
    final leadingWidget = _getLeadingWidget();
    final showClear =
        widget.clearable && hasValue && !widget.disabled && !widget.loading;
    final borderRadius = context.nui.radius.radiusMd;
    final borderWidth = _isOpen || _isFocused || hasError || widget.highlight ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(widget.label!,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.nui.colors.text)),
              if (widget.required)
                Text(' *',
                    style: TextStyle(
                        fontSize: 14, color: context.nui.colors.error)),
            ],
          ),
          const SizedBox(height: 6),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.enter): _toggleDropdown,
              const SingleActivator(LogicalKeyboardKey.space): _toggleDropdown,
              const SingleActivator(LogicalKeyboardKey.escape): () {
                if (_isOpen) _removeOverlay();
              },
            },
            child: Focus(
              focusNode: _focusNode,
              canRequestFocus: !widget.disabled && !widget.loading,
              child: GestureDetector(
                onTap: () {
                  _focusNode.requestFocus();
                  _toggleDropdown();
                },
                child: Container(
                  padding: _getContentPadding(),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: borderRadius,
                    border: Border.all(color: _getBorderColor(), width: borderWidth),
                  ),
                  child: Row(
                    children: [
                      if (leadingWidget != null) ...[
                        leadingWidget,
                        const SizedBox(width: 8)
                      ],
                      Expanded(
                        child: Text(
                          _getDisplayText(),
                          style: TextStyle(
                              fontSize: _getFontSize(),
                              color: hasValue
                                  ? context.nui.colors.text
                                  : context.nui.colors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showClear) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                            onTap: _handleClear,
                            child: Icon(NIcons.x,
                                size: 16, color: context.nui.colors.textMuted)),
                      ],
                      const SizedBox(width: 8),
                      Icon(
                          _isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: context.nui.colors.textMuted),
                    ],
                  ),
                ),
              ),
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
                    ? context.nui.colors.error
                    : context.nui.colors.textMuted),
          ),
        ],
      ],
    );
  }
}

class _DropdownMenu<T> extends StatefulWidget {
  final List<NSelectMenuItem<T>> items;
  final T? selectedValue;
  final List<T> selectedValues;
  final bool multiple;
  final ValueChanged<T> onSelected;
  final bool searchable;
  final String searchPlaceholder;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  const _DropdownMenu({
    required this.items,
    required this.selectedValue,
    required this.selectedValues,
    required this.multiple,
    required this.onSelected,
    required this.searchable,
    required this.searchPlaceholder,
    required this.borderRadius,
    required this.shadows,
  });

  @override
  State<_DropdownMenu<T>> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<NSelectMenuItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) =>
                item.type == NSelectMenuItemType.separator ||
                item.type == NSelectMenuItemType.label ||
                item.label
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  bool _isSelected(T value) => widget.multiple
      ? widget.selectedValues.contains(value)
      : value == widget.selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: context.nui.colors.bgElevated,
        borderRadius: widget.borderRadius,
        border: Border.all(color: context.nui.colors.border),
        boxShadow: widget.shadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.searchable) ...[
            Padding(
              padding: const EdgeInsets.all(8),
              child: NInput(
                controller: _searchController,
                placeholder: widget.searchPlaceholder,
                size: NInputSize.sm,
                autofocus: true,
                borderRadius: widget.borderRadius,
                leading: Icon(NIcons.search,
                    size: 16, color: context.nui.colors.textMuted),
              ),
            ),
            Divider(
                height: 1, thickness: 1, color: context.nui.colors.borderMuted),
          ],
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                if (item.type == NSelectMenuItemType.separator) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Divider(
                        height: 1,
                        thickness: 1,
                        color: context.nui.colors.borderMuted),
                  );
                }
                if (item.type == NSelectMenuItemType.label) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      item.label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.nui.colors.textMuted,
                          letterSpacing: 0.5),
                    ),
                  );
                }
                final isSelected = _isSelected(item.value);
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item.disabled
                        ? null
                        : () => widget.onSelected(item.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      color: isSelected
                          ? context.nui.colors.bgMuted
                          : Colors.transparent,
                      child: Row(
                        children: [
                          if (item.avatar != null) ...[
                            SizedBox(width: 24, height: 24, child: item.avatar),
                            const SizedBox(width: 8),
                          ] else if (item.icon != null) ...[
                            Icon(item.icon,
                                size: 18,
                                color: item.disabled
                                    ? context.nui.colors.textMuted
                                    : context.nui.colors.textMuted),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: item.disabled
                                        ? context.nui.colors.textMuted
                                        : context.nui.colors.text,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                                if (item.description != null)
                                  Text(item.description!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: context.nui.colors.textMuted)),
                              ],
                            ),
                          ),
                          if (item.trailing != null) ...[
                            const SizedBox(width: 8),
                            item.trailing!
                          ],
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.check,
                                size: 18, color: context.nui.colors.primary),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
