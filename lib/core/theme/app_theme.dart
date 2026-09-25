import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_typography.dart';

/// Assembles the single dark [ThemeData] used by the whole app.
abstract final class AppTheme {
  static ThemeData get dark {
    final TextTheme text = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.flutterBlue,
        onPrimary: Colors.white,
        secondary: AppColors.violet,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.danger,
        onError: Colors.white,
        outline: AppColors.borderStrong,
      ),
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,

      // ---------------------------------------------------------- form fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface.withValues(alpha: 0.6),
        hintStyle: text.bodyMedium?.copyWith(color: AppColors.textMuted),
        labelStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: text.bodyMedium?.copyWith(
          color: AppColors.flutterBlue,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(
          AppColors.flutterBlue.withValues(alpha: 0.7),
          width: 1.4,
        ),
        errorBorder: _inputBorder(AppColors.danger.withValues(alpha: 0.6)),
        focusedErrorBorder: _inputBorder(AppColors.danger, width: 1.4),
        errorStyle: text.bodySmall?.copyWith(color: AppColors.danger),
      ),

      // --------------------------------------------------------------- cursor
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.flutterBlue,
        selectionColor: Color(0x3342A5F5),
        selectionHandleColor: AppColors.flutterBlue,
      ),

      // ------------------------------------------------------------ scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll<Color>(AppColors.borderStrong),
        thickness: const WidgetStatePropertyAll<double>(6),
        radius: const Radius.circular(99),
      ),

      // ----------------------------------------------------------- page route
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        textStyle: text.bodySmall?.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// Light status-bar icons for the dark chrome.
  static const SystemUiOverlayStyle systemOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Gradient used by the app's primary buttons and accent underlines.
  static const List<Color> accent = AppGradients.accent;
}
