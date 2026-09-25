import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/navigation_provider.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/mobile_menu.dart';

/// Shared chrome: a fixed navbar on top and the footer at the bottom, with the
/// routed page scrolling in between.
///
/// A column rather than an overlay keeps the navbar permanently visible with no
/// layout shift when the page scrolls, on both routes.
class SiteShell extends StatelessWidget {
  const SiteShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool menuOpen = context.select<NavigationProvider, bool>(
      (NavigationProvider navigation) => navigation.isMenuOpen,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          // Page background sits under everything so the shell can stay
          // transparent and let the glows bleed through.
          const Positioned.fill(child: _PageBackground()),
          Column(
            children: <Widget>[
              const AppNavBar(),
              Expanded(child: child),
              const AppFooter(),
            ],
          ),
          if (menuOpen) const Positioned.fill(child: MobileMenu()),
        ],
      ),
    );
  }
}

/// The site's base backdrop: near-black with two soft accent glows.
class _PageBackground extends StatelessWidget {
  const _PageBackground();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.background,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -220,
            right: -140,
            child: _Glow(size: 620, color: AppColors.glowBlue),
          ),
          Positioned(
            top: 180,
            left: -220,
            child: _Glow(size: 560, color: AppColors.glowViolet),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
