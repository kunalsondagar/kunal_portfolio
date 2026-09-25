/// A problem that came up during development and how it was resolved.
///
/// Recruiters read this section more than any other on a project page, so it is
/// a first-class model rather than a free-text paragraph.
class ProjectChallenge {
  const ProjectChallenge({required this.problem, required this.solution});

  final String problem;
  final String solution;
}

/// One screenshot slot. [assetPath] points at the real capture once it has been
/// added to `assets/images/projects/`.
class ProjectScreenshotSlot {
  const ProjectScreenshotSlot({required this.assetPath, required this.caption});

  final String assetPath;
  final String caption;
}

/// How a project is built — a labelled group of technical notes.
class ProjectAspect {
  const ProjectAspect({required this.label, required this.points});

  final String label;
  final List<String> points;
}

enum ProjectCategory { app, game }
