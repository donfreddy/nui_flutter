import 'package:flutter/material.dart';
import 'n_color_palette.dart';

/// A collection of static accessors for reading [NColorPalette] tokens from
/// the nearest [BuildContext].
///
/// All methods read the [NColorPalette] registered via [NTheme] and return
/// the corresponding color. Call these inside [Widget.build] where a valid
/// [BuildContext] with [NTheme] is available.
///
/// ```dart
/// Container(
///   color: NTokens.primaryBg(context),
///   child: Text('Hello', style: TextStyle(color: NTokens.primaryText(context))),
/// )
/// ```
abstract class NTokens {
  static NColorPalette _palette(BuildContext context) {
    return Theme.of(context).extension<NColorPalette>() ??
        (throw FlutterError(
          'NColorPalette not found.\n'
          'Wrap your MaterialApp with NTheme.lightTheme() or NTheme.darkTheme() '
          'to register the color palette.',
        ));
  }

  // ---------------------------------------------------------------------------
  // Base semantic colors
  // ---------------------------------------------------------------------------

  /// Returns the primary brand color from the current palette.
  static Color primary(BuildContext context) => _palette(context).primary;

  /// Returns the secondary accent color from the current palette.
  static Color secondary(BuildContext context) => _palette(context).secondary;

  /// Returns the success color from the current palette.
  static Color success(BuildContext context) => _palette(context).success;

  /// Returns the error color from the current palette.
  static Color error(BuildContext context) => _palette(context).error;

  /// Returns the warning color from the current palette.
  static Color warning(BuildContext context) => _palette(context).warning;

  /// Returns the info color from the current palette.
  static Color info(BuildContext context) => _palette(context).info;

  // ---------------------------------------------------------------------------
  // Backgrounds
  // ---------------------------------------------------------------------------

  /// Returns the default page background color.
  static Color bgDefault(BuildContext context) => _palette(context).bgDefault;

  /// Returns the elevated surface background color (cards, sheets).
  static Color bgElevated(BuildContext context) => _palette(context).bgElevated;

  /// Returns the inverted background color.
  static Color bgInverted(BuildContext context) => _palette(context).bgInverted;

  /// Returns the muted background color for secondary areas.
  static Color bgMuted(BuildContext context) => _palette(context).bgMuted;

  /// Returns the accented background color for hover or selection states.
  static Color bgAccented(BuildContext context) => _palette(context).bgAccented;

  // ---------------------------------------------------------------------------
  // Text hierarchy
  // ---------------------------------------------------------------------------

  /// Returns the highest-emphasis text color.
  static Color textHighlighted(BuildContext context) =>
      _palette(context).textHighlighted;

  /// Returns the default body text color.
  static Color textDefault(BuildContext context) =>
      _palette(context).textDefault;

  /// Returns a mid-emphasis text color.
  static Color textToned(BuildContext context) => _palette(context).textToned;

  /// Returns the low-emphasis text color for captions and secondary labels.
  static Color textMuted(BuildContext context) => _palette(context).textMuted;

  /// Returns the color for disabled or inactive text.
  static Color textDisabled(BuildContext context) =>
      _palette(context).textDisabled;

  /// Returns the text color for use on inverted backgrounds.
  static Color textInverted(BuildContext context) =>
      _palette(context).textInverted;

  // ---------------------------------------------------------------------------
  // Borders
  // ---------------------------------------------------------------------------

  /// Returns the default border color.
  static Color borderDefault(BuildContext context) =>
      _palette(context).borderDefault;

  /// Returns the muted border color for soft separators.
  static Color borderMuted(BuildContext context) =>
      _palette(context).borderMuted;

  /// Returns the border color used on hover or focus states.
  static Color borderHover(BuildContext context) =>
      _palette(context).borderHover;

  // ---------------------------------------------------------------------------
  // Semantic tinted backgrounds
  // ---------------------------------------------------------------------------

  /// Returns the lightly tinted background for primary-colored surfaces.
  static Color primaryBg(BuildContext context) => _palette(context).primaryBg;

  /// Returns the lightly tinted background for secondary-colored surfaces.
  static Color secondaryBg(BuildContext context) =>
      _palette(context).secondaryBg;

  /// Returns the lightly tinted background for success-colored surfaces.
  static Color successBg(BuildContext context) => _palette(context).successBg;

  /// Returns the lightly tinted background for error-colored surfaces.
  static Color errorBg(BuildContext context) => _palette(context).errorBg;

  /// Returns the lightly tinted background for warning-colored surfaces.
  static Color warningBg(BuildContext context) => _palette(context).warningBg;

  /// Returns the lightly tinted background for info-colored surfaces.
  static Color infoBg(BuildContext context) => _palette(context).infoBg;

  // ---------------------------------------------------------------------------
  // Semantic tinted borders
  // ---------------------------------------------------------------------------

  /// Returns the tinted border color for primary-colored surfaces.
  static Color primaryBorder(BuildContext context) =>
      _palette(context).primaryBorder;

  /// Returns the tinted border color for secondary-colored surfaces.
  static Color secondaryBorder(BuildContext context) =>
      _palette(context).secondaryBorder;

  /// Returns the tinted border color for success-colored surfaces.
  static Color successBorder(BuildContext context) =>
      _palette(context).successBorder;

  /// Returns the tinted border color for error-colored surfaces.
  static Color errorBorder(BuildContext context) =>
      _palette(context).errorBorder;

  /// Returns the tinted border color for warning-colored surfaces.
  static Color warningBorder(BuildContext context) =>
      _palette(context).warningBorder;

  /// Returns the tinted border color for info-colored surfaces.
  static Color infoBorder(BuildContext context) => _palette(context).infoBorder;

  // ---------------------------------------------------------------------------
  // Semantic tinted text
  // ---------------------------------------------------------------------------

  /// Returns the text color for content on primary-tinted backgrounds.
  static Color primaryText(BuildContext context) =>
      _palette(context).primaryText;

  /// Returns the text color for content on secondary-tinted backgrounds.
  static Color secondaryText(BuildContext context) =>
      _palette(context).secondaryText;

  /// Returns the text color for content on success-tinted backgrounds.
  static Color successText(BuildContext context) =>
      _palette(context).successText;

  /// Returns the text color for content on error-tinted backgrounds.
  static Color errorText(BuildContext context) => _palette(context).errorText;

  /// Returns the text color for content on warning-tinted backgrounds.
  static Color warningText(BuildContext context) =>
      _palette(context).warningText;

  /// Returns the text color for content on info-tinted backgrounds.
  static Color infoText(BuildContext context) => _palette(context).infoText;

  // ---------------------------------------------------------------------------
  // Radius constants
  // ---------------------------------------------------------------------------

  /// The default border radius in logical pixels (8 dp).
  static const double radiusDefault = 8.0;

  /// A smaller border radius in logical pixels (6 dp).
  static const double radiusSm = 6.0;

  /// A larger border radius in logical pixels (12 dp).
  static const double radiusLg = 12.0;

  /// An extra-large border radius in logical pixels (16 dp).
  static const double radiusXl = 16.0;

  // ---------------------------------------------------------------------------
  // Padding constants
  // ---------------------------------------------------------------------------

  /// The default component padding in logical pixels (16 dp).
  static const double paddingDefault = 16.0;

  /// A larger component padding in logical pixels (24 dp).
  static const double paddingLg = 24.0;
}
