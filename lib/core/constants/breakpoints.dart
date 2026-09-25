/// Layout breakpoints.
///
/// Two breakpoints are enough for this site: a single-column phone layout and a
/// multi-column desktop layout, with a short "large desktop" range on top for
/// the hero and the project grid.
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  wide;

  bool get isMobile => this == ScreenSize.mobile;
  bool get isTablet => this == ScreenSize.tablet;
  bool get isDesktop => this == ScreenSize.desktop || this == ScreenSize.wide;
  bool get isWide => this == ScreenSize.wide;
}

extension ScreenSizeX on ScreenSize {
  /// True when there is room for a side-by-side layout.
  bool get hasSideBySide => !isMobile;
}

abstract final class Breakpoints {
  static const double tablet = 700;
  static const double desktop = 1024;
  static const double wide = 1400;

  /// Max content width. Sections are centred inside this so lines never get
  /// uncomfortably long on an ultrawide monitor.
  static const double contentMaxWidth = 1180;
  static const double contentMaxWidthNarrow = 820;

  static ScreenSize of(double width) {
    if (width >= wide) return ScreenSize.wide;
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}
