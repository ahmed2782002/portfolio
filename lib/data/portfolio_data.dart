import 'package:flutter/painting.dart';

import 'models/portfolio_models.dart';

/// The single source of truth for every word and image on the site.
///
/// Everything here is transcribed from `Ahmed_Esam_Junior_Flutter_Developer_CV.pdf`
/// or is directly visible in the supplied screenshots. Nothing is invented — if
/// a detail was not in the source material, the field is empty or absent and
/// the UI degrades gracefully.
abstract final class PortfolioData {
  // ---------------------------------------------------------------------------
  // Identity
  // ---------------------------------------------------------------------------
  static const Profile profile = Profile(
    fullName: 'Ahmed Esam Abdelsalam',
    shortName: 'Ahmed Esam',
    role: 'Junior Flutter Developer',
    tagline:
        'I build Flutter apps for booking, delivery and social products — '
        'with a particular strength in RTL, Arabic-first interfaces.',
    summary:
        'Junior Flutter Developer with over a year of professional experience '
        'delivering mobile applications across consultation/service-booking, '
        'property booking, and delivery domains. Skilled in BLoC/Cubit state '
        'management, Clean Architecture, and RESTful API integration, with '
        'particular strength in building RTL-aware, Arabic-first interfaces. '
        'Comfortable moving across different app domains and adapting quickly '
        "to each project's structure and business logic.",
    location: 'El Fayoum, Egypt',
    email: 'ahmedesam2772@gmail.com',
    phone: '+20 101 783 7378',
    photoAsset: 'assets/images/profile/ahmed.jpg',
    cvAsset: 'assets/docs/Ahmed_Esam_Flutter_Developer_CV.pdf',
    cvFileName: 'Ahmed_Esam_Flutter_Developer_CV.pdf',
    stats: [
      Stat(value: '+1', label: 'year in production'),
      Stat(value: '5', label: 'apps contributed to'),
      Stat(value: '3', label: 'product domains'),
    ],
    focusAreas: [
      'Flutter',
      'BLoC / Cubit',
      'Clean Architecture',
      'REST + Dio',
      'RTL / i18n',
    ],
  );

  /// Short, factual statements about how Ahmed works — each one traceable to a
  /// line in the CV's summary or experience section.
  static const List<({String title, String body})> principles = [
    (
      title: 'Arabic-first, RTL-aware',
      body:
          'Building layouts that work in both directions — resolving '
          'direction-dependent positioning and localized font rendering '
          'instead of mirroring an LTR design and hoping.',
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
          'Consultation booking, property booking, delivery and social — '
          "adapting quickly to each project's structure and business logic.",
    ),
  ];

  // ---------------------------------------------------------------------------
  // Experience
  // ---------------------------------------------------------------------------
  static const List<ExperienceEntry> experience = [
    ExperienceEntry(
      company: 'NahrDevelopment',
      role: 'Junior Flutter Developer',
      period: 'August 2025 — Present',
      location: 'El Fayoum, Egypt',
      workMode: 'Remote',
      products: ['Qarar', 'Book Iraq', 'Rawnaq'],
      highlights: [
        'Develop and maintain features across multiple Flutter applications, '
            'including Qarar, Booking, and Rawnaq, using BLoC/Cubit state '
            'management and Clean Architecture.',
        'Build fully stateless, testable UI screens with a feature-based '
            'folder structure and consistent state handling for loading, error '
            'and empty states.',
        'Implement RTL-aware, Arabic-first layouts, resolving '
            'direction-dependent positioning and localized font rendering '
            'issues.',
        'Integrate RESTful APIs with Dio, including pagination, '
            'pull-to-refresh, and secure payment and notification flows.',
        'Debug and resolve async lifecycle issues in Cubits and coordinate '
            'authentication flows involving OTP verification and push '
            'notification registration.',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'BLoC',
        'Cubit',
        'Clean Architecture',
        'Dio',
        'REST APIs',
        'FCM',
        'PayMob',
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Skills — grouped, no invented proficiency levels.
  // ---------------------------------------------------------------------------
  static const List<SkillGroup> skillGroups = [
    SkillGroup(
      title: 'Languages & Frameworks',
      items: ['Dart', 'Flutter', 'Java', 'Python', 'C++', 'HTML', 'CSS', 'JSON'],
    ),
    SkillGroup(
      title: 'State Management',
      items: ['BLoC', 'Cubit', 'Provider'],
    ),
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
      title: 'Backend & Integration',
      items: [
        'RESTful APIs',
        'HTTP',
        'Dio',
        'Firebase',
        'FCM',
        'Google Maps',
        'PayMob Payments',
      ],
    ),
    SkillGroup(
      title: 'UI & Localization',
      items: [
        'Responsive UI',
        'Flutter Web',
        'RTL / LTR Layouts',
        'Localization',
        'i18n',
      ],
    ),
    SkillGroup(
      title: 'Data & Storage',
      items: ['Hive', 'Shared Preferences'],
    ),
    SkillGroup(
      title: 'Foundations',
      items: ['OOP', 'Data Structures', 'Algorithms', 'Problem-Solving'],
    ),
    SkillGroup(
      title: 'Tools',
      items: [
        'Android Studio',
        'VS Code',
        'Postman',
        'Jira',
        'Git',
        'GitHub',
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Projects
  //
  // `hasDeviceFrame` records whether the supplied asset *already* contains a
  // phone mockup. Book Iraq and Fresh Driver ship as store graphics that are
  // already framed; Quartz and YourSeat are raw screenshots that the UI wraps
  // in its own device frame.
  // ---------------------------------------------------------------------------
  static const List<Project> projects = [
    Project(
      id: 'book-iraq',
      name: 'Book Iraq',
      category: 'Travel & property booking',
      context: 'NahrDevelopment',
      platform: 'iOS · Android',
      role: 'UI development · REST API integration',
      description:
          'Flutter booking application covering search, property listings, the '
          'booking flow and reservation management. I developed UI screens and '
          'integrated RESTful APIs, with recent work on the FCM token flow and '
          'async Cubit lifecycle stability.',
      tint: Color(0xFF17A398),
      bannerAsset: 'assets/images/projects/book_iraq/banner.jpg',
      features: [
        'Hotel search and property listings',
        'Booking flow and reservation management',
        'Hotel detail with gallery, policy, reviews and map location',
        'Favourites across stays and attractions',
        'Taxi and transport booking, one-way or round-trip',
        'Push notification registration via FCM token flow',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Cubit',
        'Clean Architecture',
        'REST APIs',
        'Dio',
        'Firebase',
        'FCM',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/book_iraq/01_home.jpg',
          caption: 'Home — categories, offers and featured stays',
          aspectRatio: 554 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/book_iraq/02_hotel.jpg',
          caption: 'Hotel detail — gallery, policy, reviews and location',
          aspectRatio: 554 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/book_iraq/03_favorites.jpg',
          caption: 'Favourites — saved stays and attractions',
          aspectRatio: 554 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/book_iraq/04_taxi.jpg',
          caption: 'Taxi booking — trip type, pickup, date and passengers',
          aspectRatio: 554 / 1200,
          hasDeviceFrame: true,
        ),
      ],
    ),
    Project(
      id: 'fresh-driver',
      name: 'Fresh Driver',
      category: 'Delivery & driver logistics',
      context: 'NahrDevelopment',
      platform: 'iOS · Android',
      role: 'REST API integration · Google Maps integration',
      description:
          'Delivery mobile application built with Flutter. I implemented the '
          'RESTful API integration and Google Maps for real-time order tracking '
          'and delivery management.',
      tint: Color(0xFF2E9E4F),
      features: [
        'Incoming order queue with accept and decline',
        'Availability toggle that controls new order visibility',
        'Real-time route and delivery tracking on Google Maps',
        'Order detail with pickup and drop-off addresses',
        'Wallet balance and payout history',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'REST APIs',
        'Dio',
        'Google Maps',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/fresh_driver/01_orders.jpg',
          caption: 'Order queue — accept or decline in seconds',
          aspectRatio: 675 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/fresh_driver/02_navigation.jpg',
          caption: 'Live tracking — route and distance to the store',
          aspectRatio: 669 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/fresh_driver/03_wallet.jpg',
          caption: 'Wallet — balance and payout history',
          aspectRatio: 675 / 1200,
          hasDeviceFrame: true,
        ),
      ],
    ),
    Project(
      id: 'quartz',
      name: 'Quartz',
      category: 'Social media',
      context: 'NahrDevelopment',
      platform: 'iOS · Android',
      role: 'UI development · REST API integration',
      description:
          'Flutter social media app with posts, comments, likes and saved '
          'posts. It supports creating posts with images or polls, sharing '
          'posts, and a profile section for editing name, nickname and photo. '
          'The interface is Arabic-first and fully RTL.',
      tint: Color(0xFF6C2BD9),
      features: [
        'Posts with comments, likes, sharing and bookmarks',
        'Post composer supporting images or polls',
        'Profile editing — name, nickname and profile photo',
        'Nearby discovery with message requests',
        'Granular privacy controls for location and visibility',
        'Arabic-first RTL layout throughout',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Cubit',
        'REST APIs',
        'Dio',
        'RTL',
        'Localization',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/quartz/01_thread.jpg',
          caption: 'Post thread — replies, reactions and tags',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/02_profile.jpg',
          caption: 'Profile — bio, interests and message request',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/03_subscription.jpg',
          caption: 'Subscription — unlocking message requests',
          aspectRatio: 375 / 1013,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/04_privacy.jpg',
          caption: 'Privacy — location, discovery and anonymity controls',
          aspectRatio: 375 / 812,
        ),
      ],
    ),
    Project(
      id: 'yourseat',
      name: 'YourSeat',
      category: 'Seat reservation · Graduation project',
      context: 'Graduation project · Team-based',
      platform: 'iOS · Android · Flutter Web',
      role: 'Flutter UI · Firebase · AI features · Web admin dashboard',
      description:
          'Seat reservation platform built as a team graduation project. I '
          'contributed to Flutter UI development, Firebase integration, the AI '
          'features and a Flutter Web admin dashboard.',
      tint: Color(0xFFB5179E),
      features: [
        'Onboarding and movie discovery — Now Playing and Coming Soon',
        'Interactive seat map with available, reserved and VIP seats',
        'Date and showtime selection with a live running total',
        'AI assistant that recommends films on request',
        'Firebase integration',
        'Flutter Web admin dashboard',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Firebase',
        'Flutter Web',
        'AI Assistant',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/yourseat/01_onboarding.jpg',
          caption: 'Onboarding — first-run introduction',
          aspectRatio: 389 / 843,
        ),
        Screenshot(
          asset: 'assets/images/projects/yourseat/02_now_playing.jpg',
          caption: 'Now Playing — ratings, runtime and genre',
          aspectRatio: 390 / 844,
        ),
        Screenshot(
          asset: 'assets/images/projects/yourseat/03_select_seat.jpg',
          caption: 'Seat map — availability, VIP tiers and showtime',
          aspectRatio: 391 / 844,
        ),
        Screenshot(
          asset: 'assets/images/projects/yourseat/04_ai_assistant.jpg',
          caption: 'AI assistant — conversational recommendations',
          aspectRatio: 390 / 844,
        ),
      ],
    ),
  ];

  /// Named in the CV, no screenshots supplied. Qarar carries a full description
  /// because the CV gives it one.
  static const List<AdditionalProject> additionalProjects = [
    AdditionalProject(
      name: 'Qarar',
      category: 'Consultation booking · Egypt',
      contribution: 'UI development · REST API integration',
      description:
          'Scheduling platform for voice and video consultations with doctors, '
          'lawyers and financial advisors, including a document upload flow for '
          'charity committees.',
    ),
    AdditionalProject(
      name: 'Shahy Eissa',
      category: 'Flutter application',
      contribution: 'UI development · REST API integration',
    ),
    AdditionalProject(
      name: 'MAS',
      category: 'Multi-service application',
      contribution: 'Flutter development',
    ),
    AdditionalProject(
      name: 'Rawnaq',
      category: 'Flutter application',
      contribution: 'UI development',
    ),
    AdditionalProject(
      name: 'Trimly',
      category: 'Flutter application',
      contribution: 'UI development',
    ),
    AdditionalProject(
      name: 'Full-day-24',
      category: 'Flutter application',
      contribution: 'UI development',
    ),
    AdditionalProject(
      name: 'Car Club',
      category: 'Flutter application',
      contribution: 'UI development',
    ),
    AdditionalProject(
      name: 'Re3ayaPlus',
      category: 'Flutter application',
      contribution: 'REST API integration',
    ),
    AdditionalProject(
      name: 'Nagaa',
      category: 'Flutter application',
      contribution: 'REST API integration',
    ),
  ];

  // ---------------------------------------------------------------------------
  // Credentials
  // ---------------------------------------------------------------------------
  static const Education education = Education(
    degree: "Bachelor's Degree, Information Technology",
    institution: 'Egyptian E-Learning University (EELU)',
    period: 'Class of 2025',
    location: 'El Fayoum, Egypt',
  );

  static const List<Certification> certifications = [
    Certification(
      name: 'Information Technology Specialist (ITS)',
      issuer: 'Certiport',
    ),
    Certification(name: 'CCNA', issuer: 'Cisco'),
    Certification(
      name: 'Flutter Development Diploma',
      issuer: 'Route Academy',
      detail: '120 hours · 5 practical projects',
    ),
  ];

  static const List<LanguageSkill> languages = [
    LanguageSkill(name: 'Arabic', level: 'Native'),
    LanguageSkill(name: 'English', level: 'Professional working proficiency'),
  ];

  // ---------------------------------------------------------------------------
  // Contact
  // ---------------------------------------------------------------------------
  static const List<ContactLink> contactChannels = [
    ContactLink(
      label: 'Email',
      value: 'ahmedesam2772@gmail.com',
      url: 'mailto:ahmedesam2772@gmail.com',
      kind: ContactKind.email,
    ),
    ContactLink(
      label: 'Phone',
      value: '+20 101 783 7378',
      url: 'tel:+201017837378',
      kind: ContactKind.phone,
    ),
    ContactLink(
      label: 'Based in',
      value: 'El Fayoum, Egypt',
      url: '',
      kind: ContactKind.location,
    ),
  ];

  /// Public profiles.
  ///
  /// The CV lists none, so nothing is invented here — the UI renders whatever
  /// this list contains and skips the row entirely when it is empty. To add
  /// them later, uncomment and fill in:
  ///
  /// ```dart
  /// ContactLink(
  ///   label: 'GitHub',
  ///   value: 'github.com/<handle>',
  ///   url: 'https://github.com/<handle>',
  ///   kind: ContactKind.github,
  /// ),
  /// ```
  static const List<ContactLink> socialLinks = <ContactLink>[];
}
