import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/tech_badge.dart';
import '../../../data/models/project.dart';
import '../../../data/models/project_support.dart';

/// Large project card used on the home page.
///
/// Leads with the project's identity and stack, then a short "what it does"
/// line. The screenshots stay on the detail page, where there is room for them.
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, required this.onTap, super.key});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool compact = context.isMobile;

    return Semantics(
      button: true,
      label: '${project.name}. ${project.tagline}. Open project details.',
      child: SurfaceCard(
        onTap: onTap,
        accent: project.accent,
        padding: EdgeInsets.zero,
        glowOnHover: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _CardHeader(project: project, compact: compact),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, compact ? 22 : 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    project.tagline,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      project.cardSummary,
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TechBadgeList(
                    project.stack,
                    dense: true,
                    colors: <String, Color>{
                      for (final String t in project.stack) t: project.accent,
                    },
                  ),
                  const SizedBox(height: 20),
                  _ViewProjectLink(accent: project.accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.project, required this.compact});

  final Project project;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
        gradient: LinearGradient(
          colors: <Color>[
            project.accent.withValues(alpha: 0.16),
            project.accent.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            project.number,
            style: AppTypography.mono.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: project.accent,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  project.name,
                  style: AppTypography.textTheme.headlineSmall?.copyWith(
                    fontSize: compact ? 21 : 23,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    _CategoryTag(project: project),
                    for (final String platform in project.platforms)
                      TechBadge(
                        platform,
                        dense: true,
                        filled: true,
                        color: AppColors.textMuted,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final IconData icon = project.isGame
        ? Icons.sports_esports_outlined
        : Icons.phone_iphone_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: project.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: project.accent.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 12, color: project.accent),
          const SizedBox(width: 6),
          Text(
            project.categoryLabel,
            style: AppTypography.textTheme.labelMedium?.copyWith(
              fontSize: 11.5,
              color: project.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewProjectLink extends StatelessWidget {
  const _ViewProjectLink({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'View project',
          style: AppTypography.textTheme.labelLarge?.copyWith(
            fontSize: 14,
            color: accent,
          ),
        ),
        const SizedBox(width: 7),
        Icon(Icons.arrow_forward_rounded, size: 16, color: accent),
      ],
    );
  }
}

/// The phone-framed screenshot gallery on a project detail page.
class ProjectGallery extends StatelessWidget {
  const ProjectGallery({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final int columns = context.gridColumns(
      mobile: 2,
      tablet: 3,
      desktop: project.screenshots.length >= 4 ? 4 : 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: project.screenshots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 26,
        crossAxisSpacing: 18,
        // A phone is ~2.17:1 tall; the extra room leaves space for the caption.
        childAspectRatio: 0.44,
      ),
      itemBuilder: (BuildContext context, int index) {
        final ProjectScreenshotSlot slot = project.screenshots[index];
        return ProjectScreenshotTile(
          assetPath: slot.assetPath,
          caption: slot.caption,
          accent: project.accent,
        );
      },
    );
  }
}

/// A single screenshot in a gallery, with its caption.
class ProjectScreenshotTile extends StatelessWidget {
  const ProjectScreenshotTile({
    required this.assetPath,
    required this.caption,
    required this.accent,
    super.key,
  });

  final String assetPath;
  final String caption;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: caption,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.border),
                gradient: LinearGradient(
                  colors: <Color>[
                    accent.withValues(alpha: 0.10),
                    AppColors.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      const ColoredBox(color: Color(0xFF05070B)),
                      // Hidden semantics: the caption below already describes it.
                      Image.asset(
                        assetPath,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                        errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stack,
                        ) => const _MissingShot(),
                        frameBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              int? frame,
                              bool wasSynchronouslyLoaded,
                            ) {
                              if (wasSynchronouslyLoaded) return child;
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(milliseconds: 300),
                                child: child,
                              );
                            },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MissingShot extends StatelessWidget {
  const _MissingShot();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.image_outlined,
            size: 22,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 10),
          Text(
            'Add screenshot',
            style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

/// Decorative gradient used behind the project detail header.
class ProjectHeaderGlow extends StatelessWidget {
  const ProjectHeaderGlow({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -260,
      right: -180,
      child: IgnorePointer(
        child: Container(
          width: 640,
          height: 640,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                accent.withValues(alpha: 0.20),
                accent.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The accent rule above a project title.
class ProjectAccentBar extends StatelessWidget {
  const ProjectAccentBar({required this.accent, super.key});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: LinearGradient(
          colors: <Color>[accent, AppGradients.accent.last],
        ),
      ),
    );
  }
}
