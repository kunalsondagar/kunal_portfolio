import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/brand_icons.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../data/models/nav_item.dart';
import '../../../data/models/profile.dart';
import '../../../data/models/social_link.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../routing/section_navigation.dart';

/// Site footer: identity, quick navigation, contact links and social icons.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const int _currentYear = 2026;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final Profile profile = portfolio.profile;
    final List<NavItem> items = portfolio.navItems;
    final bool stacked = context.isMobile;

    final Widget identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          profile.name,
          style: AppTypography.textTheme.titleLarge?.copyWith(
            fontFamily: AppTypography.displayFont,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          profile.role,
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.flutterBlue,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Text(profile.intro, style: AppTypography.textTheme.bodySmall),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final SocialLink link in portfolio.socialLinks)
              _SocialButton(link: link),
          ],
        ),
      ],
    );

    final Widget navigation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const MicroLabel('Navigate'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: <Widget>[
            for (final NavItem item in items)
              _FooterLink(
                label: item.label,
                onTap: () => navigateToSection(context, item.sectionId),
              ),
          ],
        ),
      ],
    );

    final Widget contact = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const MicroLabel('Get in touch'),
        const SizedBox(height: 16),
        for (final SocialLink link in portfolio.socialLinks)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FooterLink(
              label: link.value,
              onTap: () => ExternalLink.open(link.uri),
            ),
          ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0x66070A11),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(
        top: stacked ? 44 : 56,
        bottom: stacked ? 28 : 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.contentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (stacked) ...<Widget>[
                  identity,
                  const SizedBox(height: 40),
                  navigation,
                  const SizedBox(height: 36),
                  contact,
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 5, child: identity),
                      const SizedBox(width: 32),
                      Expanded(flex: 3, child: navigation),
                      const SizedBox(width: 32),
                      Expanded(flex: 4, child: contact),
                    ],
                  ),
                const SizedBox(height: 40),
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: AppGradients.divider),
                  child: SizedBox(height: 1, width: double.infinity),
                ),
                const SizedBox(height: 22),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '© $_currentYear ${profile.name}. All rights reserved.',
                        style: AppTypography.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      'Built with Flutter',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 160),
          style:
              AppTypography.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: _hovered ? AppColors.textPrimary : AppColors.textMuted,
              ) ??
              const TextStyle(),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.link});

  final SocialLink link;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${link.label}: ${link.value}',
      child: Tooltip(
        message: link.label,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () => ExternalLink.open(link.uri),
            borderRadius: BorderRadius.circular(11),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppColors.border),
              ),
              child: FaIcon(
                brandIconFor(link.platform),
                size: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
