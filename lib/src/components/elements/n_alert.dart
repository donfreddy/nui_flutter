import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NAlertVariant { solid, outline, soft, subtle }

enum NAlertColor { primary, secondary, success, info, warning, error, neutral }

enum NAlertOrientation { horizontal, vertical }

class NAlert extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? child;
  final NAlertColor color;
  final NAlertVariant variant;
  final NAlertOrientation orientation;
  final IconData? icon;
  final bool showIcon;
  final bool closable;
  final bool centerDesc;
  final VoidCallback? onClose;
  final List<Widget>? actions;

  const NAlert({
    super.key,
    this.title,
    this.description,
    this.child,
    this.color = NAlertColor.primary,
    this.variant = NAlertVariant.solid,
    this.orientation = NAlertOrientation.vertical,
    this.icon,
    this.showIcon = true,
    this.closable = false,
    this.centerDesc = false,
    this.onClose,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final defaultIcon = _getDefaultIcon();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(8.r),
        border:
            variant == NAlertVariant.outline || variant == NAlertVariant.subtle
                ? Border.all(
                    color: colors['border']!,
                    width: variant == NAlertVariant.outline ? 1.5 : 1)
                : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(icon ?? defaultIcon,
                color: colors['icon'], size: 20.sp),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors['text']),
                  ),
                if (description != null) ...[
                  if (title != null) SizedBox(height: 4.h),
                  Text(
                    description!,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: colors['text']!.withValues(alpha: 0.9)),
                    textAlign: centerDesc ? TextAlign.center : null,
                  ),
                ],
                if (child != null) ...[
                  if (title != null || description != null)
                    SizedBox(height: 8.h),
                  DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: colors['text']!.withValues(alpha: 0.9)),
                    child: child!,
                  ),
                ],
                if (actions != null && actions!.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Wrap(spacing: 8.w, runSpacing: 8.h, children: actions!),
                ],
              ],
            ),
          ),
          if (closable) ...[
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close,
                  size: 18.sp, color: colors['text']!.withValues(alpha: 0.6)),
            ),
          ],
        ],
      ),
    );
  }

  NComponentColor get _componentColor =>
      NComponentColor.values[color.index];

  Map<String, Color> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor);
    final baseColor = c.main;
    final softBg = baseColor.withValues(alpha: 0.1);
    final borderColor = baseColor.withValues(alpha: 0.3);
    final textColor = baseColor;

    switch (variant) {
      case NAlertVariant.solid:
        return {
          'background': baseColor,
          'border': baseColor,
          'text': NTokens.textInverted(context),
          'icon': NTokens.textInverted(context)
        };
      case NAlertVariant.outline:
        return {
          'background': Colors.transparent,
          'border': borderColor,
          'text': textColor,
          'icon': textColor
        };
      case NAlertVariant.soft:
        return {
          'background': softBg,
          'border': softBg,
          'text': textColor,
          'icon': textColor
        };
      case NAlertVariant.subtle:
        return {
          'background': softBg,
          'border': borderColor,
          'text': textColor,
          'icon': textColor
        };
    }
  }

  IconData _getDefaultIcon() {
    switch (color) {
      case NAlertColor.info:
        return Icons.info_outline;
      case NAlertColor.success:
        return Icons.check_circle_outline;
      case NAlertColor.warning:
        return Icons.warning_amber_outlined;
      case NAlertColor.error:
        return Icons.error_outline;
      case NAlertColor.primary:
        return Icons.lightbulb_outline;
      case NAlertColor.secondary:
        return Icons.stars_outlined;
      case NAlertColor.neutral:
        return Icons.info_outline;
    }
  }
}
