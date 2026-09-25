import 'package:portfolio/data/models/models.dart';

/// The stack, grouped by purpose, as listed in the CV.
abstract final class SkillsContent {
  static const List<SkillGroup> skillGroups = [
    SkillGroup(
      title: 'Programming Languages',
      items: ['Dart', 'Java', 'Python', 'C++', 'HTML', 'CSS', 'JSON'],
    ),
    SkillGroup(
      title: 'Mobile Development',
      items: ['Flutter', 'Flutter Web', 'Responsive UI', 'Localization (i18n)'],
    ),
    SkillGroup(title: 'State Management', items: ['Bloc', 'Cubit', 'Provider']),
    SkillGroup(
      title: 'Architecture & Patterns',
      items: [
        'Clean Architecture',
        'MVVM',
        'Feature-based Structure',
        'Dependency Injection',
      ],
    ),
    SkillGroup(
      title: 'Networking & APIs',
      items: ['RESTful APIs', 'HTTP', 'Dio'],
    ),
    SkillGroup(
      title: 'Databases & Integrations',
      items: [
        'Hive',
        'Shared Preferences',
        'Firebase',
        'FCM',
        'Google Maps',
        'PayMob Payment Integration',
      ],
    ),
    SkillGroup(
      title: 'AI-Assisted Development',
      items: ['Claude', 'ChatGPT', 'Google Gemini', 'GitHub Copilot'],
    ),
    SkillGroup(
      title: 'Tools & Platforms',
      items: ['Android Studio', 'VS Code', 'Postman', 'Git', 'GitHub', 'Jira'],
    ),
    SkillGroup(
      title: 'Concepts & Foundations',
      items: [
        'OOP',
        'Data Structures',
        'Algorithms',
        'Problem-Solving',
        'Agile Methodology',
      ],
    ),
    SkillGroup(
      title: 'Soft Skills',
      items: ['Teamwork', 'Attention to Detail', 'Adaptability', 'Creativity'],
    ),
  ];
}
