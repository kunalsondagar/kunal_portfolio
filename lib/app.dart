import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/constants/app_config.dart';
import 'core/reveal/reveal_coordinator.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/portfolio_repository.dart';
import 'data/repositories/static_portfolio_repository.dart';
import 'data/services/contact_service.dart';
import 'providers/contact_form_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/portfolio_provider.dart';
import 'routing/app_router.dart';

/// Composition root: every dependency is constructed here and injected
/// downwards. Nothing below this file reaches for a singleton.
///
/// The repository, contact service and router are all overridable so tests can
/// substitute fakes instead of hitting the real content or the network.
class PortfolioApp extends StatefulWidget {
  const PortfolioApp({
    super.key,
    this.repository,
    this.contactService,
    this.router,
  });

  final PortfolioRepository? repository;

  final ContactService? contactService;

  final GoRouter? router;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final PortfolioRepository _repository =
      widget.repository ?? const StaticPortfolioRepository();

  late final ContactService _contactService =
      widget.contactService ?? ContactService();

  late final bool _ownsRouter = widget.router == null;
  late final GoRouter _router = widget.router ?? appRouter;

  @override
  void dispose() {
    if (_ownsRouter) _router.dispose();
    _contactService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<PortfolioRepository>.value(value: _repository),
        ChangeNotifierProvider<PortfolioProvider>(
          create: (_) => PortfolioProvider(_repository),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider<RevealCoordinator>(
          create: (_) => RevealCoordinator(),
        ),
        ChangeNotifierProvider<ContactFormProvider>(
          create: (_) => ContactFormProvider(
            service: _contactService,
            fromName: _repository.profile.name,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.siteTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: _router,
        builder: (BuildContext context, Widget? child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.systemOverlay,
            child: MediaQuery.withClampedTextScaling(
              // Keeps large display type readable without letting a very large
              // system font size break the fixed-height device frames.
              minScaleFactor: 0.85,
              maxScaleFactor: 1.25,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
