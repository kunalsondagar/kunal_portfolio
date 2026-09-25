import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/nav_item.dart';
import '../../../data/models/profile.dart';
import '../../../providers/navigation_provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../routing/section_navigation.dart';

/// Slide-in navigation panel for phone widths.
///
/// Rendered by [SiteShell] only while the menu is open, so it never intercepts
/// taps on the page underneath.
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navigation = context.watch<NavigationProvider>();
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final Profile profile = portfolio.profile;

    return Stack(
      children: <Widget>[
        // Scrim: tap anywhere to dismiss.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: navigation.closeMenu,
            child: const ColoredBox(color: Color(0xB3000000)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, double t, Widget? child) =>
                Transform.translate(
                  offset: Offset((1 - t) * 60, 0),
                  child: Opacity(opacity: t, child: child),
                ),
            child: Container(
              width: (MediaQuery.sizeOf(context).width * 0.84).clamp(
                268.0,
                360.0,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(left: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    profile.name,
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontFamily: AppTypography.displayFont,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(profile.role, style: AppTypography.textTheme.bodySmall),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        for (final NavItem item in portfolio.navItems)
                          _MobileMenuLink(
                            item: item,
                            active:
                                item.sectionId == navigation.activeSectionId,
                            onTap: () {
                              navigation.closeMenu();
                              navigateToSection(context, item.sectionId);
                            },
                          ),
                      ],
                    ),
                  ),
                  AppButton(
                    label: 'Download Resume',
                    icon: Icons.download_rounded,
                    expand: true,
                    onPressed: () {
                      navigation.closeMenu();
                      ExternalLink.download(
                        AppConfig.resumePath,
                        fileName: AppConfig.resumeFileName,
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    profile.location,
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileMenuLink extends StatelessWidget {
  const _MobileMenuLink({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 22,
              decoration: BoxDecoration(
                gradient: active ? AppGradients.primary : null,
                color: active ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              item.label,
              style: AppTypography.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
