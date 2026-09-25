import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/models/education_item.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';

/// Degree, university and the two numbers worth stating.
class EducationSection extends StatelessWidget {
  const EducationSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<EducationItem> items = portfolio.education;

    return SectionShell(
      id: SectionIds.education,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'Education',
              title: 'Where the fundamentals came from',
            ),
            const SizedBox(height: 40),
            for (int i = 0; i < items.length; i++)
              Reveal(
                delay: Duration(milliseconds: 80 * i),
                child: _EducationCard(item: items[i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.item});

  final EducationItem item;

  @override
  Widget build(BuildContext context) {
    final bool sideBySide = context.hasSideBySide;

    final Widget main = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0x2642A5F5), Color(0x0D7C4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.flutterBlue.withValues(alpha: 0.28),
            ),
          ),
          child: const Icon(
            Icons.school_outlined,
            size: 21,
            color: AppColors.flutterBlue,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.degree,
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.field,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.flutterBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 18,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _MetaLine(
                    icon: Icons.business_outlined,
                    text: '${item.institution} · ${item.university}',
                  ),
                  _MetaLine(
                    icon: Icons.calendar_today_outlined,
                    text: item.period,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final Widget metrics = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < item.highlights.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 14),
          _MetricTile(highlight: item.highlights[i]),
        ],
      ],
    );

    return SurfaceCard(
      padding: const EdgeInsets.all(26),
      glowOnHover: false,
      child: sideBySide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: main),
                const SizedBox(width: 28),
                metrics,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[main, const SizedBox(height: 22), metrics],
            ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 7),
        Text(text, style: AppTypography.textTheme.bodySmall),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.highlight});

  final EducationHighlight highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppGradients.textMask(
            child: Text(
              highlight.value,
              style: AppTypography.textTheme.headlineSmall?.copyWith(
                fontSize: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            highlight.label,
            style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
