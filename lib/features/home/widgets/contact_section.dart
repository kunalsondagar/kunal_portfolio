import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/brand_icons.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/models/profile.dart';
import '../../../data/models/social_link.dart';
import '../../../data/sources/portfolio_content.dart';
import '../../../providers/contact_form_provider.dart';
import '../../../providers/portfolio_provider.dart';

/// Contact details on one side, the message form on the other.
class ContactSection extends StatelessWidget {
  const ContactSection({required this.sectionKey, super.key});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final PortfolioProvider portfolio = context.watch<PortfolioProvider>();
    final Profile profile = portfolio.profile;
    final bool sideBySide = context.isDesktop;

    final Widget details = _ContactDetails(
      heading: PortfolioContent.contactHeading,
      subtitle: PortfolioContent.contactSubtitle,
      profile: profile,
      links: portfolio.socialLinks,
    );
    final Widget form = const ContactForm();

    return SectionShell(
      id: SectionIds.contact,
      showDivider: false,
      child: KeyedSubtree(
        key: sectionKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (sideBySide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 5, child: details),
                  const SizedBox(width: 48),
                  Expanded(flex: 6, child: form),
                ],
              )
            else ...<Widget>[details, const SizedBox(height: 40), form],
          ],
        ),
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails({
    required this.heading,
    required this.subtitle,
    required this.profile,
    required this.links,
  });

  final String heading;
  final String subtitle;
  final Profile profile;
  final List<SocialLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Reveal(child: const SectionEyebrow('Contact')),
        const SizedBox(height: 18),
        Reveal(
          child: Text(
            heading,
            style: AppTypography.textTheme.headlineLarge?.copyWith(
              fontSize: context.responsiveValue(mobile: 30.0, desktop: 40.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          child: Text(
            subtitle,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(profile.name, style: AppTypography.textTheme.titleMedium),
              const SizedBox(height: 3),
              Text(
                profile.role,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.flutterBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        for (int i = 0; i < links.length; i++)
          Reveal(
            delay: Duration(milliseconds: 60 * i),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ContactRow(link: links[i]),
            ),
          ),
        const SizedBox(height: 12),
        Reveal(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.place_outlined,
                size: 15,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  profile.location,
                  style: AppTypography.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatefulWidget {
  const _ContactRow({required this.link});

  final SocialLink link;

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final SocialLink link = widget.link;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        label: '${link.label}: ${link.value}',
        child: GestureDetector(
          onTap: () => ExternalLink.open(link.uri),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.textPrimary.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered ? AppColors.borderStrong : AppColors.border,
              ),
            ),
            child: Row(
              children: <Widget>[
                FaIcon(
                  brandIconFor(link.platform),
                  size: 14,
                  color: _hovered ? AppColors.flutterBlue : AppColors.textMuted,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    link.value,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: _hovered
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.north_east_rounded,
                  size: 14,
                  color: _hovered
                      ? AppColors.flutterBlue
                      : AppColors.textMuted.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The message form. All state lives in [ContactFormProvider].
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _subject = TextEditingController();
  late final TextEditingController _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final ContactFormProvider form = context.read<ContactFormProvider>();
    FocusScope.of(context).unfocus();
    form.submit();
  }

  @override
  Widget build(BuildContext context) {
    final ContactFormProvider form = context.watch<ContactFormProvider>();

    return Reveal(
      child: SurfaceCard(
        padding: const EdgeInsets.all(28),
        glowOnHover: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Send a message',
              style: AppTypography.textTheme.titleLarge?.copyWith(fontSize: 19),
            ),
            const SizedBox(height: 6),
            Text(
              'I usually reply within a day or two.',
              style: AppTypography.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            _Field(
              controller: _name,
              label: 'Name',
              hint: 'Your name',
              icon: Icons.person_outline_rounded,
              errorText: form.errorFor('name'),
              textCapitalization: TextCapitalization.words,
              onChanged: form.nameChanged,
              onSubmitted: (_) => form.markTouched('name'),
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _email,
              label: 'Email',
              hint: 'you@company.com',
              icon: Icons.alternate_email_rounded,
              errorText: form.errorFor('email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: form.emailChanged,
              onSubmitted: (_) => form.markTouched('email'),
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _subject,
              label: 'Subject',
              hint: 'Flutter developer role',
              icon: Icons.title_rounded,
              errorText: form.errorFor('subject'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: form.subjectChanged,
              onSubmitted: (_) => form.markTouched('subject'),
            ),
            const SizedBox(height: 16),
            _Field(
              controller: _message,
              label: 'Message',
              hint: 'Tell me about the project',
              icon: Icons.chat_bubble_outline_rounded,
              errorText: form.errorFor('message'),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onChanged: form.messageChanged,
              onSubmitted: (_) => form.markTouched('message'),
            ),
            const SizedBox(height: 22),
            if (form.statusMessage != null) ...<Widget>[
              _StatusBanner(
                message: form.statusMessage!,
                isSuccess: form.isSuccess,
                onDismiss: form.dismissStatus,
              ),
              const SizedBox(height: 18),
            ],
            AppButton(
              label: form.isSubmitting ? 'Sending...' : 'Send Message',
              icon: form.isSubmitting
                  ? Icons.hourglass_top_rounded
                  : Icons.send_rounded,
              size: AppButtonSize.large,
              expand: true,
              onPressed: form.isSubmitting ? null : _handleSubmit,
            ),
            if (!form.isConfigured) ...<Widget>[
              const SizedBox(height: 14),
              _ConfigNotice(email: PortfolioContent.emailAddress),
            ],
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      autovalidateMode: AutovalidateMode.disabled,
      style: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: Icon(
          icon,
          size: 17,
          color: errorText != null ? AppColors.danger : AppColors.textMuted,
        ),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.message,
    required this.isSuccess,
    required this.onDismiss,
  });

  final String message;
  final bool isSuccess;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final Color accent = isSuccess ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            isSuccess
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            size: 17,
            color: accent,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              message,
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, size: 15),
            color: AppColors.textMuted,
            visualDensity: VisualDensity.compact,
            tooltip: 'Dismiss',
          ),
        ],
      ),
    );
  }
}

/// Shown when the Web3Forms key has not been filled in, so a half-configured
/// deploy explains itself instead of looking broken.
class _ConfigNotice extends StatelessWidget {
  const _ConfigNotice({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.26)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'Form delivery is not configured yet. Add your Web3Forms key in ',
                  ),
                  TextSpan(
                    text: 'AppConfig',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ', or email '),
                  TextSpan(
                    text: email,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' directly.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
