/// A qualification entry.
class EducationItem {
  const EducationItem({
    required this.degree,
    required this.field,
    required this.institution,
    required this.university,
    required this.period,
    required this.highlights,
  });

  final String degree;
  final String field;
  final String institution;
  final String university;
  final String period;

  /// Metric-style facts such as "CGPA 7.71" or "0 backlogs".
  final List<EducationHighlight> highlights;
}

class EducationHighlight {
  const EducationHighlight({required this.label, required this.value});

  final String label;
  final String value;
}
