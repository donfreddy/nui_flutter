// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tool/gen_tailwind_colors.dart
// Tailwind v4.3 official OKLCH values, converted to sRGB 0xAARRGGBB ints.
// Re-generate with: dart run tool/gen_tailwind_colors.dart
//
// Each palette exposes its 11 shades as a `NColorScale` so that any component
// using `colors.scaleFor(role)` resolves to the exact Tailwind ramp.
//
// NOTE: `NColorScale.nuxtGreen` (in n_color_scale.dart) is INTENTIONALLY kept
// as the Nuxt UI signature green (#00DC82, generated via fromSeed).  To use the
// official Tailwind green palette instead, pass `NTailwindScales.green` to
// `NColors.light(roles: {NColorRole.primary: NTailwindScales.green})`.

import 'n_color_scale.dart';
import 'package:flutter/material.dart';

/// Pixel-perfect Tailwind v4 color palettes (21 palettes × 11 shades).
///
/// Values are converted from the official Tailwind v4 OKLCH specifications
/// (https://tailwindcss.com/docs/colors) to sRGB `Color`/`NColorScale`.
/// Use these when you need to match Tailwind/Nuxt UI 4 exactly; use
/// [NColorScale.fromSeed] for custom brand colors (won't match Tailwind).
abstract final class NTailwindScales {

  /// Tailwind `red` palette (50 → 950).
  static const NColorScale red = NColorScale([
    Color(0xFFFEF2F2), // red-50
    Color(0xFFFFE2E2), // red-100
    Color(0xFFFFC9C9), // red-200
    Color(0xFFFFA2A2), // red-300
    Color(0xFFFF6467), // red-400
    Color(0xFFFB2C36), // red-500
    Color(0xFFE7000B), // red-600
    Color(0xFFC10007), // red-700
    Color(0xFF9F0712), // red-800
    Color(0xFF82181A), // red-900
    Color(0xFF460809), // red-950
  ]);

  /// Tailwind `orange` palette (50 → 950).
  static const NColorScale orange = NColorScale([
    Color(0xFFFFF7ED), // orange-50
    Color(0xFFFFEDD4), // orange-100
    Color(0xFFFFD6A7), // orange-200
    Color(0xFFFFB86A), // orange-300
    Color(0xFFFF8904), // orange-400
    Color(0xFFFF6900), // orange-500
    Color(0xFFF54900), // orange-600
    Color(0xFFCA3500), // orange-700
    Color(0xFF9F2D00), // orange-800
    Color(0xFF7E2A0C), // orange-900
    Color(0xFF441306), // orange-950
  ]);

  /// Tailwind `amber` palette (50 → 950).
  static const NColorScale amber = NColorScale([
    Color(0xFFFFFBEB), // amber-50
    Color(0xFFFEF3C6), // amber-100
    Color(0xFFFEE685), // amber-200
    Color(0xFFFFD230), // amber-300
    Color(0xFFFFB900), // amber-400
    Color(0xFFFE9A00), // amber-500
    Color(0xFFE17100), // amber-600
    Color(0xFFBB4D00), // amber-700
    Color(0xFF973C00), // amber-800
    Color(0xFF7B3306), // amber-900
    Color(0xFF461901), // amber-950
  ]);

  /// Tailwind `yellow` palette (50 → 950).
  static const NColorScale yellow = NColorScale([
    Color(0xFFFEFCE8), // yellow-50
    Color(0xFFFEF9C2), // yellow-100
    Color(0xFFFFF085), // yellow-200
    Color(0xFFFFDF20), // yellow-300
    Color(0xFFFDC700), // yellow-400
    Color(0xFFF0B100), // yellow-500
    Color(0xFFD08700), // yellow-600
    Color(0xFFA65F00), // yellow-700
    Color(0xFF894B00), // yellow-800
    Color(0xFF733E0A), // yellow-900
    Color(0xFF432004), // yellow-950
  ]);

  /// Tailwind `lime` palette (50 → 950).
  static const NColorScale lime = NColorScale([
    Color(0xFFF7FEE7), // lime-50
    Color(0xFFECFCCA), // lime-100
    Color(0xFFD8F999), // lime-200
    Color(0xFFBBF451), // lime-300
    Color(0xFF9AE600), // lime-400
    Color(0xFF7CCF00), // lime-500
    Color(0xFF5EA500), // lime-600
    Color(0xFF497D00), // lime-700
    Color(0xFF3C6300), // lime-800
    Color(0xFF35530E), // lime-900
    Color(0xFF192E03), // lime-950
  ]);

  /// Tailwind `green` palette (50 → 950).
  static const NColorScale green = NColorScale([
    Color(0xFFF0FDF4), // green-50
    Color(0xFFDCFCE7), // green-100
    Color(0xFFB9F8CF), // green-200
    Color(0xFF7BF1A8), // green-300
    Color(0xFF05DF72), // green-400
    Color(0xFF00C950), // green-500
    Color(0xFF00A63E), // green-600
    Color(0xFF008236), // green-700
    Color(0xFF016630), // green-800
    Color(0xFF0D542B), // green-900
    Color(0xFF032E15), // green-950
  ]);

  /// Tailwind `emerald` palette (50 → 950).
  static const NColorScale emerald = NColorScale([
    Color(0xFFECFDF5), // emerald-50
    Color(0xFFD0FAE5), // emerald-100
    Color(0xFFA4F4CF), // emerald-200
    Color(0xFF5EE9B5), // emerald-300
    Color(0xFF00D492), // emerald-400
    Color(0xFF00BC7D), // emerald-500
    Color(0xFF009966), // emerald-600
    Color(0xFF007A55), // emerald-700
    Color(0xFF006045), // emerald-800
    Color(0xFF004F3B), // emerald-900
    Color(0xFF002C22), // emerald-950
  ]);

  /// Tailwind `teal` palette (50 → 950).
  static const NColorScale teal = NColorScale([
    Color(0xFFF0FDFA), // teal-50
    Color(0xFFCBFBF1), // teal-100
    Color(0xFF96F7E4), // teal-200
    Color(0xFF46ECD5), // teal-300
    Color(0xFF00D5BE), // teal-400
    Color(0xFF00BBA7), // teal-500
    Color(0xFF009689), // teal-600
    Color(0xFF00786F), // teal-700
    Color(0xFF005F5A), // teal-800
    Color(0xFF0B4F4A), // teal-900
    Color(0xFF022F2E), // teal-950
  ]);

  /// Tailwind `cyan` palette (50 → 950).
  static const NColorScale cyan = NColorScale([
    Color(0xFFECFEFF), // cyan-50
    Color(0xFFCEFAFE), // cyan-100
    Color(0xFFA2F4FD), // cyan-200
    Color(0xFF53EAFD), // cyan-300
    Color(0xFF00D3F2), // cyan-400
    Color(0xFF00B8DB), // cyan-500
    Color(0xFF0092B8), // cyan-600
    Color(0xFF007595), // cyan-700
    Color(0xFF005F78), // cyan-800
    Color(0xFF104E64), // cyan-900
    Color(0xFF053345), // cyan-950
  ]);

  /// Tailwind `sky` palette (50 → 950).
  static const NColorScale sky = NColorScale([
    Color(0xFFF0F9FF), // sky-50
    Color(0xFFDFF2FE), // sky-100
    Color(0xFFB8E6FE), // sky-200
    Color(0xFF74D4FF), // sky-300
    Color(0xFF00BCFF), // sky-400
    Color(0xFF00A6F4), // sky-500
    Color(0xFF0084D1), // sky-600
    Color(0xFF0069A8), // sky-700
    Color(0xFF00598A), // sky-800
    Color(0xFF024A70), // sky-900
    Color(0xFF052F4A), // sky-950
  ]);

  /// Tailwind `blue` palette (50 → 950).
  static const NColorScale blue = NColorScale([
    Color(0xFFEFF6FF), // blue-50
    Color(0xFFDBEAFE), // blue-100
    Color(0xFFBEDBFF), // blue-200
    Color(0xFF8EC5FF), // blue-300
    Color(0xFF51A2FF), // blue-400
    Color(0xFF2B7FFF), // blue-500
    Color(0xFF155DFC), // blue-600
    Color(0xFF1447E6), // blue-700
    Color(0xFF193CB8), // blue-800
    Color(0xFF1C398E), // blue-900
    Color(0xFF162456), // blue-950
  ]);

  /// Tailwind `indigo` palette (50 → 950).
  static const NColorScale indigo = NColorScale([
    Color(0xFFEEF2FF), // indigo-50
    Color(0xFFE0E7FF), // indigo-100
    Color(0xFFC6D2FF), // indigo-200
    Color(0xFFA3B3FF), // indigo-300
    Color(0xFF7C86FF), // indigo-400
    Color(0xFF615FFF), // indigo-500
    Color(0xFF4F39F6), // indigo-600
    Color(0xFF432DD7), // indigo-700
    Color(0xFF372AAC), // indigo-800
    Color(0xFF312C85), // indigo-900
    Color(0xFF1E1A4D), // indigo-950
  ]);

  /// Tailwind `violet` palette (50 → 950).
  static const NColorScale violet = NColorScale([
    Color(0xFFF5F3FF), // violet-50
    Color(0xFFEDE9FE), // violet-100
    Color(0xFFDDD6FF), // violet-200
    Color(0xFFC4B4FF), // violet-300
    Color(0xFFA684FF), // violet-400
    Color(0xFF8E51FF), // violet-500
    Color(0xFF7F22FE), // violet-600
    Color(0xFF7008E7), // violet-700
    Color(0xFF5D0EC0), // violet-800
    Color(0xFF4D179A), // violet-900
    Color(0xFF2F0D68), // violet-950
  ]);

  /// Tailwind `purple` palette (50 → 950).
  static const NColorScale purple = NColorScale([
    Color(0xFFFAF5FF), // purple-50
    Color(0xFFF3E8FF), // purple-100
    Color(0xFFE9D4FF), // purple-200
    Color(0xFFDAB2FF), // purple-300
    Color(0xFFC27AFF), // purple-400
    Color(0xFFAD46FF), // purple-500
    Color(0xFF9810FA), // purple-600
    Color(0xFF8200DB), // purple-700
    Color(0xFF6E11B0), // purple-800
    Color(0xFF59168B), // purple-900
    Color(0xFF3C0366), // purple-950
  ]);

  /// Tailwind `fuchsia` palette (50 → 950).
  static const NColorScale fuchsia = NColorScale([
    Color(0xFFFDF4FF), // fuchsia-50
    Color(0xFFFAE8FF), // fuchsia-100
    Color(0xFFF6CFFF), // fuchsia-200
    Color(0xFFF4A8FF), // fuchsia-300
    Color(0xFFED6AFF), // fuchsia-400
    Color(0xFFE12AFB), // fuchsia-500
    Color(0xFFC800DE), // fuchsia-600
    Color(0xFFA800B7), // fuchsia-700
    Color(0xFF8A0194), // fuchsia-800
    Color(0xFF721378), // fuchsia-900
    Color(0xFF4B004F), // fuchsia-950
  ]);

  /// Tailwind `pink` palette (50 → 950).
  static const NColorScale pink = NColorScale([
    Color(0xFFFDF2F8), // pink-50
    Color(0xFFFCE7F3), // pink-100
    Color(0xFFFCCEE8), // pink-200
    Color(0xFFFDA5D5), // pink-300
    Color(0xFFFB64B6), // pink-400
    Color(0xFFF6339A), // pink-500
    Color(0xFFE60076), // pink-600
    Color(0xFFC6005C), // pink-700
    Color(0xFFA3004C), // pink-800
    Color(0xFF861043), // pink-900
    Color(0xFF510424), // pink-950
  ]);

  /// Tailwind `rose` palette (50 → 950).
  static const NColorScale rose = NColorScale([
    Color(0xFFFFF1F2), // rose-50
    Color(0xFFFFE4E6), // rose-100
    Color(0xFFFFCCD3), // rose-200
    Color(0xFFFFA1AD), // rose-300
    Color(0xFFFF637E), // rose-400
    Color(0xFFFF2056), // rose-500
    Color(0xFFEC003F), // rose-600
    Color(0xFFC70036), // rose-700
    Color(0xFFA50036), // rose-800
    Color(0xFF8B0836), // rose-900
    Color(0xFF4D0218), // rose-950
  ]);

  /// Tailwind `slate` palette (50 → 950).
  static const NColorScale slate = NColorScale([
    Color(0xFFF8FAFC), // slate-50
    Color(0xFFF1F5F9), // slate-100
    Color(0xFFE2E8F0), // slate-200
    Color(0xFFCAD5E2), // slate-300
    Color(0xFF90A1B9), // slate-400
    Color(0xFF62748E), // slate-500
    Color(0xFF45556C), // slate-600
    Color(0xFF314158), // slate-700
    Color(0xFF1D293D), // slate-800
    Color(0xFF0F172B), // slate-900
    Color(0xFF020618), // slate-950
  ]);

  /// Tailwind `zinc` palette (50 → 950).
  static const NColorScale zinc = NColorScale([
    Color(0xFFFAFAFA), // zinc-50
    Color(0xFFF4F4F5), // zinc-100
    Color(0xFFE4E4E7), // zinc-200
    Color(0xFFD4D4D8), // zinc-300
    Color(0xFF9F9FA9), // zinc-400
    Color(0xFF71717B), // zinc-500
    Color(0xFF52525C), // zinc-600
    Color(0xFF3F3F46), // zinc-700
    Color(0xFF27272A), // zinc-800
    Color(0xFF18181B), // zinc-900
    Color(0xFF09090B), // zinc-950
  ]);

  /// Tailwind `neutral` palette (50 → 950).
  static const NColorScale neutral = NColorScale([
    Color(0xFFFAFAFA), // neutral-50
    Color(0xFFF5F5F5), // neutral-100
    Color(0xFFE5E5E5), // neutral-200
    Color(0xFFD4D4D4), // neutral-300
    Color(0xFFA1A1A1), // neutral-400
    Color(0xFF737373), // neutral-500
    Color(0xFF525252), // neutral-600
    Color(0xFF404040), // neutral-700
    Color(0xFF262626), // neutral-800
    Color(0xFF171717), // neutral-900
    Color(0xFF0A0A0A), // neutral-950
  ]);

  /// Tailwind `stone` palette (50 → 950).
  static const NColorScale stone = NColorScale([
    Color(0xFFFAFAF9), // stone-50
    Color(0xFFF5F5F4), // stone-100
    Color(0xFFE7E5E4), // stone-200
    Color(0xFFD6D3D1), // stone-300
    Color(0xFFA6A09B), // stone-400
    Color(0xFF79716B), // stone-500
    Color(0xFF57534D), // stone-600
    Color(0xFF44403B), // stone-700
    Color(0xFF292524), // stone-800
    Color(0xFF1C1917), // stone-900
    Color(0xFF0C0A09), // stone-950
  ]);
}
