import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../routing/route_names.dart';

/// Shown for any unknown route.
class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SectionShell(
          id: 'not-found',
          showDivider: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppGradients.textMask(
                child: Text(
                  '404',
                  style: AppTypography.textTheme.displayLarge?.copyWith(
                    fontSize: 96,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'This page does not exist',
                style: AppTypography.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Text(
                  'The link may be out of date, or the page may have moved. '
                  'Everything else is still where you left it.',
                  style: AppTypography.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 30),
              AppButton(
                label: 'Back to home',
                icon: Icons.arrow_back_rounded,
                onPressed: () => context.go(RouteNames.homePath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
