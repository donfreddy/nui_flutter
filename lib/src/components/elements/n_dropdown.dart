import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NDropdownSize { sm, md, lg }

enum NDropdownVariant { outline, soft, subtle, ghost, none }

enum NDropdownItemType { item, label, separator }

enum NDropdownColor {
  primary,
  secondary,
  success,
  info,
  warning,
  error,
  neutral
}

class NDropdownItem<T> {
  final T? _value;

  /// The value of the item.
  ///
  /// Throws a [StateError] if accessed on an item where [type] is
  /// [NDropdownItemType.separator] or [NDropdownItemType.label].
  T get value {
    if (type == NDropdownItemType.item) return _value as T;
    throw StateError('Separator or label items do not have a value.');
  }

  final String label;
  final NDropdownItemType type;
  final IconData? icon;
  final Widget? avatar;
  final Widget? trailing;
  final bool disabled;
  final String? description;

  const NDropdownItem({
    required T value,
    required this.label,
    this.type = NDropdownItemType.item,
    this.icon,
    this.avatar,
    this.trailing,
    this.disabled = false,
    this.description,
  }) : _value = value;

  const NDropdownItem._internal({
    required this.type,
    required this.label,
    this.icon,
    this.avatar,
    this.trailing,
    this.disabled = false,
    this.description,
  }) : _value = null;

  factory NDropdownItem.separator() {
    return const NDropdownItem._internal(
        label: '', type: NDropdownItemType.separator);
  }

  factory NDropdownItem.label(String label) {
    return NDropdownItem._internal(
        label: label, type: NDropdownItemType.label);
  }
}

class NDropdown<T> extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final List<NDropdownItem<T>> items;
  final T? value;
  final List<T>? values;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<List<T>>? onChangedMultiple;
  final bool required;
  final bool disabled;
  final bool loading;
  final IconData? leadingIcon;
  final bool searchable;
  final String searchPlaceholder;
  final bool clearable;
  final NDropdownSize size;
  final NDropdownVariant variant;
  final NDropdownColor color;
  final bool multiple;

  const NDropdown({
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
    this.size = NDropdownSize.md,
    this.variant = NDropdownVariant.outline,
    this.color = NDropdownColor.neutral,
    this.multiple = false,
  });

  @override
  State<NDropdown<T>> createState() => _NDropdownState<T>();
}

class _NDropdownState<T> extends State<NDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
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
    setState(() => _isOpen = false);
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

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4.h),
                child: Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: _DropdownMenu<T>(
                    items: widget.items,
                    selectedValue: widget.value,
                    selectedValues: widget.values ?? [],
                    multiple: widget.multiple,
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
    );
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case NDropdownSize.sm:
        return 8.h;
      case NDropdownSize.md:
        return 10.h;
      case NDropdownSize.lg:
        return 12.h;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case NDropdownSize.sm:
        return 12.w;
      case NDropdownSize.md:
        return 14.w;
      case NDropdownSize.lg:
        return 16.w;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case NDropdownSize.sm:
        return 13.sp;
      case NDropdownSize.md:
        return 14.sp;
      case NDropdownSize.lg:
        return 15.sp;
    }
  }

  bool _showBorder() =>
      widget.variant == NDropdownVariant.outline ||
      widget.variant == NDropdownVariant.subtle;

  NComponentColor _dropdownComponentColor() {
    return switch (widget.color) {
      NDropdownColor.primary => NComponentColor.primary,
      NDropdownColor.secondary => NComponentColor.secondary,
      NDropdownColor.neutral => NComponentColor.neutral,
      NDropdownColor.success => NComponentColor.success,
      NDropdownColor.error => NComponentColor.error,
      NDropdownColor.warning => NComponentColor.warning,
      NDropdownColor.info => NComponentColor.info,
    };
  }

  Color _getBorderColor() {
    if (!_showBorder()) return Colors.transparent;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    if (hasError) return NTokens.error(context);
    if (_isOpen) {
      return NComponentColors.resolve(
        context,
        _dropdownComponentColor(),
        neutralMain: (ctx) => NTokens.borderDefault(ctx),
      ).main;
    }
    return NTokens.borderDefault(context);
  }

  String _getDisplayText() {
    if (widget.multiple) {
      if (widget.values == null || widget.values!.isEmpty) {
        return widget.placeholder ?? '';
      }
      return widget.items
          .where((i) => widget.values!.contains(i.value))
          .map((i) => i.label)
          .join(', ');
    }
    if (widget.value == null) return widget.placeholder ?? '';
    return widget.items
        .firstWhere((i) => i.value == widget.value,
            orElse: () => NDropdownItem(value: '' as T, label: ''))
        .label;
  }

  Widget? _getLeadingWidget() {
    if (widget.loading) {
      return SizedBox(
        width: 16.w,
        height: 16.w,
        child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor:
                AlwaysStoppedAnimation<Color>(NTokens.textMuted(context))),
      );
    }
    if (widget.leadingIcon != null) {
      return Icon(widget.leadingIcon,
          size: 18.sp, color: NTokens.textMuted(context));
    }
    if (!widget.multiple && widget.value != null) {
      final selectedItem = widget.items.firstWhere(
          (i) => i.value == widget.value,
          orElse: () => NDropdownItem(value: '' as T, label: ''));
      if (selectedItem.avatar != null) return selectedItem.avatar;
      if (selectedItem.icon != null) {
        return Icon(selectedItem.icon,
            size: 18.sp, color: NTokens.textMuted(context));
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(widget.label!,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: NTokens.textDefault(context))),
              if (widget.required)
                Text(' *',
                    style: TextStyle(
                        fontSize: 14.sp, color: NTokens.error(context))),
            ],
          ),
          SizedBox(height: 6.h),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _getHorizontalPadding(),
                  vertical: _getVerticalPadding()),
              decoration: BoxDecoration(
                color: widget.disabled
                    ? NTokens.bgMuted(context)
                    : NTokens.bgDefault(context),
                borderRadius: BorderRadius.circular(NTokens.radiusDefault),
                border: Border.all(
                    color: _getBorderColor(),
                    width: _isOpen || hasError ? 2 : 1),
              ),
              child: Row(
                children: [
                  if (leadingWidget != null) ...[
                    leadingWidget,
                    SizedBox(width: 8.w)
                  ],
                  Expanded(
                    child: Text(
                      _getDisplayText(),
                      style: TextStyle(
                          fontSize: _getFontSize(),
                          color: hasValue
                              ? NTokens.textDefault(context)
                              : NTokens.textMuted(context)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showClear) ...[
                    SizedBox(width: 8.w),
                    GestureDetector(
                        onTap: _handleClear,
                        child: Icon(Icons.close,
                            size: 16.sp, color: NTokens.textMuted(context))),
                  ],
                  SizedBox(width: 8.w),
                  Icon(
                      _isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20.sp,
                      color: NTokens.textMuted(context)),
                ],
              ),
            ),
          ),
        ),
        if (widget.helperText != null || hasError) ...[
          SizedBox(height: 6.h),
          Text(
            hasError ? widget.errorText! : widget.helperText!,
            style: TextStyle(
                fontSize: 12.sp,
                color: hasError
                    ? NTokens.error(context)
                    : NTokens.textMuted(context)),
          ),
        ],
      ],
    );
  }
}

class _DropdownMenu<T> extends StatefulWidget {
  final List<NDropdownItem<T>> items;
  final T? selectedValue;
  final List<T> selectedValues;
  final bool multiple;
  final ValueChanged<T> onSelected;
  final bool searchable;
  final String searchPlaceholder;

  const _DropdownMenu({
    required this.items,
    required this.selectedValue,
    required this.selectedValues,
    required this.multiple,
    required this.onSelected,
    required this.searchable,
    required this.searchPlaceholder,
  });

  @override
  State<_DropdownMenu<T>> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<NDropdownItem<T>> _filteredItems = [];

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
                item.type == NDropdownItemType.separator ||
                item.type == NDropdownItemType.label ||
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
      constraints: BoxConstraints(maxHeight: 300.h),
      decoration: BoxDecoration(
        color: NTokens.bgElevated(context),
        borderRadius: BorderRadius.circular(NTokens.radiusDefault),
        border: Border.all(color: NTokens.borderDefault(context)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.searchable) ...[
            Padding(
              padding: EdgeInsets.all(8.w),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchPlaceholder,
                  hintStyle: TextStyle(
                      color: NTokens.textMuted(context), fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search,
                      size: 20.sp, color: NTokens.textMuted(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NTokens.radiusSm),
                    borderSide:
                        BorderSide(color: NTokens.borderDefault(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NTokens.radiusSm),
                    borderSide:
                        BorderSide(color: NTokens.borderDefault(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(NTokens.radiusSm),
                    borderSide:
                        BorderSide(color: NTokens.primary(context), width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  isDense: true,
                ),
                style: TextStyle(
                    fontSize: 14.sp, color: NTokens.textDefault(context)),
              ),
            ),
            Divider(
                height: 1, thickness: 1, color: NTokens.borderMuted(context)),
          ],
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                if (item.type == NDropdownItemType.separator) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Divider(
                        height: 1,
                        thickness: 1,
                        color: NTokens.borderMuted(context)),
                  );
                }
                if (item.type == NDropdownItemType.label) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    child: Text(
                      item.label,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: NTokens.textMuted(context),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      color: isSelected
                          ? NTokens.bgMuted(context)
                          : Colors.transparent,
                      child: Row(
                        children: [
                          if (item.avatar != null) ...[
                            SizedBox(
                                width: 24.w, height: 24.w, child: item.avatar),
                            SizedBox(width: 8.w),
                          ] else if (item.icon != null) ...[
                            Icon(item.icon,
                                size: 18.sp,
                                color: item.disabled
                                    ? NTokens.textDisabled(context)
                                    : NTokens.textMuted(context)),
                            SizedBox(width: 8.w),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: item.disabled
                                        ? NTokens.textDisabled(context)
                                        : NTokens.textDefault(context),
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                                if (item.description != null)
                                  Text(item.description!,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: NTokens.textMuted(context))),
                              ],
                            ),
                          ),
                          if (item.trailing != null) ...[
                            SizedBox(width: 8.w),
                            item.trailing!
                          ],
                          if (isSelected) ...[
                            SizedBox(width: 8.w),
                            Icon(Icons.check,
                                size: 18.sp, color: NTokens.primary(context)),
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
