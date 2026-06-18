import 'package:flutter/material.dart';
import '../../theme/n_color_palette.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The semantic color role applied to an [NAvatar]'s background and initials.
enum NAvatarColor {
  /// Uses the primary brand color.
  primary,

  /// Uses the secondary accent color.
  secondary,

  /// Uses the success color.
  success,

  /// Uses the informational color.
  info,

  /// Uses the warning color.
  warning,

  /// Uses the error color.
  error,

  /// Uses a neutral muted color.
  neutral,

  /// Picks a color deterministically from [NColorPalette.avatarColors] based
  /// on the hash of [NAvatar.name]. Ensures the same name always shows the
  /// same color.
  random,
}

/// The size of an [NAvatar], controlling its diameter, font size, and badge size.
enum NAvatarSize {
  /// Extra small (24 dp).
  xs,

  /// Small (32 dp).
  sm,

  /// Medium (40 dp). The default size.
  md,

  /// Large (48 dp).
  lg,

  /// Extra large (64 dp).
  xl,

  /// Double extra large (96 dp).
  xxl,
}

/// The corner position of the status chip badge on an [NAvatar].
enum NAvatarChipPosition {
  /// Chip is anchored to the top-right corner.
  topRight,

  /// Chip is anchored to the bottom-right corner.
  bottomRight,
}

/// A circular avatar widget that displays an image, initials, or an icon.
///
/// Resolves its content in the following priority order:
/// 1. [child] if provided.
/// 2. [imageUrl] if non-empty (falls back to initials on load error).
/// 3. Initials derived from [name] if provided.
/// 4. A generic person icon.
///
/// An optional status chip can be shown with [chip], and tapping is supported
/// via [onTap].
///
/// ```dart
/// NAvatar(
///   name: 'Jean Dupont',
///   color: NAvatarColor.random,
///   size: NAvatarSize.lg,
///   chip: true,
///   chipColor: Colors.green,
/// )
/// ```
class NAvatar extends StatelessWidget {
  /// URL of the image to display. Falls back to initials or icon on error.
  final String? imageUrl;

  /// The full name used to generate initials when [imageUrl] is absent.
  ///
  /// Also determines the deterministic color when [color] is [NAvatarColor.random].
  final String? name;

  /// A fallback icon shown when neither [imageUrl] nor [name] is provided.
  final IconData? icon;

  /// A fully custom widget rendered inside the avatar circle.
  ///
  /// When provided, [imageUrl], [name], and [icon] are ignored.
  final Widget? child;

  /// The diameter of the avatar. Defaults to [NAvatarSize.md].
  final NAvatarSize size;

  /// The semantic color role for the background and initials.
  /// Defaults to [NAvatarColor.neutral].
  final NAvatarColor color;

  /// Called when the avatar is tapped. Wraps the avatar in a [GestureDetector]
  /// with [Semantics.button] when set.
  final VoidCallback? onTap;

  /// When `true`, a small status chip is shown at the [chipPosition] corner.
  final bool chip;

  /// The color of the status chip. Defaults to [NTokens.success] when null.
  final Color? chipColor;

  /// The corner position of the status chip. Defaults to [NAvatarChipPosition.bottomRight].
  final NAvatarChipPosition chipPosition;

  /// Optional text rendered inside the chip badge (e.g., a short count).
  /// When null, a plain dot is shown.
  final String? chipText;

  /// When `true`, a primary-colored ring border is drawn around the avatar.
  final bool hasRing;

  /// When `true`, the avatar is rendered at 40% opacity to convey an inactive state.
  final bool isGhost;

  /// Creates an [NAvatar].
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
              ? Border.all(color: NTokens.primary(context), width: 2)
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
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: chipColor ?? NTokens.success(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: NTokens.bgDefault(context), width: 2),
                    ),
                    child: Text(
                      chipText!,
                      style: TextStyle(
                        fontSize: 8,
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
        return 24;
      case NAvatarSize.sm:
        return 32;
      case NAvatarSize.md:
        return 40;
      case NAvatarSize.lg:
        return 48;
      case NAvatarSize.xl:
        return 64;
      case NAvatarSize.xxl:
        return 96;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 10;
      case NAvatarSize.sm:
        return 12;
      case NAvatarSize.md:
        return 14;
      case NAvatarSize.lg:
        return 16;
      case NAvatarSize.xl:
        return 20;
      case NAvatarSize.xxl:
        return 28;
    }
  }

  double _getBadgeSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 8;
      case NAvatarSize.sm:
        return 10;
      case NAvatarSize.md:
        return 12;
      case NAvatarSize.lg:
        return 14;
      case NAvatarSize.xl:
        return 16;
      case NAvatarSize.xxl:
        return 20;
    }
  }
}

/// A horizontally overlapping stack of [NAvatar] widgets.
///
/// Renders up to [maxVisible] avatars; any additional avatars are summarised
/// as a `+N` overflow indicator. Each avatar is bordered to separate it from
/// its neighbor.
///
/// ```dart
/// NAvatarGroup(
///   names: ['Alice', 'Bob', 'Charlie', 'Diana'],
///   maxVisible: 3,
///   onMoreTap: () => showAllMembers(),
/// )
/// ```
class NAvatarGroup extends StatelessWidget {
  /// URLs of the avatar images. Provide parallel to [names].
  final List<String?> imageUrls;

  /// Names used to generate initials. Provide parallel to [imageUrls].
  final List<String?> names;

  /// The size applied to every avatar in the group. Defaults to [NAvatarSize.md].
  final NAvatarSize size;

  /// The maximum number of avatars to show before the overflow indicator.
  /// Defaults to 3.
  final int maxVisible;

  /// Called when the user taps the overflow (`+N`) indicator.
  final VoidCallback? onMoreTap;

  /// Creates an [NAvatarGroup].
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
        return 24;
      case NAvatarSize.sm:
        return 32;
      case NAvatarSize.md:
        return 40;
      case NAvatarSize.lg:
        return 48;
      case NAvatarSize.xl:
        return 64;
      case NAvatarSize.xxl:
        return 96;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NAvatarSize.xs:
        return 10;
      case NAvatarSize.sm:
        return 11;
      case NAvatarSize.md:
        return 12;
      case NAvatarSize.lg:
        return 13;
      case NAvatarSize.xl:
        return 16;
      case NAvatarSize.xxl:
        return 20;
    }
  }
}
