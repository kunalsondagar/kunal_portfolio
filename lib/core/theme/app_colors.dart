import 'package:flutter/material.dart';

/// Core palette for the portfolio.
///
/// The whole UI is built from a near-black neutral ramp plus a single
/// Flutter-blue accent and a violet support colour. Keeping the ramp small is
/// what makes the surface layering ([surface], [surfaceHigh], [border]) read as
/// one coherent system instead of a pile of ad-hoc greys.
abstract final class AppColors {
  // ---------------------------------------------------------------- surfaces
  static const Color background = Color(0xFF07090F);
  static const Color backgroundAlt = Color(0xFF090C14);
  static const Color surface = Color(0xFF0D111A);
  static const Color surfaceHigh = Color(0xFF141A26);

  /// Ambient glows painted behind the page. Kept very low alpha so they read as
  /// light rather than as a coloured background.
  static const Color glowBlue = Color(0x1F42A5F5);
  static const Color glowViolet = Color(0x1A7C4DFF);

  // ------------------------------------------------------------------ borders
  static const Color border = Color(0x14FFFFFF);
  static const Color borderStrong = Color(0x2BFFFFFF);

  // --------------------------------------------------------------------- text
  static const Color textPrimary = Color(0xFFF4F7FB);
  static const Color textSecondary = Color(0xFFA3AFC2);
  static const Color textMuted = Color(0xFF6C7789);

  // ------------------------------------------------------------------ accents
  static const Color flutterBlue = Color(0xFF42A5F5);
  static const Color flutterDeep = Color(0xFF0553B1);
  static const Color violet = Color(0xFF7C4DFF);
  static const Color cyan = Color(0xFF22D3EE);

  // ------------------------------------------------------------------- status
  static const Color success = Color(0xFF34D399);
  static const Color danger = Color(0xFFF87171);
  static const Color warning = Color(0xFFFBBF24);
}
