import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/code_window.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/profile.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../routing/section_navigation.dart';

/// Opening screen: who he is, what he does, and the two actions that matter.
class HeroSection extends StatelessWidget {
  const HeroSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final Profile profile = portfolio.profile;
    final bool sideBySide = context.isDesktop;

    final Widget copy = _HeroCopy(profile: profile);
    final Widget visual = _HeroVisual(profile: profile);

    return SectionShell(
      id: SectionIds.home,
      padding: EdgeInsets.only(top: context.verticalSectionGap * 0.5),
      showDivider: false,
      child: KeyedSubtree(
        key: sectionKey,
        child: sideBySide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 11, child: copy),
                  const SizedBox(width: 56),
                  Expanded(flex: 9, child: visual),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[copy, const SizedBox(height: 52), visual],
              ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool compact = context.isMobile;

    final double nameSize = context.responsiveValue(
      mobile: 38.0,
      tablet: 52.0,
      desktop: 64.0,
      wide: 72.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Reveal(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.28),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  'Available for new work',
                  style: text.labelMedium?.copyWith(
                    color: AppColors.success,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          delay: const Duration(milliseconds: 60),
          child: AppGradients.textMask(
            child: Text(
              profile.name,
              style: text.displayLarge?.copyWith(
                fontSize: nameSize,
                height: 1.02,
                letterSpacing: -2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Reveal(
          delay: const Duration(milliseconds: 120),
          child: Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 2,
                decoration: const BoxDecoration(gradient: AppGradients.primary),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  profile.role,
                  style: text.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveValue(
                      mobile: 19.0,
                      desktop: 24.0,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          delay: const Duration(milliseconds: 180),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: compact ? double.infinity : 560,
            ),
            child: Text(
              profile.headline,
              style: text.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: context.responsiveValue(mobile: 15.5, desktop: 17),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Reveal(
          delay: const Duration(milliseconds: 240),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              AppButton(
                label: 'View My Work',
                icon: Icons.arrow_forward_rounded,
                size: AppButtonSize.large,
                onPressed: () =>
                    navigateToSection(context, SectionIds.projects),
              ),
              AppButton(
                label: 'Download Resume',
                icon: Icons.download_rounded,
                variant: AppButtonVariant.outline,
                size: AppButtonSize.large,
                onPressed: () => ExternalLink.download(
                  AppConfig.resumePath,
                  fileName: AppConfig.resumeFileName,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        Reveal(
          delay: const Duration(milliseconds: 300),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final String badge in profile.heroBadges)
                TechBadge(badge, filled: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Reveal(
          delay: const Duration(milliseconds: 160),
          child: CodeWindow(
            title: 'ride_booking_controller.dart',
            lines: _snippet,
          ),
        ),
        // Floating stat cards, offset outside the window on wide screens.
        if (context.isDesktop)
          Positioned(
            left: -28,
            bottom: 34,
            child: _FloatStat(stats: profile.heroStats[0]),
          ),
        if (context.isDesktop)
          Positioned(
            right: -22,
            top: 30,
            child: _FloatStat(stats: profile.heroStats[2]),
          ),
        if (context.isMobile)
          Positioned(
            left: 10,
            bottom: -18,
            child: _FloatStat(stats: profile.heroStats[0]),
          ),
      ],
    );
  }

  /// A real, idiomatic slice of the kind of controller used in a ride booking
  /// flow — reactive state, a loading flag, and a guarded async action.
  static const List<CodeLine> _snippet = <CodeLine>[
    CodeLine(<CodeToken>[
      CodeToken('class ', CodeWindow.keyword),
      CodeToken('RideBookingController', CodeWindow.type),
      CodeToken(' extends ', CodeWindow.keyword),
      CodeToken('GetxController', CodeWindow.type),
      CodeToken(' {', CodeWindow.plain),
    ]),
    CodeLine(<CodeToken>[
      CodeToken('final ', CodeWindow.keyword),
      CodeToken('selectedCar', CodeWindow.type),
      CodeToken(' = ', CodeWindow.plain),
      CodeToken("'RXL'", CodeWindow.string),
      CodeToken('.obs', CodeWindow.keyword),
      CodeToken(';', CodeWindow.plain),
    ], indent: 1),
    CodeLine(<CodeToken>[
      CodeToken('final ', CodeWindow.keyword),
      CodeToken('isBooking', CodeWindow.type),
      CodeToken(' = ', CodeWindow.plain),
      CodeToken('false', CodeWindow.keyword),
      CodeToken('.obs', CodeWindow.keyword),
      CodeToken(';', CodeWindow.plain),
    ], indent: 1),
    CodeLine(<CodeToken>[]),
    CodeLine(<CodeToken>[
      CodeToken('Future', CodeWindow.keyword),
      CodeToken('<void> ', CodeWindow.keyword),
      CodeToken('bookRide', CodeWindow.fn),
      CodeToken('(', CodeWindow.plain),
      CodeToken('Location', CodeWindow.type),
      CodeToken(' pickup) ', CodeWindow.plain),
      CodeToken('async', CodeWindow.keyword),
      CodeToken(' {', CodeWindow.plain),
    ], indent: 1),
    CodeLine(<CodeToken>[
      CodeToken('if', CodeWindow.keyword),
      CodeToken(' (isBooking', CodeWindow.type),
      CodeToken('.value) ', CodeWindow.plain),
      CodeToken('return', CodeWindow.keyword),
      CodeToken(';', CodeWindow.plain),
    ], indent: 2),
    CodeLine(<CodeToken>[
      CodeToken('isBooking', CodeWindow.type),
      CodeToken('.value = ', CodeWindow.plain),
      CodeToken('true', CodeWindow.keyword),
      CodeToken(';', CodeWindow.plain),
    ], indent: 2),
    CodeLine(<CodeToken>[
      CodeToken('await', CodeWindow.keyword),
      CodeToken(' _api', CodeWindow.type),
      CodeToken('.', CodeWindow.plain),
      CodeToken('createRide', CodeWindow.fn),
      CodeToken('(', CodeWindow.plain),
      CodeToken('pickup', CodeWindow.type),
      CodeToken(', ', CodeWindow.plain),
      CodeToken('car', CodeWindow.type),
      CodeToken(');', CodeWindow.plain),
    ], indent: 2),
    CodeLine(<CodeToken>[
      CodeToken('Get', CodeWindow.fn),
      CodeToken('.', CodeWindow.plain),
      CodeToken('to', CodeWindow.fn),
      CodeToken('(() => ', CodeWindow.plain),
      CodeToken('const', CodeWindow.keyword),
      CodeToken(' BookingScreen', CodeWindow.type),
      CodeToken('());', CodeWindow.plain),
    ], indent: 2),
    CodeLine(<CodeToken>[CodeToken('}', CodeWindow.plain)], indent: 1),
    CodeLine(<CodeToken>[CodeToken('}', CodeWindow.plain)]),
  ];
}

class _FloatStat extends StatelessWidget {
  const _FloatStat({required this.stats});

  final StatItem stats;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 420),
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        borderRadius: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (stats.icon != null) ...<Widget>[
              Icon(stats.icon, size: 18, color: AppColors.flutterBlue),
              const SizedBox(width: 11),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  stats.value,
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    fontFamily: AppTypography.displayFont,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stats.label,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
