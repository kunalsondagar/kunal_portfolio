/// Named routes, so navigation never depends on hand-written path strings.
abstract final class RouteNames {
  static const String home = 'home';
  static const String project = 'project';
  static const String notFound = 'notFound';

  static const String homePath = '/';
  static const String projectPath = '/projects/:id';

  static String projectPathFor(String id) => '/projects/$id';
}
