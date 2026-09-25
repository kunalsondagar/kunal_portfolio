import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/experience_entry.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';

/// Work history as a vertical timeline rather than a list of paragraphs.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<ExperienceEntry> entries = portfolio.experiences;
    final bool wide = context.hasSideBySide;

    return SectionShell(
      id: SectionIds.experience,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'Experience',
              title: 'Where I have built things',
              subtitle:
                  'Two years of production Flutter work across client projects — '
                  'shipping features, integrating services and keeping apps stable.',
            ),
            const SizedBox(height: 48),
            for (int i = 0; i < entries.length; i++)
              _TimelineEntry(
                entry: entries[i],
                isFirst: i == 0,
                isLast: i == entries.length - 1,
                wide: wide,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.wide,
  });

  final ExperienceEntry entry;
  final bool isFirst;
  final bool isLast;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final Color accent = entry.isCurrent
        ? AppColors.flutterBlue
        : AppColors.textMuted;

    final Widget rail = SizedBox(
      width: 30,
      child: Column(
        children: <Widget>[
          // Line above the dot, omitted for the first entry.
          if (!isFirst)
            Expanded(child: Container(width: 1.5, color: AppColors.border))
          else
            const SizedBox.shrink(),
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.isCurrent ? accent : AppColors.background,
              border: Border.all(color: accent, width: 2),
              boxShadow: entry.isCurrent
                  ? <BoxShadow>[
                      BoxShadow(
                        color: accent.withValues(alpha: 0.4),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          if (!isLast)
            Expanded(child: Container(width: 1.5, color: AppColors.border)),
        ],
      ),
    );

    final Widget card = _ExperienceCard(entry: entry, wide: wide);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 30),
      // IntrinsicHeight gives the rail a height to match the card, so the
      // connector can stretch without forcing an infinite height on the Row.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            rail,
            const SizedBox(width: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Reveal(child: card),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.entry, required this.wide});

  final ExperienceEntry entry;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final Widget header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    entry.company,
                    style: AppTypography.textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.role,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.flutterBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _PeriodPill(period: entry.period, isCurrent: entry.isCurrent),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            const Icon(
              Icons.place_outlined,
              size: 14,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                entry.location,
                style: AppTypography.textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          entry.summary,
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );

    final Widget list = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final String item in entry.responsibilities)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry.isCurrent
                          ? AppColors.flutterBlue
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return SurfaceCard(
      padding: const EdgeInsets.all(26),
      accent: entry.isCurrent ? AppColors.flutterBlue : AppColors.textMuted,
      glowOnHover: false,
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: header),
                const SizedBox(width: 32),
                Expanded(flex: 5, child: list),
                const SizedBox(width: 28),
                Expanded(flex: 2, child: _StackColumn(stack: entry.stack)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header,
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                list,
                const SizedBox(height: 6),
                _StackColumn(stack: entry.stack),
              ],
            ),
    );
  }
}

class _StackColumn extends StatelessWidget {
  const _StackColumn({required this.stack});

  final List<String> stack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const MicroLabel('Stack'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: <Widget>[
            for (final String item in stack) TechBadge(item, dense: true),
          ],
        ),
      ],
    );
  }
}

class _PeriodPill extends StatelessWidget {
  const _PeriodPill({required this.period, required this.isCurrent});

  final String period;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final bool compact = context.isMobile;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12, vertical: 7),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.flutterBlue.withValues(alpha: 0.10)
            : AppColors.textPrimary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: isCurrent
              ? AppColors.flutterBlue.withValues(alpha: 0.30)
              : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isCurrent) ...<Widget>[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.flutterBlue,
              ),
            ),
            const SizedBox(width: 7),
          ],
          Text(
            period,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              fontSize: 12.5,
              color: isCurrent ? AppColors.flutterBlue : AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
