import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/profile.dart';
import '../../../data/models/profile_fact.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';

/// Who he is, in prose, plus the four facts a recruiter scans for.
class AboutSection extends StatelessWidget {
  const AboutSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final Profile profile = portfolio.profile;
    final List<ProfileFact> facts = portfolio.aboutFacts;
    final bool sideBySide = context.isDesktop;

    final Widget prose = _Prose(profile: profile);
    final Widget factGrid = _FactGrid(facts: facts);

    return SectionShell(
      id: SectionIds.about,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'About me',
              title: 'A developer who ships, not just prototypes',
              subtitle: 'Here is the short version of who I am, what I work on, and how I like to work.',
            ),
            const SizedBox(height: 44),
            if (sideBySide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 7, child: prose),
                  const SizedBox(width: 48),
                  Expanded(flex: 5, child: factGrid),
                ],
              )
            else ...<Widget>[prose, const SizedBox(height: 36), factGrid],
          ],
        ),
      ),
    );
  }
}

class _Prose extends StatelessWidget {
  const _Prose({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Reveal(
          child: Text(
            profile.intro,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 19,
              height: 1.55,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        for (final String paragraph in profile.aboutParagraphs.skip(
          1,
        )) ...<Widget>[
          Text(
            paragraph,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 8),
        Reveal(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final String area in profile.focusAreas)
                TechBadge(area, filled: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _FactGrid extends StatelessWidget {
  const _FactGrid({required this.facts});

  final List<ProfileFact> facts;

  @override
  Widget build(BuildContext context) {
    final int columns = context.gridColumns(mobile: 2, desktop: 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: facts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        // No fixed mainAxisExtent: the value text wraps to two lines on narrow
        // columns, and a hard extent would clip it.
      ),
      itemBuilder: (BuildContext context, int index) => Reveal(
        delay: Duration(milliseconds: 70 * index),
        child: _FactCard(fact: facts[index]),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.fact});

  final ProfileFact fact;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 16,
      glowOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.flutterBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(fact.icon, size: 16, color: AppColors.flutterBlue),
          ),
          const SizedBox(height: 12),
          Text(
            fact.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.textTheme.titleMedium?.copyWith(
              fontFamily: AppTypography.displayFont,
              fontSize: 15.5,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            fact.label,
            style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

/// Small decorative stat strip shown under the About prose.
class AboutStatsRow extends StatelessWidget {
  const AboutStatsRow({required this.stats, super.key});

  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final StatItem stat in stats)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) =>
                      AppGradients.primary.createShader(bounds),
                  child: Text(
                    stat.value,
                    style: AppTypography.textTheme.headlineSmall?.copyWith(
                      fontSize: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(stat.label, style: AppTypography.textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}
