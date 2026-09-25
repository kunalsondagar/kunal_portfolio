import '../models/education_item.dart';
import '../models/experience_entry.dart';
import '../models/nav_item.dart';
import '../models/process_step.dart';
import '../models/project.dart';
import '../models/profile.dart';
import '../models/profile_fact.dart';
import '../models/service_item.dart';
import '../models/skill_group.dart';
import '../models/social_link.dart';
import '../sources/portfolio_content.dart';
import 'portfolio_repository.dart';

/// Serves content from the in-app source.
///
/// Everything is already available synchronously, so there is no loading state to
/// model. [load] exists to keep the interface honest: swapping this for a real
/// data source later does not change any calling code.
class StaticPortfolioRepository implements PortfolioRepository {
  const StaticPortfolioRepository();

  @override
  Profile get profile => PortfolioContent.profile;

  @override
  List<ProfileFact> get aboutFacts => PortfolioContent.aboutFacts;

  @override
  List<SocialLink> get socialLinks => PortfolioContent.socialLinks;

  @override
  List<NavItem> get navItems => PortfolioContent.navItems;

  @override
  List<SkillGroup> get skillGroups => PortfolioContent.skillGroups;

  @override
  List<ExperienceEntry> get experiences => PortfolioContent.experiences;

  @override
  List<Project> get projects => PortfolioContent.projects;

  @override
  List<ServiceItem> get services => PortfolioContent.services;

  @override
  List<ProcessStep> get processSteps => PortfolioContent.processSteps;

  @override
  List<EducationItem> get education => PortfolioContent.education;

  @override
  List<String> get resumeHighlights => PortfolioContent.resumeHighlights;

  @override
  Project? projectById(String id) {
    if (id.isEmpty) return null;
    for (final Project project in projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  @override
  Project? nextProject(String id) {
    final List<Project> all = projects;
    if (all.isEmpty) return null;
    final int index = all.indexWhere((Project project) => project.id == id);
    if (index == -1) return null;
    return all[(index + 1) % all.length];
  }
}
