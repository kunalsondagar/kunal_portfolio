import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

enum AppButtonVariant { primary, outline, ghost }

enum AppButtonSize { small, medium, large }

/// The site's button.
///
/// `primary` is a gradient fill, `outline` is a hairline stroke and `ghost` is
/// a bare hover target — used for icon buttons and the footer links.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;

  /// Stretches to the available width (mobile CTAs, form submit).
  final bool expand;

  bool get _enabled => onPressed != null;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  ({
    double height,
    double hPad,
    double fontSize,
    double iconSize,
    double radius,
  })
  get _metrics {
    return switch (widget.size) {
      AppButtonSize.small => (
        height: 38,
        hPad: 16,
        fontSize: 13.5,
        iconSize: 16,
        radius: 10,
      ),
      AppButtonSize.medium => (
        height: 48,
        hPad: 24,
        fontSize: 15,
        iconSize: 18,
        radius: 12,
      ),
      AppButtonSize.large => (
        height: 56,
        hPad: 30,
        fontSize: 16,
        iconSize: 20,
        radius: 14,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final m = _metrics;
    final bool enabled = widget._enabled;
    final bool filled = widget.variant == AppButtonVariant.primary;

    final Color foreground = switch (widget.variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.outline =>
        _hovered && enabled ? AppColors.textPrimary : AppColors.textSecondary,
      AppButtonVariant.ghost =>
        _hovered && enabled ? AppColors.textPrimary : AppColors.textMuted,
    };

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Semantics(
          button: true,
          enabled: enabled,
          label: widget.label,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: m.height,
              width: widget.expand ? double.infinity : null,
              padding: EdgeInsets.symmetric(
                horizontal: widget.expand ? m.hPad : m.hPad,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: filled
                    ? (enabled && _hovered
                          ? const LinearGradient(
                              colors: <Color>[
                                Color(0xFF5AB1FF),
                                Color(0xFF8E6BFF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : AppGradients.primary)
                    : null,
                color: switch (widget.variant) {
                  AppButtonVariant.outline =>
                    _hovered && enabled
                        ? AppColors.textPrimary.withValues(alpha: 0.05)
                        : Colors.transparent,
                  AppButtonVariant.ghost =>
                    _hovered && enabled
                        ? AppColors.textPrimary.withValues(alpha: 0.05)
                        : Colors.transparent,
                  AppButtonVariant.primary => null,
                },
                borderRadius: BorderRadius.circular(m.radius),
                border: switch (widget.variant) {
                  AppButtonVariant.outline => Border.all(
                    color: _hovered && enabled
                        ? AppColors.borderStrong
                        : AppColors.border,
                  ),
                  _ => null,
                },
                boxShadow: filled && enabled && _hovered
                    ? <BoxShadow>[
                        BoxShadow(
                          color: AppColors.flutterBlue.withValues(alpha: 0.32),
                          blurRadius: 26,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: widget.expand
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (widget.icon != null) ...<Widget>[
                    Icon(widget.icon, size: m.iconSize, color: foreground),
                    const SizedBox(width: 9),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: foreground, fontSize: m.fontSize),
                    ),
                  ),
                  if (widget.trailingIcon != null) ...<Widget>[
                    const SizedBox(width: 9),
                    Icon(
                      widget.trailingIcon,
                      size: m.iconSize,
                      color: foreground,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
