import 'package:flutter/material.dart';

/// A profile-level stat shown in the hero (e.g. "2+ Years Experience").
class StatItem {
  const StatItem({required this.value, required this.label, this.icon});

  final String value;
  final String label;
  final IconData? icon;
}

/// Who Kunal is, summarised. Lives in the data layer so copy edits never touch
/// widgets.
class Profile {
  const Profile({
    required this.name,
    required this.role,
    required this.headline,
    required this.intro,
    required this.aboutParagraphs,
    required this.location,
    required this.experienceYears,
    required this.specialization,
    required this.educationLine,
    required this.heroBadges,
    required this.heroStats,
    required this.focusAreas,
  });

  final String name;
  final String role;

  /// One-line pitch shown under the name in the hero.
  final String headline;

  /// Single-sentence version of the About intro.
  final String intro;

  /// Full About copy.
  final List<String> aboutParagraphs;

  final String location;
  final String experienceYears;
  final String specialization;
  final String educationLine;

  /// Tech pills in the hero.
  final List<String> heroBadges;

  final List<StatItem> heroStats;

  /// Short "what I care about" chips in the About section.
  final List<String> focusAreas;

  /// Two-letter monogram used by the hero avatar.
  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
