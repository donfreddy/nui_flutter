/// The shared visual variants used across interactive surfaces.
enum NVariant {
  /// Filled with the role color.
  solid,

  /// Transparent with a tinted border.
  outline,

  /// Low-opacity tinted fill.
  soft,

  /// Tinted fill with a tinted border.
  subtle,

  /// Transparent, no border.
  ghost,

  /// Inline text style.
  link,
}

/// Centralized validation registry to ensure components only use variants
/// that make sense for their visual design.
abstract final class NVariantSupport {
  /// All variants are supported by buttons.
  static const Set<NVariant> button = {
    NVariant.solid,
    NVariant.outline,
    NVariant.soft,
    NVariant.subtle,
    NVariant.ghost,
    NVariant.link,
  };

  /// Badges typically do not support link or ghost forms.
  static const Set<NVariant> badge = {
    NVariant.solid,
    NVariant.outline,
    NVariant.soft,
    NVariant.subtle,
  };

  /// Alerts typically use solid, outline, soft, or subtle.
  static const Set<NVariant> alert = {
    NVariant.solid,
    NVariant.outline,
    NVariant.soft,
    NVariant.subtle,
  };

  /// Chips support solid, soft, and outline variants.
  static const Set<NVariant> chip = {
    NVariant.solid,
    NVariant.soft,
    NVariant.outline,
  };

  /// Progress bars typically only use solid or soft.
  static const Set<NVariant> progress = {
    NVariant.solid,
    NVariant.soft,
  };
}
