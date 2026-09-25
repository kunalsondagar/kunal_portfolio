import '../models/education_item.dart';
import '../models/experience_entry.dart';
import '../models/nav_item.dart';
import '../models/process_step.dart';
import '../models/profile.dart';
import '../models/profile_fact.dart';
import '../models/project.dart';
import '../models/service_item.dart';
import '../models/skill_group.dart';
import '../models/social_link.dart';
import '../sources/portfolio_content.dart';

/// Read-only access to everything the site renders.
///
/// The UI depends on this interface, never on [PortfolioContent] directly, so
/// the content source can be swapped for an API, a CMS or a JSON file without
/// touching a single widget.
abstract interface class PortfolioRepository {
  Profile get profile;

  List<ProfileFact> get aboutFacts;

  List<SocialLink> get socialLinks;

  List<NavItem> get navItems;

  List<SkillGroup> get skillGroups;

  List<ExperienceEntry> get experiences;

  List<Project> get projects;

  List<ServiceItem> get services;

  List<ProcessStep> get processSteps;

  List<EducationItem> get education;

  List<String> get resumeHighlights;

  /// Looks up a project by its URL segment. Returns `null` when unknown.
  Project? projectById(String id);

  /// The next project in the list, wrapping around, for the detail-page footer.
  Project? nextProject(String id);
}
