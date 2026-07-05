import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Enums & Data classes
// ---------------------------------------------------------------------------

/// A single item in an [NDropdownMenu].
class NDropdownMenuItem {
  /// The text displayed in the menu row.
  final String label;

  /// An optional icon shown to the left of [label].
  final IconData? icon;

  /// An optional avatar widget shown to the left of [label].
  final Widget? avatar;

  /// A list of keyboard shortcut keys shown on the right (e.g. ['⌘', 'K']).
  final List<String>? kbds;

  /// The color role of the item. Use [NColorRole.error] for destructive
  /// actions to tint the label and icon in red.
  final NColorRole? color;

  /// When `true`, this item cannot be tapped and appears faded.
  final bool disabled;

  /// Called when the user selects this item.
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

// ---------------------------------------------------------------------------
// NDropdownMenu widget
// ---------------------------------------------------------------------------

/// A contextual action menu that appears when the [child] is tapped.
///
/// Pass items as a `List<List<NDropdownMenuItem>>`. Each inner list forms a
/// visual group separated by a thin divider.
///
/// ```dart
/// NDropdownMenu(
///   items: [
///     [
///       NDropdownMenuItem(label: 'Profile', icon: NIcons.user),
///       NDropdownMenuItem(label: 'Settings', icon: NIcons.cog, kbds: [',']),
///     ],
///     [
///       NDropdownMenuItem(
///         label: 'Logout',
///         icon: NIcons.logOut,
///         color: NColorRole.error,
///         kbds: ['⇧', '⌘', 'Q'],
///         onSelect: () => signOut(),
///       ),
///     ],
///   ],
///   child: NButton.outline(label: 'Open', leading: Icon(NIcons.menu)),
/// )
/// ```
class NDropdownMenu extends StatefulWidget {
  /// The widget that triggers the menu when tapped.
  final Widget child;

  /// Item groups. Each inner list renders as a group with a divider between
  /// consecutive groups.
  final List<List<NDropdownMenuItem>> items;

  /// Preferred minimum width for the popup. Defaults to 200.
  final double minWidth;

  const NDropdownMenu({
    super.key,
    required this.child,
    required this.items,
    this.minWidth = 200,
  });

  @override
  State<NDropdownMenu> createState() => _NDropdownMenuState();
}

class _NDropdownMenuState extends State<NDropdownMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _toggle() => _isOpen ? _close() : _open();

  Future<void> _close() async {
    await _animCtrl.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  void _open() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    _animCtrl.forward(from: 0);
    setState(() => _isOpen = true);
  }

  OverlayEntry _buildOverlay() {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;

    return OverlayEntry(
      builder: (_) => _DropdownOverlay(
        layerLink: _layerLink,
        triggerSize: size,
        items: widget.items,
        minWidth: widget.minWidth,
        scaleAnim: _scaleAnim,
        fadeAnim: _fadeAnim,
        onClose: _close,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggle,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Overlay content
// ---------------------------------------------------------------------------

class _DropdownOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final Size triggerSize;
  final List<List<NDropdownMenuItem>> items;
  final double minWidth;
  final Animation<double> scaleAnim;
  final Animation<double> fadeAnim;
  final VoidCallback onClose;

  const _DropdownOverlay({
    required this.layerLink,
    required this.triggerSize,
    required this.items,
    required this.minWidth,
    required this.scaleAnim,
    required this.fadeAnim,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen tap catcher for outside taps
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onClose,
            child: const SizedBox.expand(),
          ),
        ),
        // The popup positioned below the trigger
        Positioned(
          width: minWidth,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 6),
            child: FadeTransition(
              opacity: fadeAnim,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(scaleAnim),
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: _MenuPanel(items: items, onClose: onClose),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Panel
// ---------------------------------------------------------------------------

class _MenuPanel extends StatelessWidget {
  final List<List<NDropdownMenuItem>> items;
  final VoidCallback onClose;

  const _MenuPanel({required this.items, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.nui.colors.bgElevated,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: context.nui.colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: IntrinsicWidth(
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
                        color: context.nui.colors.borderMuted,
                      ),
                    ),
                  ...items[i]
                      .map((item) => _MenuItem(item: item, onClose: onClose)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu item
// ---------------------------------------------------------------------------

class _MenuItem extends StatefulWidget {
  final NDropdownMenuItem item;
  final VoidCallback onClose;

  const _MenuItem({required this.item, required this.onClose});

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovered = false;

  NDropdownMenuItem get item => widget.item;

  bool get _isSemantic =>
      item.color != null && item.color != NColorRole.neutral;

  @override
  Widget build(BuildContext context) {
    if (item.disabled) return _buildRow(context, isHovered: false);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          item.onSelect?.call();
          widget.onClose();
        },
        child: _buildRow(context, isHovered: _hovered),
      ),
    );
  }

  Widget _buildRow(BuildContext context, {required bool isHovered}) {
    final resolved = _isSemantic
        ? NVariantResolver.resolve(
            item.color!, NVariant.soft, context.nui.colors)
        : null;

    final textColor = item.disabled
        ? context.nui.colors.textMuted
        : resolved?.foreground ?? context.nui.colors.text;

    final iconColor = item.disabled
        ? context.nui.colors.textMuted
        : resolved?.foreground ?? context.nui.colors.textMuted;

    final bgColor = isHovered
        ? (resolved?.background ?? context.nui.colors.bgMuted)
        : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Leading: avatar or icon
          if (item.avatar != null) ...[
            SizedBox(width: 18, height: 18, child: item.avatar!),
            const SizedBox(width: 8),
          ] else if (item.icon != null) ...[
            Icon(item.icon, size: 15, color: iconColor),
            const SizedBox(width: 8),
          ],
          // Label
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
          // Keyboard shortcuts
          if (item.kbds != null && item.kbds!.isNotEmpty) ...[
            const SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: item.kbds!.map((k) => _KbdBadge(text: k)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Keyboard badge
// ---------------------------------------------------------------------------

class _KbdBadge extends StatelessWidget {
  final String text;
  const _KbdBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 3),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: context.nui.colors.bgMuted,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.nui.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.nui.colors.border.withValues(alpha: 0.5),
            offset: const Offset(0, 1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: context.nui.colors.textMuted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
