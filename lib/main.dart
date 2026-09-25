import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/utils/url/url_strategy_stub.dart'
    if (dart.library.js_interop) 'core/utils/url/url_strategy_web.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Clean browser URLs: /projects/ciya rather than /#/projects/ciya.
  configureUrlStrategy();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF07090F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const PortfolioApp());
}
