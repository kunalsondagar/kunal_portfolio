import 'package:flutter/material.dart';

import 'project_support.dart';

/// A portfolio project, rich enough to drive both the card on the home page and
/// the standalone detail route.
class Project {
  const Project({
    required this.id,
    required this.number,
    required this.name,
    required this.tagline,
    required this.category,
    required this.role,
    required this.platforms,
    required this.stack,
    required this.cardSummary,
    required this.overview,
    required this.features,
    required this.aspects,
    required this.challenges,
    required this.screenshots,
    required this.accent,
    this.featured = true,
  });

  /// URL segment, e.g. `ciya` for `/projects/ciya`.
  final String id;

  /// Display index, e.g. "01".
  final String number;

  final String name;
  final String tagline;
  final ProjectCategory category;

  /// What Kunal was responsible for.
  final String role;

  final List<String> platforms;
  final List<String> stack;

  /// Two lines max — this is the copy shown on the home page card.
  final String cardSummary;

  /// Long-form description for the detail page.
  final String overview;

  final List<String> features;

  /// Architecture / state management / APIs / Firebase / integrations.
  final List<ProjectAspect> aspects;

  final List<ProjectChallenge> challenges;

  final List<ProjectScreenshotSlot> screenshots;

  final Color accent;

  final bool featured;

  bool get isGame => category == ProjectCategory.game;

  String get categoryLabel => switch (category) {
    ProjectCategory.app => 'Mobile App',
    ProjectCategory.game => 'Game Project',
  };

  /// Route path for this project.
  String get route => '/projects/$id';

  /// Folder name used for the screenshot assets of this project.
  String get assetFolder => 'assets/images/projects/$id';
}
