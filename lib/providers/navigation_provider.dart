import 'package:flutter/material.dart';

import '../core/utils/viewport.dart';
import '../data/sources/portfolio_content.dart';

/// Owns everything about "where the visitor is": which navbar entry is active,
/// whether the mobile menu is open, and the scroll position used to move between
/// sections.
class NavigationProvider extends ChangeNotifier {
  NavigationProvider();

  /// A section counts as active once its top passes this fraction of the
  /// viewport height — the same idea as a scroll spy.
  static const double _activeLine = 0.32;

  static const Duration _scrollDuration = Duration(milliseconds: 620);

  ScrollController? _controller;
  final Map<String, GlobalKey> _sections = <String, GlobalKey>{};

  String _activeSectionId = SectionIds.home;
  bool _menuOpen = false;

  String get activeSectionId => _activeSectionId;

  bool get isMenuOpen => _menuOpen;

  GlobalKey keyFor(String sectionId) =>
      _sections.putIfAbsent(sectionId, GlobalKey.new);

  void attach(ScrollController controller) {
    if (identical(_controller, controller)) return;
    _controller?.removeListener(_updateActive);
    _controller = controller;
    controller.addListener(_updateActive);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateActive());
  }

  void detach() {
    _controller?.removeListener(_updateActive);
    _controller = null;
  }

  void openMenu() {
    if (_menuOpen) return;
    _menuOpen = true;
    notifyListeners();
  }

  void closeMenu() {
    if (!_menuOpen) return;
    _menuOpen = false;
    notifyListeners();
  }

  void toggleMenu() => _menuOpen ? closeMenu() : openMenu();

  /// Clears per-page state when leaving a route.
  void resetForRoute() {
    _sections.clear();
    _activeSectionId = SectionIds.home;
    if (_menuOpen) {
      _menuOpen = false;
      notifyListeners();
    }
  }

  /// Smoothly scrolls to [sectionId]. Returns false when that section is not
  /// mounted on the current page, so the caller can navigate first.
  Future<bool> scrollToSection(String sectionId) async {
    final ScrollController? controller = _controller;
    final BuildContext? target = _sections[sectionId]?.currentContext;
    if (controller == null ||
        !controller.hasClients ||
        target == null ||
        !target.mounted) {
      return false;
    }

    final RenderObject? box = target.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return false;

    if (sectionId == SectionIds.home) {
      await controller.animateTo(
        0,
        duration: _scrollDuration,
        curve: Curves.easeInOutCubic,
      );
      return true;
    }

    final double destination = (box.localToGlobal(Offset.zero).dy).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );

    await controller.animateTo(
      destination,
      duration: _scrollDuration,
      curve: Curves.easeInOutCubic,
    );
    return true;
  }

  /// Recomputes which section the visitor is looking at.
  void _updateActive() {
    final ScrollController? controller = _controller;
    if (controller == null || !controller.hasClients || _sections.isEmpty) {
      return;
    }

    String? current;
    double currentTop = double.negativeInfinity;
    double? line;

    for (final MapEntry<String, GlobalKey> entry in _sections.entries) {
      final BuildContext? sectionContext = entry.value.currentContext;
      if (sectionContext == null || !sectionContext.mounted) continue;

      final RenderObject? box = sectionContext.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;

      line ??= viewportHeightOf(sectionContext);
      if (line == null) return;

      final double top = box.localToGlobal(Offset.zero).dy;
      if (top <= line * _activeLine && top > currentTop) {
        currentTop = top;
        current = entry.key;
      }
    }

    // Above the first section (or at the very top) the hero is what is on screen.
    final String next = current ?? SectionIds.home;
    if (next == _activeSectionId) return;

    _activeSectionId = next;
    notifyListeners();
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }
}
