/// One role on the experience timeline.
class ExperienceEntry {
  const ExperienceEntry({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.summary,
    required this.responsibilities,
    required this.stack,
    this.isCurrent = false,
  });

  final String company;
  final String role;

  /// Already formatted for display, e.g. "Jun 2026 — Present".
  final String period;

  final String location;

  /// One-line framing of the role, shown under the company name.
  final String summary;

  final List<String> responsibilities;
  final List<String> stack;

  /// Renders the "Present" pill and keeps the timeline dot accent-coloured.
  final bool isCurrent;
}
