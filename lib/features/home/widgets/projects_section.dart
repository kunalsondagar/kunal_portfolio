import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../data/models/project.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';
import '../../project/widgets/project_card.dart';

/// The main showcase: every project, in the order that tells the story best.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<Project> projects = portfolio.featuredProjects;
    final int columns = context.gridColumns(mobile: 1, tablet: 1, desktop: 2);

    return SectionShell(
      id: SectionIds.projects,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionIntro(
              eyebrow: 'Featured projects',
              title: 'The work, and what was actually in it',
              subtitle:
                  'Production apps and a game project, each with the problems I '
                  'ran into and how I solved them.',
            ),
            const SizedBox(height: 44),
            // A Wrap instead of a GridView: project cards have variable copy
            // length, and a fixed cell height would clip the longer ones.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const double spacing = 20;
                final double width =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: <Widget>[
                    for (int index = 0; index < projects.length; index++)
                      SizedBox(
                        width: width,
                        child: Reveal(
                          delay: Duration(milliseconds: 70 * (index % columns)),
                          child: ProjectCard(
                            project: projects[index],
                            onTap: () => context.go(projects[index].route),
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
