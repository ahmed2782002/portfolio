import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/sources/additional_projects_content.dart';
import 'package:portfolio/data/sources/contact_content.dart';
import 'package:portfolio/data/sources/experience_content.dart';
import 'package:portfolio/data/sources/profile_content.dart';
import 'package:portfolio/data/sources/projects_content.dart';
import 'package:portfolio/data/sources/services_content.dart';
import 'package:portfolio/data/sources/skills_content.dart';

/// The one door ViewModels use to reach content.
///
/// Views never import the static sources directly: they ask their ViewModel,
/// which asks this repository. Swapping the static content for a CMS or a JSON
/// file later means changing this class only.
class PortfolioRepository {
  const PortfolioRepository();

  Profile get profile => ProfileContent.profile;
  List<Principle> get principles => ProfileContent.principles;
  Education get education => ProfileContent.education;
  List<Certification> get certifications => ProfileContent.certifications;
  List<LanguageSkill> get languages => ProfileContent.languages;

  List<ExperienceEntry> get experience => ExperienceContent.experience;

  /// The role shown in the hero's status pill.
  ExperienceEntry get currentRole => ExperienceContent.experience.first;

  List<SkillGroup> get skillGroups => SkillsContent.skillGroups;

  List<Project> get projects => ProjectsContent.featured;
  List<AdditionalProject> get additionalProjects =>
      AdditionalProjectsContent.additionalProjects;

  List<ContactLink> get contactChannels => ContactContent.contactChannels;
  List<ContactLink> get socialLinks => ContactContent.socialLinks;

  List<ServiceOffering> get services => ServicesContent.services;
}
