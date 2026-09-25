import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Type system.
///
/// * **Space Grotesk** — display / headings. Geometric, developer-flavoured.
/// * **Inter** — everything else. Both are bundled locally (see `pubspec.yaml`)
///   so there is no runtime font fetch and no layout shift on first paint.
abstract final class AppTypography {
  static const String displayFont = 'SpaceGrotesk';
  static const String bodyFont = 'Inter';

  static const TextStyle _display = TextStyle(
    fontFamily: displayFont,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _body = TextStyle(
    fontFamily: bodyFont,
    color: AppColors.textSecondary,
    height: 1.65,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w400,
  );

  /// Not a `const` TextTheme: the per-role sizes come from `copyWith`, which
  /// cannot appear in a const expression.
  static TextTheme get textTheme {
    return TextTheme(
      // ---------------------------------------------------------- display
      displayLarge: _display,
      displayMedium: _display,
      displaySmall: _display,

      // ------------------------------------------------------------ heading
      headlineLarge: _display.copyWith(fontSize: 44, letterSpacing: -1.0),
      headlineMedium: _display.copyWith(fontSize: 34, letterSpacing: -0.6),
      headlineSmall: _display.copyWith(fontSize: 26, letterSpacing: -0.3),

      // -------------------------------------------------------------- title
      titleLarge: _display.copyWith(fontSize: 21, letterSpacing: -0.2),
      titleMedium: _body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      titleSmall: _body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      ),

      // --------------------------------------------------------------- body
      bodyLarge: _body.copyWith(fontSize: 17, height: 1.7),
      bodyMedium: _body.copyWith(fontSize: 15, height: 1.7),
      bodySmall: _body.copyWith(
        fontSize: 13.5,
        height: 1.55,
        color: AppColors.textMuted,
      ),

      // -------------------------------------------------------------- label
      labelLarge: _body.copyWith(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0,
        height: 1.2,
      ),
      labelMedium: _body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: AppColors.textMuted,
        height: 1.2,
      ),
    );
  }

  /// Monospace-ish styling for the small code-like labels (`01`, `/projects`).
  /// Not const because [FontFeature.tabularFigures] is a runtime call.
  static final TextStyle mono = TextStyle(
    fontFamily: bodyFont,
    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
  );
}
