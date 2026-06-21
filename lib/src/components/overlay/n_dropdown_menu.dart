import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The semantic color role applied to an [NDropdownMenuItem].
enum NDropdownMenuColor {
  primary,
  secondary,
  success,
  info,
  warning,
  error,
  neutral,
}

/// A single item in an [NDropdownMenu].
class NDropdownMenuItem {
  /// The text displayed in the menu row.
  final String label;

  /// An optional icon shown to the left of [label].
  final IconData? icon;

  /// An optional avatar widget shown to the left of [label].
  final Widget? avatar;

  /// A list of keyboard shortcut keys shown on the right (e.g., ['⌘', 'K']).
  final List<String>? kbds;

  /// The color role of the item. Defaults to neutral, but can be set to
  /// [NDropdownMenuColor.error] for destructive actions.
  final NDropdownMenuColor? color;

  /// When `true`, this item cannot be selected and appears faded.
  final bool disabled;

  /// Called when the user taps this item.
  final VoidCallback? onSelect;

  /// Creates an [NDropdownMenuItem].
  const NDropdownMenuItem({
    required this.label,
    this.icon,
    this.avatar,
    this.kbds,
    this.color,
    this.disabled = false,
    this.onSelect,
  });
}

/// A menu to display actions when clicking on an element.
///
/// Use a Button or any other component in the [child] property of the DropdownMenu.
/// Items are passed as a `List<List<NDropdownMenuItem>>` to allow grouping.
///
/// ```dart
/// NDropdownMenu(
///   items: [
///     [
///       NDropdownMenuItem(label: 'Profile', icon: LucideIcons.user),
///       NDropdownMenuItem(label: 'Billing', icon: LucideIcons.creditCard),
///     ],
///     [
///       NDropdownMenuItem(
///         label: 'Logout',
///         icon: LucideIcons.logOut,
///         color: NDropdownMenuColor.error,
///         kbds: ['⇧', '⌘', 'Q'],
///         onSelect: () => print('Logout'),
///       ),
///     ],
///   ],
///   child: NButton.outline(icon: LucideIcons.menu),
/// )
/// ```
class NDropdownMenu extends StatefulWidget {
  /// The trigger widget that opens the dropdown menu when tapped.
  final Widget child;

  /// Groups of items to display in the menu. Each inner list represents a group
  /// separated by a visual divider.
  final List<List<NDropdownMenuItem>> items;

  /// When `true`, the menu opens automatically on load (useful for testing).
  final bool defaultOpen;

  /// Creates an [NDropdownMenu].
  const NDropdownMenu({
    super.key,
    required this.child,
    required this.items,
    this.defaultOpen = false,
  });

  @override
  State<NDropdownMenu> createState() => _NDropdownMenuState();
}

class _NDropdownMenuState extends State<NDropdownMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.defaultOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _showOverlay();
    }
  }

  void _closeMenu() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible layer to catch outside taps
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeMenu,
              // We don't use a child here so it just intercepts taps
            ),
          ),
          Positioned(
            width: 220, // Default width for a standard dropdown menu
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: _DropdownMenuContent(
                  items: widget.items,
                  onClose: _closeMenu,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}

class _DropdownMenuContent extends StatelessWidget {
  final List<List<NDropdownMenuItem>> items;
  final VoidCallback onClose;

  const _DropdownMenuContent({
    required this.items,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: NTokens.bgElevated(context),
        borderRadius: BorderRadius.circular(NTokens.radiusDefault),
        border: Border.all(color: NTokens.borderDefault(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: NTokens.borderMuted(context),
                  ),
                ),
              ...items[i].map((item) => _buildItem(context, item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, NDropdownMenuItem item) {
    final textColor = _getTextColor(context, item);
    final iconColor = _getIconColor(context, item);
    final hoverColor = _getHoverColor(context, item);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.disabled
            ? null
            : () {
                item.onSelect?.call();
                onClose();
              },
        hoverColor: hoverColor,
        splashColor: hoverColor,
        highlightColor: hoverColor.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (item.avatar != null) ...[
                SizedBox(width: 20, height: 20, child: item.avatar!),
                const SizedBox(width: 10),
              ] else if (item.icon != null) ...[
                Icon(item.icon, size: 16, color: iconColor),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (item.kbds != null && item.kbds!.isNotEmpty) ...[
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: item.kbds!.map((kbd) => _buildKbd(context, kbd)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKbd(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: NTokens.bgMuted(context),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: NTokens.borderMuted(context)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: NTokens.textMuted(context),
          fontFamily: 'Courier', // Standard for keyboard shortcuts
        ),
      ),
    );
  }

  Color _getTextColor(BuildContext context, NDropdownMenuItem item) {
    if (item.disabled) return NTokens.textDisabled(context);
    if (item.color != null && item.color != NDropdownMenuColor.neutral) {
      return NComponentColors.resolve(
        context,
        _mapColor(item.color!),
      ).text;
    }
    return NTokens.textDefault(context);
  }

  Color _getIconColor(BuildContext context, NDropdownMenuItem item) {
    if (item.disabled) return NTokens.textDisabled(context);
    if (item.color != null && item.color != NDropdownMenuColor.neutral) {
      return NComponentColors.resolve(
        context,
        _mapColor(item.color!),
      ).main;
    }
    return NTokens.textMuted(context);
  }

  Color _getHoverColor(BuildContext context, NDropdownMenuItem item) {
    if (item.disabled) return Colors.transparent;
    if (item.color != null && item.color != NDropdownMenuColor.neutral) {
      return NComponentColors.resolve(
        context,
        _mapColor(item.color!),
      ).softBg;
    }
    return NTokens.bgMuted(context);
  }

  NComponentColor _mapColor(NDropdownMenuColor color) {
    return switch (color) {
      NDropdownMenuColor.primary => NComponentColor.primary,
      NDropdownMenuColor.secondary => NComponentColor.secondary,
      NDropdownMenuColor.success => NComponentColor.success,
      NDropdownMenuColor.info => NComponentColor.info,
      NDropdownMenuColor.warning => NComponentColor.warning,
      NDropdownMenuColor.error => NComponentColor.error,
      NDropdownMenuColor.neutral => NComponentColor.neutral,
    };
  }
}
