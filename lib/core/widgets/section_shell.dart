import 'package:flutter/material.dart';

import '../reveal/reveal.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';
import '../utils/responsive.dart';

/// The small accent label that sits above every section heading.
class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow(this.eyebrow, {super.key});

  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 22,
          height: 2,
          decoration: const BoxDecoration(gradient: AppGradients.primary),
        ),
        const SizedBox(width: 10),
        Text(
          eyebrow.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: AppColors.flutterBlue),
        ),
      ],
    );
  }
}

/// Consistent heading block for every section: small accent eyebrow, large
/// title, optional supporting copy.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.eyebrow,
    required this.title,
    super.key,
    this.subtitle,
    this.alignment = CrossAxisAlignment.start,
    this.centered = false,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final double titleSize = context.responsiveValue(
      mobile: 28.0,
      tablet: 34.0,
      desktop: 40.0,
    );

    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : alignment,
      children: <Widget>[
        SectionEyebrow(eyebrow),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            title,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: text.headlineLarge?.copyWith(
              fontSize: titleSize,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 660),
            child: Text(
              subtitle!,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: text.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }
}

/// Wraps a section's content in the shared page rhythm: a max-width centred
/// column, responsive vertical padding and a hairline divider.
class SectionShell extends StatelessWidget {
  const SectionShell({
    required this.id,
    required this.child,
    super.key,
    this.padding = EdgeInsets.zero,
    this.showDivider = true,
    this.background,
  });

  /// Also used as the scroll anchor id, so it must match the nav item's target.
  final String id;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool showDivider;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.only(
        top: context.verticalSectionGap * 0.62,
        bottom: context.verticalSectionGap * 0.62,
      ),
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.contentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Padding(padding: padding, child: child),
            ),
          ),
          if (showDivider) ...<Widget>[
            const SizedBox(height: 44),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: AppGradients.divider),
                child: SizedBox(height: 1, width: double.infinity),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Vertical rhythm between sections, growing with the viewport.
extension SectionSpacing on BuildContext {
  double get verticalSectionGap {
    final double width = screenWidth;
    if (width < 700) return 74;
    if (width < 1024) return 96;
    if (width < 1400) return 120;
    return 136;
  }
}

/// Small uppercase monospace-ish label used inside cards.
class MicroLabel extends StatelessWidget {
  const MicroLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.mono.copyWith(
        fontSize: 11.5,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textMuted,
      ),
    );
  }
}

/// Convenience wrapper: section header followed by its body, with consistent
/// spacing and a reveal animation.
class SectionIntro extends StatelessWidget {
  const SectionIntro({
    required this.eyebrow,
    required this.title,
    super.key,
    this.subtitle,
    this.centered = false,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: SectionHeader(
        eyebrow: eyebrow,
        title: title,
        subtitle: subtitle,
        centered: centered,
      ),
    );
  }
}
