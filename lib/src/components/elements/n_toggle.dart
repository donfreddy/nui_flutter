import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NToggleColor { primary, secondary, success, info, warning, error, neutral }

enum NToggleSize { xs, sm, md, lg, xl }

class NToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final NToggleColor color;
  final NToggleSize size;
  final bool disabled;
  final bool loading;
  final Widget? checkedIcon;
  final Widget? uncheckedIcon;
  final String? label;
  final String? helperText;

  const NToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.color = NToggleColor.primary,
    this.size = NToggleSize.md,
    this.disabled = false,
    this.loading = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.label,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    Widget toggle = _buildToggle(context);
    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              toggle,
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: (disabled || loading)
                      ? null
                      : () => onChanged?.call(!value),
                  child: Text(
                    label!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: disabled
                          ? NTokens.textDisabled(context)
                          : NTokens.textDefault(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (helperText != null) ...[
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.only(left: _getWidth() + 12.w),
              child: Text(
                helperText!,
                style: TextStyle(
                    fontSize: 12.sp, color: NTokens.textMuted(context)),
              ),
            ),
          ],
        ],
      );
    }
    return toggle;
  }

  Widget _buildToggle(BuildContext context) {
    final width = _getWidth();
    final height = _getHeight();
    final thumbSize = _getThumbSize();
    final activeColor = _getActiveColor(context);

    Color backgroundColor;
    if (disabled) {
      backgroundColor = NTokens.borderMuted(context);
    } else if (value) {
      backgroundColor = activeColor;
    } else {
      backgroundColor = NTokens.borderDefault(context);
    }

    return Semantics(
      toggled: value,
      enabled: !disabled,
      child: GestureDetector(
        onTap: (disabled || loading) ? null : () => onChanged?.call(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(2.w),
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Center(
                child: loading
                    ? SizedBox(
                        width: thumbSize * 0.5,
                        height: thumbSize * 0.5,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(activeColor),
                        ),
                      )
                    : (value ? checkedIcon : uncheckedIcon),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getActiveColor(BuildContext context) {
    return NComponentColors.resolve(
      context,
      NComponentColor.values[color.index],
    ).main;
  }

  double _getWidth() {
    switch (size) {
      case NToggleSize.xs:
        return 28.w;
      case NToggleSize.sm:
        return 36.w;
      case NToggleSize.md:
        return 44.w;
      case NToggleSize.lg:
        return 52.w;
      case NToggleSize.xl:
        return 60.w;
    }
  }

  double _getHeight() {
    switch (size) {
      case NToggleSize.xs:
        return 16.h;
      case NToggleSize.sm:
        return 20.h;
      case NToggleSize.md:
        return 24.h;
      case NToggleSize.lg:
        return 28.h;
      case NToggleSize.xl:
        return 32.h;
    }
  }

  double _getThumbSize() {
    switch (size) {
      case NToggleSize.xs:
        return 12.w;
      case NToggleSize.sm:
        return 16.w;
      case NToggleSize.md:
        return 20.w;
      case NToggleSize.lg:
        return 24.w;
      case NToggleSize.xl:
        return 28.w;
    }
  }
}
