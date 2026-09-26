import 'package:portfolio/data/models/models.dart';

/// Identity, working principles and credentials.
///
/// Everything here is transcribed from `Ahmed_Esam_Junior_Flutter_Developer_CV.pdf`
/// — if a detail was not in the source material, the field is empty or absent
/// and the UI degrades gracefully.
abstract final class ProfileContent {
  static const Profile profile = Profile(
    fullName: 'Ahmed Esam Abdelsalam',
    shortName: 'Ahmed Esam',
    role: 'Junior Flutter Developer',
    tagline:
        'I build Flutter apps for booking, delivery, social, e-commerce, '
        'healthcare and automotive products — from clean architecture to '
        'polished, responsive interfaces.',
    summary:
        'Junior Flutter Developer with 1+ year of professional experience '
        'delivering mobile applications across booking, delivery, social, '
        'e-commerce, healthcare, and automotive domains. Skilled in BLoC/Cubit state '
        'management, Clean Architecture, and RESTful API integration, with experience '
        'building multilingual, responsive user interfaces. Comfortable moving across '
        "different app domains and adapting quickly to each project's structure "
        'and business logic.',
    location: 'Cairo, Egypt',
    email: 'ahmedesam2772@gmail.com',
    phone: '+20 101 783 7378',
    photoAsset: 'assets/images/profile/ahmed.jpg',
    cvAsset: 'assets/cv/Ahmed_Esam_Junior_Flutter_Developer_CV.pdf',
    cvFileName: 'Ahmed_Esam_Junior_Flutter_Developer_CV.pdf',
    stats: [
      Stat(value: '1+', label: 'year of experience'),
      Stat(value: '17', label: 'client apps'),
      Stat(value: '10+', label: 'product domains'),
    ],
    focusAreas: [
      'Flutter',
      'BLoC / Cubit',
      'Clean Architecture',
      'REST + Dio',
      'Firebase',
    ],
  );

  /// Short, factual statements about how Ahmed works — each one traceable to a
  /// line in the CV's summary or experience section.
  static const List<Principle> principles = [
    (
      title: 'Responsive by default',
      body:
          'Screens built from UI/UX designs that hold up across phone and '
          'tablet sizes, working closely with designers and backend developers.',
    ),
    (
      title: 'Stateless screens, predictable state',
      body:
          'Fully stateless, testable UI in a feature-based folder structure, '
          'with consistent handling for loading, error and empty states.',
    ),
    (
      title: 'APIs that survive real networks',
      body:
          'RESTful integration with Dio — pagination, pull-to-refresh, and '
          'secure payment and notification flows.',
    ),
    (
      title: 'Comfortable changing domains',
      body:
          'Booking, delivery, social, e-commerce, healthcare and '
          "automotive — adapting quickly to each project's structure and business logic.",
    ),
  ];

  static const Education education = Education(
    degree: 'BSc. Degree in Information Technology',
    institution: 'Egyptian E-Learning University (EELU)',
    period: 'Sept. 2021 – Jun. 2025 · Graduation Project: YourSeat (Grade: A+)',
    location: 'Fayoum Branch',
  );

  static const List<Certification> certifications = [
    Certification(
      name: 'Flutter Development Diploma',
      issuer: 'Route IT Training Center',
      detail:
          'May 2023 – Nov. 2023 · Accredited by the Egyptian Syndicate of '
          'Engineers · 120 hours, 5 practical projects',
    ),
  ];

  static const List<LanguageSkill> languages = [
    LanguageSkill(name: 'Arabic', level: 'Native'),
    LanguageSkill(name: 'English', level: 'Professional working proficiency'),
  ];
}
