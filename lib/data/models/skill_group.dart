import 'package:flutter/material.dart';

/// A titled group of related skills, rendered as one card in the Skills grid.
class SkillGroup {
  const SkillGroup({
    required this.title,
    required this.icon,
    required this.blurb,
    required this.skills,
    required this.accent,
    this.highlighted = const <String>[],
  });

  final String title;
  final IconData icon;

  /// One line explaining what this group is used for.
  final String blurb;

  final List<String> skills;

  /// Card accent colour.
  final Color accent;

  /// Subset of [skills] rendered as filled chips to mark core strengths.
  final List<String> highlighted;
}
