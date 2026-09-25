import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/nav_item.dart';
import '../../../data/models/profile.dart';
import '../../../providers/navigation_provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../routing/section_navigation.dart';

/// Persistent top navigation.
class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  static const double desktopHeight = 72;
  static const double mobileHeight = 62;

  @override
  Widget build(BuildContext context) {
    final bool desktop = !context.isMobile;
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final NavigationProvider navigation = context.watch<NavigationProvider>();
    final Profile profile = portfolio.profile;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: desktop ? desktopHeight : mobileHeight,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          decoration: const BoxDecoration(
            color: Color(0xE607090F),
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: <Widget>[
              _Brand(name: profile.name, role: profile.role, showRole: desktop),
              const Spacer(),
              if (desktop) ...<Widget>[
                _NavLinks(
                  items: portfolio.navItems,
                  activeSectionId: navigation.activeSectionId,
                ),
                const SizedBox(width: 28),
                AppButton(
                  label: 'Download Resume',
                  icon: Icons.download_rounded,
                  size: AppButtonSize.small,
                  onPressed: () => ExternalLink.download(
                    AppConfig.resumePath,
                    fileName: AppConfig.resumeFileName,
                  ),
                ),
              ] else
                _MenuButton(
                  open: navigation.isMenuOpen,
                  onTap: navigation.toggleMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({
    required this.name,
    required this.role,
    required this.showRole,
  });

  final String name;
  final String role;
  final bool showRole;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Go to top',
      child: InkWell(
        onTap: () => navigateToTop(context),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 11),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontFamily: AppTypography.displayFont,
                      fontSize: 15,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (showRole)
                    Text(
                      role,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        fontSize: 11.5,
                        height: 1.2,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLinks extends StatelessWidget {
  const _NavLinks({required this.items, required this.activeSectionId});

  final List<NavItem> items;
  final String activeSectionId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final NavItem item in items)
          _NavLink(item: item, active: item.sectionId == activeSectionId),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.item, required this.active});

  final NavItem item;
  final bool active;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.active;
    final Color color = active
        ? AppColors.textPrimary
        : _hovered
        ? AppColors.textPrimary
        : AppColors.textMuted;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        selected: active,
        child: InkWell(
          onTap: () => navigateToSection(context, widget.item.sectionId),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style:
                      AppTypography.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.5,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        color: color,
                      ) ??
                      const TextStyle(),
                  child: Text(widget.item.label),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  height: 2,
                  width: active ? 20 : 0,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: open ? 'Close menu' : 'Open menu',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: open
                  ? const Icon(
                      Icons.close_rounded,
                      key: ValueKey<bool>(true),
                      color: AppColors.textPrimary,
                    )
                  : const Icon(
                      Icons.menu_rounded,
                      key: ValueKey<bool>(false),
                      color: AppColors.textPrimary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
