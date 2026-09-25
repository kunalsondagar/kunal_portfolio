import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/models/service_item.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';

/// What he can be hired to do.
class ServicesSection extends StatelessWidget {
  const ServicesSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<ServiceItem> services = portfolio.services;
    final int columns = context.gridColumns(mobile: 1, tablet: 2, desktop: 3);

    return SectionShell(
      id: SectionIds.services,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'What I do',
              title: 'How I can help',
              subtitle:
                  'The work I take on as a Flutter developer — from first screen to '
                  'a stable production build.',
            ),
            const SizedBox(height: 44),
            // Content-sized so the longer service descriptions are never clipped
            // by a fixed cell height.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const double spacing = 18;
                final double width =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: <Widget>[
                    for (int index = 0; index < services.length; index++)
                      SizedBox(
                        width: width,
                        child: Reveal(
                          delay: Duration(milliseconds: 60 * (index % columns)),
                          child: _ServiceCard(
                            service: services[index],
                            index: index,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.index});

  final ServiceItem service;
  final int index;

  static const List<Color> _accents = <Color>[
    AppColors.flutterBlue,
    AppColors.violet,
    AppColors.cyan,
    AppColors.success,
    AppColors.warning,
    AppColors.flutterBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final Color accent = _accents[index % _accents.length];

    return SurfaceCard(
      accent: accent,
      padding: const EdgeInsets.all(24),
      glowOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent.withValues(alpha: 0.24)),
                ),
                child: Icon(service.icon, size: 19, color: accent),
              ),
              const Spacer(),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) =>
                    AppGradients.primary.createShader(bounds),
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: AppTypography.mono.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            service.title,
            style: AppTypography.textTheme.titleMedium?.copyWith(
              fontFamily: AppTypography.displayFont,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            service.description,
            style: AppTypography.textTheme.bodySmall?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: <Widget>[
              for (final String point in service.points)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.check_rounded, size: 13, color: accent),
                    const SizedBox(width: 6),
                    Text(
                      point,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
