import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/n_tokens.dart';

/// The visual style of an [NTabBar].
enum NTabBarVariant {
  /// Tabs sit above a bottom border. The selected tab shows a colored underline.
  underline,

  /// Selected tab is wrapped in a pill-shaped tinted container.
  pill,
}

/// The height of an [NTabBar] row.
enum NTabBarSize {
  /// 32 dp row height.
  sm,

  /// 40 dp row height. The default.
  md,

  /// 48 dp row height.
  lg,
}

/// A single tab descriptor used as an element of [NTabBar.tabs].
///
/// Provides a [label], an optional [icon], and an optional numeric [count]
/// badge. The [selected] state is managed by [NTabBar]; you do not need to
/// set it manually.
///
/// ```dart
/// NTabBar(
///   tabs: [
///     NTab(label: 'Transactions'),
///     NTab(label: 'Contacts', icon: LucideIcons.users, count: 3),
///   ],
///   selectedIndex: _index,
///   onChanged: (i) => setState(() => _index = i),
/// )
/// ```
class NTab extends StatelessWidget {
  /// The text label for the tab.
  final String label;

  /// An optional icon shown to the left of [label].
  final IconData? icon;

  /// An optional count displayed as a small badge after [label].
  ///
  /// Hidden when 0.
  final int count;

  /// Whether this tab is currently selected.
  ///
  /// Managed automatically by [NTabBar]; do not set this manually.
  final bool selected;

  /// Creates an [NTab].
  const NTab({
    super.key,
    required this.label,
    this.icon,
    this.count = 0,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return NTabItem(
      label: label,
      icon: icon,
      count: count,
      selected: selected,
    );
  }
}

/// The inner content of a tab: icon, label, and count badge.
///
/// Used internally by [NTabBar] and exposed for custom tab bar layouts.
class NTabItem extends StatelessWidget {
  /// The text label.
  final String label;

  /// An optional icon shown to the left of [label].
  final IconData? icon;

  /// An optional count badge shown after [label]. Hidden when 0.
  final int count;

  /// Whether this item is rendered in the selected (active) state.
  final bool selected;

  /// Creates an [NTabItem].
  const NTabItem({
    super.key,
    required this.label,
    this.icon,
    this.count = 0,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16.sp,
            color: selected
                ? NTokens.primary(context)
                : NTokens.textMuted(context),
          ),
          SizedBox(width: 6.w),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? NTokens.primary(context)
                : NTokens.textMuted(context),
          ),
        ),
        if (count > 0) ...[
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: selected
                  ? NTokens.primary(context).withValues(alpha: 0.1)
                  : NTokens.bgMuted(context),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: selected
                    ? NTokens.primary(context)
                    : NTokens.textMuted(context),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A horizontally scrollable or fixed tab bar that controls which [NTab] is
/// active.
///
/// Supply [tabs], the current [selectedIndex], and an [onChanged] callback.
/// The visual style is controlled by [variant] and row height by [size].
///
/// ```dart
/// NTabBar(
///   tabs: [
///     NTab(label: 'All'),
///     NTab(label: 'Pending', count: 2),
///   ],
///   selectedIndex: _index,
///   onChanged: (i) => setState(() => _index = i),
///   variant: NTabBarVariant.pill,
/// )
/// ```
class NTabBar extends StatelessWidget {
  /// The list of tabs to display.
  final List<NTab> tabs;

  /// The index of the currently selected tab.
  final int selectedIndex;

  /// Called when the user selects a different tab, passing the new index.
  final ValueChanged<int> onChanged;

  /// The visual style. Defaults to [NTabBarVariant.underline].
  final NTabBarVariant variant;

  /// The row height. Defaults to [NTabBarSize.md].
  final NTabBarSize size;

  /// When `true` (the default), tabs overflow into a horizontal scroll view.
  /// When `false`, all tabs are rendered in a fixed-width row.
  final bool scrollable;

  /// Creates an [NTabBar].
  const NTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = NTabBarVariant.underline,
    this.size = NTabBarSize.md,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final tabHeight = switch (size) {
      NTabBarSize.sm => 32.h,
      NTabBarSize.md => 40.h,
      NTabBarSize.lg => 48.h,
    };

    return Container(
      height: tabHeight + 8.h,
      decoration: BoxDecoration(
        border: variant == NTabBarVariant.underline
            ? Border(
                bottom:
                    BorderSide(color: NTokens.borderDefault(context), width: 1))
            : null,
      ),
      child: scrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _buildTabs(context, tabHeight),
            )
          : _buildTabs(context, tabHeight),
    );
  }

  Widget _buildTabs(BuildContext context, double tabHeight) {
    return Row(
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: tabHeight,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: variant == NTabBarVariant.underline
                  ? Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? NTokens.primary(context)
                            : Colors.transparent,
                        width: 2,
                      ),
                    )
                  : null,
              borderRadius: variant == NTabBarVariant.pill
                  ? BorderRadius.circular(tabHeight / 2)
                  : null,
              color: variant == NTabBarVariant.pill && isSelected
                  ? NTokens.primary(context).withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Center(
              child: NTabItem(
                label: tab.label,
                icon: tab.icon,
                count: tab.count,
                selected: isSelected,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
