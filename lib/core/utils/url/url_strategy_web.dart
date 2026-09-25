import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Uses clean path URLs (`/projects/ciya`) instead of Flutter's default hash
/// form (`/#/projects/ciya`).
///
/// Requires the hosting platform to rewrite unknown paths back to `index.html`.
void configureUrlStrategy() => usePathUrlStrategy();
