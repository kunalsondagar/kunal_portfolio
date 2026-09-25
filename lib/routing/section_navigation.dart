import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/sources/portfolio_content.dart';
import '../../providers/navigation_provider.dart';
import 'route_names.dart';

/// Navigates to a home-page section, working from any route.
///
/// On the home page this is a smooth scroll. From a project page it first pushes
/// the home route and then scrolls, retrying across a few frames because the
/// target section only exists once that page has been laid out.
Future<void> navigateToSection(BuildContext context, String sectionId) async {
  final NavigationProvider navigation = context.read<NavigationProvider>();
  final GoRouterState state = GoRouterState.of(context);
  final bool isHome = state.matchedLocation == RouteNames.homePath;

  if (!isHome) {
    context.go(RouteNames.homePath);
  }

  // A couple of frames is not always enough on a cold route, so retry briefly.
  for (int attempt = 0; attempt < 8; attempt++) {
    await WidgetsBinding.instance.endOfFrame;
    if (!context.mounted) return;
    if (await navigation.scrollToSection(sectionId)) return;
  }
}

/// Scrolls to the top of the home page, or goes there first from another route.
Future<void> navigateToTop(BuildContext context) {
  return navigateToSection(context, SectionIds.home);
}
