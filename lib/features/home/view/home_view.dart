import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/reveal/reveal_coordinator.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../providers/navigation_provider.dart';
import '../../../data/sources/portfolio_content.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/education_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/process_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/resume_cta_section.dart';
import '../widgets/services_section.dart';
import '../widgets/skills_section.dart';

/// The single-page portfolio.
///
/// Owns the page's [ScrollController] and hands it to the two scroll observers
/// (reveal animations and the navbar's active-section highlight). Each section
/// takes a key from [NavigationProvider] so it can be scrolled to by id.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  NavigationProvider? _navigation;
  RevealCoordinator? _reveals;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final NavigationProvider navigation = context.read<NavigationProvider>();
    final RevealCoordinator reveals = context.read<RevealCoordinator>();
    if (identical(navigation, _navigation) && identical(reveals, _reveals)) {
      return;
    }

    _navigation?.detach();
    _navigation = navigation;
    _reveals = reveals;
    navigation.attach(_scrollController);
    reveals.attach(_scrollController);
  }

  @override
  void dispose() {
    _navigation?.detach();
    _reveals?.detach();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navigation = context.read<NavigationProvider>();
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        // Lets the on-screen keyboard push the contact form into view on phones.
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            HeroSection(sectionKey: navigation.keyFor(SectionIds.home)),
            AboutSection(sectionKey: navigation.keyFor(SectionIds.about)),
            SkillsSection(sectionKey: navigation.keyFor(SectionIds.skills)),
            ExperienceSection(
              sectionKey: navigation.keyFor(SectionIds.experience),
            ),
            ProjectsSection(sectionKey: navigation.keyFor(SectionIds.projects)),
            ServicesSection(sectionKey: navigation.keyFor(SectionIds.services)),
            ProcessSection(sectionKey: navigation.keyFor(SectionIds.process)),
            EducationSection(
              sectionKey: navigation.keyFor(SectionIds.education),
            ),
            ResumeCtaSection(sectionKey: navigation.keyFor(SectionIds.resume)),
            ContactSection(sectionKey: navigation.keyFor(SectionIds.contact)),
            SizedBox(height: context.verticalSectionGap * 0.5),
          ],
        ),
      ),
    );
  }
}
