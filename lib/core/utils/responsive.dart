import 'package:flutter/widgets.dart';

import '../constants/breakpoints.dart';

/// `context.s.isMobile` style accessors, so layout decisions read cleanly
/// instead of scattering `MediaQuery.sizeOf(context).width > 1024` everywhere.
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  ScreenSize get screen => Breakpoints.of(screenWidth);

  bool get isMobile => screen.isMobile;

  bool get isTablet => screen.isTablet;

  bool get isDesktop => screen.isDesktop;

  bool get isWide => screen.isWide;

  bool get hasSideBySide => screen.hasSideBySide;

  /// Horizontal page padding, generous on desktop and compact on phones.
  double get gutter => switch (screen) {
    ScreenSize.mobile => 20,
    ScreenSize.tablet => 32,
    ScreenSize.desktop => 40,
    ScreenSize.wide => 56,
  };

  /// The width content is laid out in before centring.
  double get contentWidth => Breakpoints.contentMaxWidth;

  /// Picks a value per screen size without a switch at every call site.
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    required T desktop,
    T? wide,
  }) {
    return switch (screen) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet ?? desktop,
      ScreenSize.desktop => desktop,
      ScreenSize.wide => wide ?? desktop,
    };
  }

  /// Columns for responsive grids. Always given an explicit value so the
  /// layout never depends on a child count.
  int gridColumns({required int mobile, int? tablet, required int desktop}) {
    return switch (screen) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet ?? desktop,
      ScreenSize.desktop => desktop,
      ScreenSize.wide => desktop,
    };
  }
}
