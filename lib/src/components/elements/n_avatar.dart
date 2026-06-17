import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/n_color_palette.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

enum NAvatarColor {
  primary,
  secondary,
  success,
  info,
  warning,
  error,
  neutral,
  random
}

enum NAvatarSize { xs, sm, md, lg, xl, xxl }

enum NAvatarChipPosition { topRight, bottomRight }

class NAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final IconData? icon;
  final Widget? child;
  final NAvatarSize size;
  final NAvatarColor color;
  final VoidCallback? onTap;
  final bool chip;
  final Color? chipColor;
  final NAvatarChipPosition chipPosition;
  final String? chipText;
  final bool hasRing;
  final bool isGhost;

  const NAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.icon,
    this.child,
    this.size = NAvatarSize.md,
    this.color = NAvatarColor.neutral,
    this.onTap,
    this.chip = false,
    this.chipColor,
    this.chipPosition = NAvatarChipPosition.bottomRight,
    this.chipText,
    this.hasRing = false,
    this.isGhost = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getSize();
    final fontSize = _getFontSize();
    final badgeSize = _getBadgeSize();
    final colors = _getColors(context);
    final opacity = isGhost ? 0.4 : 1.0;

    Widget avatarContent;
    if (child != null) {
      avatarContent = child!;
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = ClipOval(
        child: Image.network(
          imageUrl!,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _buildFallback(colors, avatarSize, fontSize),
        ),
      );
    } else {
      avatarContent = _buildFallback(colors, avatarSize, fontSize);
    }

    Widget avatar = Opacity(
      opacity: opacity,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: colors['background'],
          shape: BoxShape.circle,
          border: hasRing
              ? Border.all(color: NTokens.primary(context), width: 2.w)
              : null,
        ),
        child: Center(child: avatarContent),
      ),
    );

    if (chip) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: chipPosition == NAvatarChipPosition.bottomRight ? 0 : null,
            top: chipPosition == NAvatarChipPosition.topRight ? 0 : null,
            child: chipText != null
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: chipColor ?? NTokens.success(context),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                          color: NTokens.bgDefault(context), width: 2),
                    ),
                    child: Text(
                      chipText!,
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: NTokens.textInverted(context),
                      ),
                    ),
                  )
                : Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: chipColor ?? NTokens.success(context),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: NTokens.bgDefault(context), width: 2),
                    ),
                  ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return Semantics(
          button: true, child: GestureDetector(onTap: onTap, child: avatar));
    }

    return avatar;
  }

  Widget _buildFallback(
      Map<String, Color> colors, double avatarSize, double fontSize) {
    if (icon != null) {
      return Icon(icon, size: avatarSize * 0.5, color: colors['foreground']);
    }
    if (name != null && name!.isNotEmpty) {
      return Text(
        _getInitials(name!),
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: colors['foreground']),
      );
    }
    return Icon(Icons.person,
        size: avatarSize * 0.5, color: colors['foreground']);
  }

  NComponentColor? get _avatarComponentColor {
    if (color == NAvatarColor.random) return null;
    return switch (color) {
      NAvatarColor.primary => NComponentColor.primary,
      NAvatarColor.secondary => NComponentColor.secondary,
      NAvatarColor.success => NComponentColor.success,
      NAvatarColor.info => NComponentColor.info,
      NAvatarColor.warning => NComponentColor.warning,
      NAvatarColor.error => NComponentColor.error,
      NAvatarColor.neutral => NComponentColor.neutral,
      NAvatarColor.random => null,
    };
  }

  Map<String, Color> _getColors(BuildContext context) {
    if (color == NAvatarColor.random) {
      const palette = NColorPalette.avatarColors;
      final index = name != null && name!.isNotEmpty
          ? name!.codeUnits.fold(0, (sum, c) => sum + c) % palette.length
          : 0;
      final bg = palette[index].withValues(alpha: 0.15);
      return {'background': bg, 'foreground': palette[index]};
    }

    final c = NComponentColors.resolve(context, _avatarComponentColor!,
        neutralSoftBg: (ctx) => NTokens.bgMuted(ctx),
        neutralForeground: (ctx) => NTokens.textMuted(ctx));
    return {
      'background': c.main.withValues(alpha: 0.15),
      'foreground': c.main,
    };
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  double _getSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 24.w;
      case NAvatarSize.sm:
        return 32.w;
      case NAvatarSize.md:
        return 40.w;
      case NAvatarSize.lg:
        return 48.w;
      case NAvatarSize.xl:
        return 64.w;
      case NAvatarSize.xxl:
        return 96.w;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 10.sp;
      case NAvatarSize.sm:
        return 12.sp;
      case NAvatarSize.md:
        return 14.sp;
      case NAvatarSize.lg:
        return 16.sp;
      case NAvatarSize.xl:
        return 20.sp;
      case NAvatarSize.xxl:
        return 28.sp;
    }
  }

  double _getBadgeSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 8.w;
      case NAvatarSize.sm:
        return 10.w;
      case NAvatarSize.md:
        return 12.w;
      case NAvatarSize.lg:
        return 14.w;
      case NAvatarSize.xl:
        return 16.w;
      case NAvatarSize.xxl:
        return 20.w;
    }
  }
}

class NAvatarGroup extends StatelessWidget {
  final List<String?> imageUrls;
  final List<String?> names;
  final NAvatarSize size;
  final int maxVisible;
  final VoidCallback? onMoreTap;

  const NAvatarGroup({
    super.key,
    this.imageUrls = const [],
    this.names = const [],
    this.size = NAvatarSize.md,
    this.maxVisible = 3,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final total =
        imageUrls.length > names.length ? imageUrls.length : names.length;
    final visible = total > maxVisible ? maxVisible : total;
    final remaining = total - visible;
    final avatarSize = _getAvatarSize();

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          ...List.generate(visible, (index) {
            return Positioned(
              left: index * (avatarSize * 0.7),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: NTokens.bgDefault(context), width: 2),
                ),
                child: NAvatar(
                  imageUrl: index < imageUrls.length ? imageUrls[index] : null,
                  name: index < names.length ? names[index] : null,
                  size: size,
                ),
              ),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: visible * (avatarSize * 0.7),
              child: GestureDetector(
                onTap: onMoreTap,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: NTokens.bgMuted(context),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: NTokens.bgDefault(context), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '+$remaining',
                      style: TextStyle(
                        fontSize: _getFontSize(),
                        fontWeight: FontWeight.w600,
                        color: NTokens.textMuted(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _getAvatarSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 24.w;
      case NAvatarSize.sm:
        return 32.w;
      case NAvatarSize.md:
        return 40.w;
      case NAvatarSize.lg:
        return 48.w;
      case NAvatarSize.xl:
        return 64.w;
      case NAvatarSize.xxl:
        return 96.w;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 10.sp;
      case NAvatarSize.sm:
        return 11.sp;
      case NAvatarSize.md:
        return 12.sp;
      case NAvatarSize.lg:
        return 13.sp;
      case NAvatarSize.xl:
        return 16.sp;
      case NAvatarSize.xxl:
        return 20.sp;
    }
  }
}
