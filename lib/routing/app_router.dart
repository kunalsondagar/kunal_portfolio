import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/view/home_view.dart';
import '../features/not_found/view/not_found_view.dart';
import '../features/project/view/project_view.dart';
import '../features/shell/view/site_shell.dart';
import 'route_names.dart';

/// Application routes.
///
/// A [ShellRoute] wraps both pages so the navbar and footer are built once and
/// survive navigation, while each page owns its own scroll position.
///
/// [createAppRouter] is a factory so tests can build a fresh instance with a
/// custom start location; [appRouter] is the shared instance used at runtime.
GoRouter createAppRouter({String initialLocation = RouteNames.homePath}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            SiteShell(child: child),
        routes: <RouteBase>[
          GoRoute(
            path: RouteNames.homePath,
            name: RouteNames.home,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<void>(child: HomeView()),
          ),
          GoRoute(
            path: RouteNames.projectPath,
            name: RouteNames.project,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final String id = state.pathParameters['id'] ?? '';
              return NoTransitionPage<void>(child: ProjectView(projectId: id));
            },
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const NotFoundView(),
  );
}

final GoRouter appRouter = createAppRouter();
