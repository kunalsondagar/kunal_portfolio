import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/process_step.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';

/// How the work actually runs, as a five-step timeline.
class ProcessSection extends StatelessWidget {
  const ProcessSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<ProcessStep> steps = portfolio.processSteps;
    final bool horizontal = context.isDesktop;

    return SectionShell(
      id: SectionIds.process,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'Process',
              title: 'How I work',
              subtitle:
                  'The same sequence on every project, so nothing important is '
                  'decided too late.',
            ),
            const SizedBox(height: 48),
            if (horizontal)
              _HorizontalSteps(steps: steps)
            else
              _VerticalSteps(steps: steps),
          ],
        ),
      ),
    );
  }
}

class _HorizontalSteps extends StatelessWidget {
  const _HorizontalSteps({required this.steps});

  final List<ProcessStep> steps;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double cellWidth = constraints.maxWidth / steps.length;
        // The connector only needs to run between the first and last markers,
        // which are centred in their cells.
        final double inset = cellWidth / 2;

        return Stack(
          children: <Widget>[
            Positioned(
              top: 19,
              left: inset,
              right: inset,
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < steps.length - 1; i++)
                    const Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              AppColors.flutterBlue,
                              AppColors.violet,
                            ],
                          ),
                        ),
                        child: SizedBox(height: 1, width: double.infinity),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < steps.length; i++)
                  Expanded(
                    child: Reveal(
                      delay: Duration(milliseconds: 80 * i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _StepBody(step: steps[i], showMarker: true),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _VerticalSteps extends StatelessWidget {
  const _VerticalSteps({required this.steps});

  final List<ProcessStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < steps.length; i++)
          _VerticalStep(
            step: steps[i],
            isLast: i == steps.length - 1,
            index: i,
          ),
      ],
    );
  }
}

class _VerticalStep extends StatelessWidget {
  const _VerticalStep({
    required this.step,
    required this.isLast,
    required this.index,
  });

  final ProcessStep step;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            StepNumber(step.number),
            if (!isLast)
              Container(
                width: 1.5,
                height: 108,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 26),
            child: Reveal(
              delay: Duration(milliseconds: 60 * index),
              child: _StepBody(step: step),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.step, this.showMarker = false});

  final ProcessStep step;

  /// In the horizontal layout the marker sits above the copy, outside this
  /// widget's column of text.
  final bool showMarker;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showMarker) ...<Widget>[
          Center(child: StepNumber(step.number)),
          const SizedBox(height: 22),
        ],
        Text(
          step.title,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            fontFamily: AppTypography.displayFont,
            fontSize: 17.5,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          step.description,
          style: AppTypography.textTheme.bodySmall?.copyWith(height: 1.6),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: <Widget>[
            for (final String point in step.points)
              TechBadge(
                point,
                dense: true,
                filled: true,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ],
    );
  }
}
