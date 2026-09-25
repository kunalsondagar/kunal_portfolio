import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

/// The site's one card primitive.
///
/// A soft gradient fill, a hairline border and an optional accent glow on hover.
/// Everything that looks like a "box" on this site is this widget, which is
/// what keeps the surface treatment consistent.
class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.onTap,
    this.glowOnHover = true,
    this.accent,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  /// Adds a faint accent halo under the card while hovered. Off for dense,
  /// repetitive content such as skill chips.
  final bool glowOnHover;

  /// Tints the border and hover glow. Defaults to the blue accent.
  final Color? accent;

  final Gradient? gradient;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accent ?? AppColors.flutterBlue;
    final bool interactive = widget.onTap != null || widget.glowOnHover;

    final Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppGradients.card,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _hovered && interactive
              ? accent.withValues(alpha: 0.38)
              : AppColors.border,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          if (_hovered && widget.glowOnHover)
            BoxShadow(
              color: accent.withValues(alpha: 0.14),
              blurRadius: 34,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: widget.child,
    );

    if (widget.onTap == null) return content;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          splashColor: accent.withValues(alpha: 0.08),
          highlightColor: accent.withValues(alpha: 0.05),
          child: content,
        ),
      ),
    );
  }
}
