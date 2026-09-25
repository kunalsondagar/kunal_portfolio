import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

/// Draws device chrome around a screenshot.
///
/// The frame is decorative chrome only — it is hidden from screen readers
/// because the screenshot itself is described by the caption.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    required this.child,
    super.key,
    this.aspectRatio = 9 / 19.5,
    this.radius = 30,
    this.showIsland = true,
  });

  final Widget child;
  final double aspectRatio;
  final double radius;
  final bool showIsland;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.borderStrong),
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF1A2231), Color(0xFF0A0E16)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius - 6),
            child: ColoredBox(
              color: const Color(0xFF05070B),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  child,
                  if (showIsland)
                    Align(
                      alignment: const Alignment(0, -0.93),
                      child: Container(
                        width: 74,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A screenshot slot for a project.
///
/// Drop the real capture at [assetPath] (declared in `pubspec.yaml` under
/// `assets/images/`) and it appears automatically. Until then the widget shows
/// a clearly-labelled placeholder rather than inventing an image, so nothing on
/// the site is ever faked.
class ProjectScreenshot extends StatelessWidget {
  const ProjectScreenshot({
    required this.assetPath,
    required this.caption,
    super.key,
    this.placeholderIcon = Icons.phone_iphone_rounded,
  });

  /// Path relative to the Flutter asset root, e.g.
  /// `assets/images/projects/ciya/01-booking.png`.
  final String assetPath;

  /// Short human description, also used as the accessible label.
  final String caption;

  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PhoneFrame(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const _ScreenshotPlaceholder(),
              // Sits on top of the placeholder; renders nothing if the asset is
              // missing, so the slot is never blank.
              Image.asset(
                assetPath,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stack,
                ) => const SizedBox.shrink(),
                frameBuilder:
                    (
                      BuildContext context,
                      Widget child,
                      int? frame,
                      bool wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 320),
                        child: child,
                      );
                    },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                caption,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScreenshotPlaceholder extends StatelessWidget {
  const _ScreenshotPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF111827), Color(0xFF080B11)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.image_outlined,
                size: 26,
                color: AppColors.textMuted.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 12),
              Text(
                'Add screenshot',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textMuted, letterSpacing: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
