import 'package:flutter/foundation.dart';

import '../core/constants/app_config.dart';
import '../data/models/education_item.dart';
import '../data/models/experience_entry.dart';
import '../data/models/nav_item.dart';
import '../data/models/process_step.dart';
import '../data/models/project.dart';
import '../data/models/profile.dart';
import '../data/models/profile_fact.dart';
import '../data/models/service_item.dart';
import '../data/models/skill_group.dart';
import '../data/models/social_link.dart';
import '../data/repositories/portfolio_repository.dart';

/// Read-only view of the portfolio content for the widget layer.
///
/// Wraps [PortfolioRepository] so widgets never reach into the data source
/// directly. All content is available synchronously, so there is no loading
/// state to expose.
class PortfolioProvider extends ChangeNotifier {
  PortfolioProvider(this._repository);

  final PortfolioRepository _repository;

  PortfolioRepository get repository => _repository;

  Profile get profile => _repository.profile;

  List<ProfileFact> get aboutFacts => _repository.aboutFacts;

  List<SocialLink> get socialLinks => _repository.socialLinks;

  List<NavItem> get navItems => _repository.navItems;

  List<SkillGroup> get skillGroups => _repository.skillGroups;

  List<ExperienceEntry> get experiences => _repository.experiences;

  List<Project> get projects => _repository.projects;

  /// Only the projects marked as featured, in their curated order.
  List<Project> get featuredProjects => projects
      .where((Project project) => project.featured)
      .toList(growable: false);

  List<Project> get appProjects => projects
      .where((Project project) => !project.isGame)
      .toList(growable: false);

  List<Project> get gameProjects => projects
      .where((Project project) => project.isGame)
      .toList(growable: false);

  List<ServiceItem> get services => _repository.services;

  List<ProcessStep> get processSteps => _repository.processSteps;

  List<EducationItem> get education => _repository.education;

  List<String> get resumeHighlights => _repository.resumeHighlights;

  Project? projectById(String id) => _repository.projectById(id);

  Project? nextProject(String id) => _repository.nextProject(id);

  SocialLink? get emailLink {
    for (final SocialLink link in socialLinks) {
      if (link.label == 'Email') return link;
    }
    return socialLinks.isEmpty ? null : socialLinks.first;
  }

  /// Every distinct technology mentioned across projects, for the skills strip.
  List<String> get allProjectTech {
    final Set<String> seen = <String>{};
    for (final Project project in projects) {
      seen.addAll(project.stack);
    }
    return seen.toList(growable: false);
  }

  /// Browser tab title.
  String get siteTitle => AppConfig.siteTitle;
}
