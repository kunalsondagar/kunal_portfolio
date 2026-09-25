import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/skill_group.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';

/// Skills grouped by what they are used for, so the list reads as capability
/// rather than as a keyword dump.
class SkillsSection extends StatelessWidget {
  const SkillsSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<SkillGroup> groups = portfolio.skillGroups;
    final int columns = context.gridColumns(mobile: 1, tablet: 2, desktop: 3);

    return SectionShell(
      id: SectionIds.skills,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'Skills & technologies',
              title: 'The stack I reach for',
              subtitle:
                  'Organised by what each group is actually for, because the tool '
                  'only matters next to the problem it solves.',
            ),
            const SizedBox(height: 44),
            // Content-sized: the badge count per group varies, so a fixed cell
            // height would leave gaps or clip the last row.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const double spacing = 18;
                final double width =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: <Widget>[
                    for (int index = 0; index < groups.length; index++)
                      SizedBox(
                        width: width,
                        child: Reveal(
                          delay: Duration(milliseconds: 60 * (index % columns)),
                          child: _SkillCard(group: groups[index]),
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

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final bool compact = context.isMobile;

    return SurfaceCard(
      accent: group.accent,
      padding: const EdgeInsets.all(22),
      glowOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: group.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: group.accent.withValues(alpha: 0.22),
                  ),
                ),
                child: Icon(group.icon, size: 18, color: group.accent),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  group.title,
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    fontFamily: AppTypography.displayFont,
                    fontSize: 16.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            group.blurb,
            style: AppTypography.textTheme.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: <Widget>[
              for (final String skill in group.skills)
                TechBadge(
                  skill,
                  dense: compact,
                  color: group.highlighted.contains(skill)
                      ? group.accent
                      : AppColors.textMuted,
                  filled: true,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
