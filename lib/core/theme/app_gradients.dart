import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Gradients used across the portfolio.
///
/// Kept in one place so accent treatments stay consistent — every gradient
/// here runs blue -> violet, which is the single accent direction used by the
/// hero, buttons, badges, borders and the project detail header.
abstract final class AppGradients {
  static const List<Color> accent = <Color>[
    AppColors.flutterBlue,
    AppColors.violet,
  ];

  static const LinearGradient primary = LinearGradient(
    colors: accent,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Used for filled surfaces that need a touch more depth than a flat colour.
  static const LinearGradient card = LinearGradient(
    colors: <Color>[Color(0xFF111726), Color(0xFF0C1017)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Paints its child as accent-gradient text.
  ///
  /// A method rather than a constant because [ShaderMask] needs a closure, which
  /// cannot be a const value.
  static Widget textMask({required Widget child}) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => primary.createShader(bounds),
      child: child,
    );
  }

  static const LinearGradient divider = LinearGradient(
    colors: <Color>[
      Colors.transparent,
      AppColors.borderStrong,
      Colors.transparent,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Page background: near-black with two faint accent glows.
  static const LinearGradient page = LinearGradient(
    colors: <Color>[
      AppColors.background,
      AppColors.backgroundAlt,
      AppColors.background,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: <double>[0.0, 0.45, 1.0],
  );
}
