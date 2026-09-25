import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../routing/section_navigation.dart';

/// Closing pitch: the resume, and three reasons to keep reading.
class ResumeCtaSection extends StatelessWidget {
  const ResumeCtaSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final List<String> highlights = portfolio.resumeHighlights;
    final bool sideBySide = context.isDesktop;

    void download() => ExternalLink.download(
      AppConfig.resumePath,
      fileName: AppConfig.resumeFileName,
    );

    return SectionShell(
      id: SectionIds.resume,
      child: KeyedSubtree(
        key: sectionKey,
        child: Reveal(
          child: Container(
            padding: EdgeInsets.all(
              context.responsiveValue(mobile: 28.0, desktop: 52.0),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFF121926), Color(0xFF0A0D15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                // Accent wash in the corner.
                Positioned(
                  top: -120,
                  right: -90,
                  child: IgnorePointer(
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            AppColors.flutterBlue.withValues(alpha: 0.18),
                            AppColors.flutterBlue.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (sideBySide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: _copy(highlights)),
                          const SizedBox(width: 40),
                          SizedBox(
                            width: 260,
                            child: _actions(context, download),
                          ),
                        ],
                      )
                    else ...<Widget>[
                      _copy(highlights),
                      const SizedBox(height: 28),
                      _actions(context, download),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _copy(List<String> highlights) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const MicroLabel('Resume'),
        const SizedBox(height: 14),
        Text(
          'Want to know more about my experience?',
          style: AppTypography.textTheme.headlineMedium?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 20),
        for (final String item in highlights)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                  color: AppColors.success,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    item,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _actions(BuildContext context, VoidCallback download) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppButton(
          label: 'Download Resume',
          icon: Icons.download_rounded,
          size: AppButtonSize.large,
          expand: true,
          onPressed: download,
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Get in touch',
          icon: Icons.mail_outline_rounded,
          variant: AppButtonVariant.outline,
          size: AppButtonSize.large,
          expand: true,
          onPressed: () => navigateToSection(context, SectionIds.contact),
        ),
      ],
    );
  }
}
