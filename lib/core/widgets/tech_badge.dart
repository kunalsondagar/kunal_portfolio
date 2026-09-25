import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

/// Pill used for technology tags, filters and platform labels.
class TechBadge extends StatelessWidget {
  const TechBadge(
    this.label, {
    super.key,
    this.icon,
    this.color,
    this.filled = false,
    this.dense = false,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  /// Filled variant for the hero strip, where the badge sits on the page
  /// background rather than inside a card.
  final bool filled;

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final Color accent = color ?? AppColors.flutterBlue;
    final TextStyle? base = Theme.of(context).textTheme.labelMedium;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 9 : 12,
        vertical: dense ? 4.5 : 7,
      ),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.textPrimary.withValues(alpha: 0.05)
            : accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: filled ? AppColors.border : accent.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: dense ? 12 : 14, color: accent),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: base?.copyWith(
              color: filled ? AppColors.textSecondary : accent,
              fontSize: dense ? 11.5 : 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of [TechBadge]s that wraps, used for every project's tech stack.
class TechBadgeList extends StatelessWidget {
  const TechBadgeList(
    this.items, {
    super.key,
    this.colors,
    this.dense = false,
    this.spacing = 8,
    this.alignment = WrapAlignment.start,
  });

  final List<String> items;

  /// Optional per-item colours, e.g. to tint Firebase orange and Dart blue.
  final Map<String, Color>? colors;

  final bool dense;
  final double spacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: alignment,
      children: <Widget>[
        for (final String item in items)
          TechBadge(
            item,
            dense: dense,
            color: colors?[item] ?? AppColors.flutterBlue,
          ),
      ],
    );
  }
}

/// Numbered marker used by the process timeline (`01`, `02`, ...).
class StepNumber extends StatelessWidget {
  const StepNumber(this.value, {super.key, this.active = true});

  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textPrimary.withValues(alpha: 0.04),
        border: Border.all(
          color: active
              ? AppColors.flutterBlue.withValues(alpha: 0.5)
              : AppColors.border,
        ),
        gradient: active
            ? const LinearGradient(
                colors: <Color>[Color(0x1F42A5F5), Color(0x00111A28)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: active ? AppColors.flutterBlue : AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Thin gradient rule used to close a visual block.
class AccentRule extends StatelessWidget {
  const AccentRule({super.key, this.width = 56, this.height = 3});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
