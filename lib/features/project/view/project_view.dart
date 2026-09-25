import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/reveal/reveal_coordinator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/project.dart';
import '../../../data/models/project_support.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/navigation_provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../routing/route_names.dart';
import '../../../routing/section_navigation.dart';
import '../widgets/project_card.dart';

/// Standalone page for one project, at `/projects/<id>`.
///
/// Built as a sequence of named blocks rather than tabs, because the content is
/// read top to bottom: what it is, what it does, how it is built, what was
/// hard, and what is next.
class ProjectView extends StatefulWidget {
  const ProjectView({required this.projectId, super.key});

  final String projectId;

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  final ScrollController _scrollController = ScrollController();

  NavigationProvider? _navigation;
  RevealCoordinator? _reveals;
  String? _routeProjectId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final NavigationProvider navigation = context.read<NavigationProvider>();
    final RevealCoordinator reveals = context.read<RevealCoordinator>();
    final String projectId =
        GoRouterState.of(context).pathParameters['id'] ?? '';

    if (identical(navigation, _navigation) && identical(reveals, _reveals)) {
      // Only a change of :id should reset the page. Theme and text-scale
      // changes also land here and must not scroll the user back to the top.
      if (projectId != _routeProjectId) {
        _routeProjectId = projectId;
        if (_scrollController.hasClients) _scrollController.jumpTo(0);
      }
      return;
    }

    // The navbar tracks home-page sections, which do not exist here.
    _navigation?.detach();
    _navigation = navigation;
    _reveals = reveals;
    _routeProjectId = projectId;
    navigation.resetForRoute();
    reveals.attach(_scrollController);
  }

  @override
  void dispose() {
    _navigation?.detach();
    _reveals?.detach();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final Project? project = portfolio.projectById(widget.projectId);

    if (project == null) {
      return _UnknownProject(projectId: widget.projectId);
    }

    final Project? next = portfolio.nextProject(project.id);

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ProjectHero(project: project),
            _OverviewBlock(project: project),
            _FeaturesBlock(project: project),
            _GalleryBlock(project: project),
            _DevelopmentBlock(project: project),
            _ChallengesBlock(project: project),
            _StackBlock(project: project),
            if (next != null) _NextProjectBlock(project: next),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ProjectHero extends StatelessWidget {
  const _ProjectHero({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final bool sideBySide = context.isDesktop;

    final Widget title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Breadcrumb(project: project),
        const SizedBox(height: 26),
        Reveal(child: ProjectAccentBar(accent: project.accent)),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 60),
          child: Text(
            project.name,
            style: AppTypography.textTheme.displaySmall?.copyWith(
              fontSize: context.responsiveValue(
                mobile: 32.0,
                tablet: 42.0,
                desktop: 52.0,
              ),
              height: 1.06,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 120),
          child: Text(
            project.tagline,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              color: project.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          delay: const Duration(milliseconds: 180),
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            children: <Widget>[
              _MetaItem(
                label: 'Role',
                value: project.role,
                icon: Icons.badge_outlined,
              ),
              _MetaItem(
                label: 'Platforms',
                value: project.platforms.join(' · '),
                icon: Icons.devices_outlined,
              ),
              _MetaItem(
                label: 'Category',
                value: project.categoryLabel,
                icon: project.isGame
                    ? Icons.sports_esports_outlined
                    : Icons.phone_iphone_rounded,
              ),
            ],
          ),
        ),
      ],
    );

    final Widget stack = _HeroStackCard(project: project);

    return SectionShell(
      id: 'project-${project.id}',
      showDivider: false,
      padding: EdgeInsets.only(top: context.verticalSectionGap * 0.45),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          if (sideBySide) ProjectHeaderGlow(accent: project.accent),
          if (sideBySide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 7, child: title),
                const SizedBox(width: 48),
                Expanded(flex: 5, child: stack),
              ],
            )
          else ...<Widget>[title, const SizedBox(height: 32), stack],
        ],
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _CrumbLink(label: 'Home', onTap: () => context.go(RouteNames.homePath)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 15,
            color: AppColors.textMuted,
          ),
        ),
        _CrumbLink(label: 'Projects', onTap: () => navigateToProjects(context)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 15,
            color: AppColors.textMuted,
          ),
        ),
        Flexible(
          child: Text(
            project.name,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _CrumbLink extends StatefulWidget {
  const _CrumbLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_CrumbLink> createState() => _CrumbLinkState();
}

class _CrumbLinkState extends State<_CrumbLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: _hovered ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 9),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroStackCard extends StatelessWidget {
  const _HeroStackCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 200),
      child: SurfaceCard(
        accent: project.accent,
        padding: const EdgeInsets.all(24),
        glowOnHover: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MicroLabel('Technology stack'),
            const SizedBox(height: 16),
            TechBadgeList(
              project.stack,
              colors: <String, Color>{
                for (final String item in project.stack) item: project.accent,
              },
            ),
            const SizedBox(height: 22),
            const Divider(),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${project.features.length}',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Key features',
                        style: AppTypography.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${project.challenges.length}',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Problems solved',
                        style: AppTypography.textTheme.bodySmall,
                      ),
                    ],
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

class _OverviewBlock extends StatelessWidget {
  const _OverviewBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      id: 'overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionIntro(eyebrow: 'Overview', title: 'What this app does'),
          const SizedBox(height: 24),
          Reveal(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Text(
                project.overview,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.75,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesBlock extends StatelessWidget {
  const _FeaturesBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final int columns = context.gridColumns(mobile: 1, tablet: 2, desktop: 2);

    return SectionShell(
      id: 'features',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionIntro(eyebrow: 'Key features', title: 'What was built'),
          const SizedBox(height: 36),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: project.features.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 64,
            ),
            itemBuilder: (BuildContext context, int index) => Reveal(
              delay: Duration(milliseconds: 45 * (index % columns)),
              child: _FeatureRow(
                index: index,
                text: project.features[index],
                accent: project.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.index,
    required this.text,
    required this.accent,
  });

  final int index;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      accent: accent,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      borderRadius: 14,
      glowOnHover: false,
      child: Row(
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(Icons.check_rounded, size: 14, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryBlock extends StatelessWidget {
  const _GalleryBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      id: 'screenshots',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionIntro(
            eyebrow: 'Screenshots',
            title: 'The app on device',
            subtitle:
                'Drop real captures into the paths listed under each slot and they '
                'appear here automatically.',
          ),
          const SizedBox(height: 40),
          Reveal(child: ProjectGallery(project: project)),
        ],
      ),
    );
  }
}

class _DevelopmentBlock extends StatelessWidget {
  const _DevelopmentBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      id: 'development',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionIntro(
            eyebrow: 'Development',
            title: 'How it is built',
            subtitle: 'The technical decisions behind the screens.',
          ),
          const SizedBox(height: 40),
          for (int i = 0; i < project.aspects.length; i++)
            Reveal(
              delay: Duration(milliseconds: 70 * i),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _AspectCard(
                  aspect: project.aspects[i],
                  accent: project.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AspectCard extends StatelessWidget {
  const _AspectCard({required this.aspect, required this.accent});

  final ProjectAspect aspect;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      accent: accent,
      padding: const EdgeInsets.all(24),
      glowOnHover: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 3,
            height: 22,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[accent, accent.withValues(alpha: 0.2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  aspect.label,
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    fontFamily: AppTypography.displayFont,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 12),
                for (final String point in aspect.points)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            point,
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengesBlock extends StatelessWidget {
  const _ChallengesBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      id: 'challenges',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionIntro(
            eyebrow: 'Challenges & solutions',
            title: 'The parts that were not straightforward',
            subtitle: 'What broke, and what I changed to fix it.',
          ),
          const SizedBox(height: 40),
          for (int i = 0; i < project.challenges.length; i++)
            Reveal(
              delay: Duration(milliseconds: 80 * i),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _ChallengeCard(
                  index: i,
                  challenge: project.challenges[i],
                  accent: project.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.index,
    required this.challenge,
    required this.accent,
  });

  final int index;
  final ProjectChallenge challenge;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool stacked = context.isMobile;

    final Widget problem = _Panel(
      label: 'Challenge',
      labelColor: AppColors.danger,
      icon: Icons.report_problem_outlined,
      text: challenge.problem,
    );

    final Widget solution = _Panel(
      label: 'Solution',
      labelColor: AppColors.success,
      icon: Icons.lightbulb_outline_rounded,
      text: challenge.solution,
    );

    return SurfaceCard(
      accent: accent,
      padding: const EdgeInsets.all(24),
      glowOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: AppTypography.mono.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: accent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Problem ${index + 1}',
                style: AppTypography.textTheme.titleMedium?.copyWith(
                  fontFamily: AppTypography.displayFont,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (stacked) ...<Widget>[
            problem,
            const SizedBox(height: 14),
            solution,
          ] else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: problem),
                  const SizedBox(width: 14),
                  Expanded(child: solution),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.label,
    required this.labelColor,
    required this.icon,
    required this.text,
  });

  final String label;
  final Color labelColor;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: labelColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: labelColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 14, color: labelColor),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: AppTypography.textTheme.labelSmall?.copyWith(
                  color: labelColor,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: AppTypography.textTheme.bodyMedium?.copyWith(height: 1.65),
          ),
        ],
      ),
    );
  }
}

class _StackBlock extends StatelessWidget {
  const _StackBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      id: 'stack',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionIntro(eyebrow: 'Tech', title: 'Built with'),
          const SizedBox(height: 28),
          Reveal(
            child: TechBadgeList(
              project.stack,
              colors: <String, Color>{
                for (final String item in project.stack) item: project.accent,
              },
              spacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextProjectBlock extends StatelessWidget {
  const _NextProjectBlock({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      id: 'next-project',
      showDivider: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const MicroLabel('Next project'),
          const SizedBox(height: 20),
          Reveal(
            child: AppButton(
              label: project.name,
              icon: Icons.arrow_forward_rounded,
              variant: AppButtonVariant.outline,
              size: AppButtonSize.large,
              onPressed: () => context.go(project.route),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when `/projects/<id>` matches no known project.
class _UnknownProject extends StatelessWidget {
  const _UnknownProject({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 20),
            Text(
              'Project not found',
              style: AppTypography.textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'There is no project with the id "$projectId".',
              textAlign: TextAlign.center,
              style: AppTypography.textTheme.bodyMedium,
            ),
            const SizedBox(height: 26),
            AppButton(
              label: 'Back to all projects',
              icon: Icons.arrow_back_rounded,
              onPressed: () => context.go(RouteNames.homePath),
            ),
          ],
        ),
      ),
    );
  }
}

/// Jumps back to the projects section of the home page.
Future<void> navigateToProjects(BuildContext context) {
  return navigateToSection(context, SectionIds.projects);
}
