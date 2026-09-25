/// One step of the working process shown as a vertical timeline.
class ProcessStep {
  const ProcessStep({
    required this.number,
    required this.title,
    required this.description,
    required this.points,
  });

  final String number;
  final String title;
  final String description;
  final List<String> points;
}
