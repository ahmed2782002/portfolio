import 'package:flutter/material.dart';

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
        'from clean architecture to polished, responsive interfaces.',
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
      Stat(value: '18+', label: 'apps in production'),
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
  static const List<({String title, String body})> principles = [
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
          'Consultation booking, property booking, delivery and social — '
          "adapting quickly to each project's structure and business logic.",
    ),
  ];

  // ---------------------------------------------------------------------------
  // Experience
  // ---------------------------------------------------------------------------
  static const List<ExperienceEntry> experience = [
    ExperienceEntry(
      company: 'Nahr Development',
      role: 'Junior Flutter Developer',
      period: 'Aug. 2025 — Present',
      location: 'Cairo, Egypt',
      workMode: 'Remote',
      products: [
        'Laundo',
        'Laundo Delivery',
        'Qarar',
        'Booking App',
        'Fresh Driver',
        'Quartz',
        'Rawnaq',
      ],
      highlights: [
        'Collaborate with the Flutter team, backend developers, and UI/UX designers to implement features and resolve technical issues.',
        'Build responsive and scalable mobile applications using Flutter, Dart, BLoC/Cubit, Clean Architecture, and RESTful APIs.',
        'Develop and maintain Flutter applications for clients across the Gulf and Egyptian markets, contributing to features from implementation through release.',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'BLoC',
        'Cubit',
        'Clean Architecture',
        'Dio',
        'REST APIs',
        'Firebase',
        'FCM',
        'Google Maps',
        'PayMob',
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Skills — grouped from CV
  // ---------------------------------------------------------------------------
  static const List<SkillGroup> skillGroups = [
    SkillGroup(
      title: 'Programming Languages',
      items: ['Dart', 'Java', 'Python', 'C++', 'HTML', 'CSS', 'JSON'],
    ),
    SkillGroup(
      title: 'Mobile Development',
      items: [
        'Flutter',
        'Flutter Web',
        'Responsive UI',
        'Localization (i18n)',
      ],
    ),
    SkillGroup(
      title: 'State Management',
      items: ['Bloc', 'Cubit', 'Provider'],
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
      items: [
        'Android Studio',
        'VS Code',
        'Postman',
        'Git',
        'GitHub',
        'Jira',
      ],
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

  // ---------------------------------------------------------------------------
  // Projects
  //
  // `hasDeviceFrame` records whether the supplied asset *already* contains a
  // phone mockup. Qarar, Book Iraq, Fresh Driver and Quartz ship as store
  // graphics that are already framed; Laundo, Laundo Delivery and YourSeat are
  // raw screenshots that the UI wraps in its own device frame.
  // ---------------------------------------------------------------------------
  static const List<Project> projects = [
    Project(
      id: 'laundo',
      name: 'Laundo',
      category: 'Laundry pickup & delivery',
      context: 'Nahr Development',
      platform: 'iOS · Android',
      role: 'UI development · REST API integration',
      description:
          'Application for laundry pickup and delivery customers, covering '
          'order creation with scheduling, checkout with coupons and wallet, '
          'live order tracking, order history with reorder and rating, saved '
          'addresses on the map, authentication with password recovery and an '
          'account section, plus a support system with complaints and FAQs. I '
          'developed the UI and integrated the RESTful APIs.',
      tint: Color(0xFF7FA8E6),
      icon: Icons.local_laundry_service_rounded,
      iconAsset: 'assets/images/projects/laundo/icon.png',
      features: [
        'Order creation with pickup and delivery scheduling',
        'Checkout with coupons and wallet',
        'Live order tracking on Google Maps',
        'Order history with reorder and rating',
        'Saved addresses picked on the map',
        'Authentication with password recovery',
        'Support system with complaints and FAQs',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Cubit',
        'Clean Architecture',
        'REST APIs',
        'Dio',
        'GetIt',
        'Dartz',
        'Easy Localization',
        'Secure Storage',
        'Shared Preferences',
        'Google Maps',
        'Geolocator',
        'Firebase Cloud Messaging',
        'Local Notifications',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/laundo/01_home.png',
          caption: 'Home — offers, current order and quick tracking',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo/02_create_order.png',
          caption: 'Create order — step-by-step with pickup address',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo/03_tracking.png',
          caption: 'Live tracking — driver route, ETA and contact',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo/04_prices.png',
          caption: 'Prices — per service and garment category',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo/05_pickup_location.png',
          caption: 'Pickup location — choose the address on the map',
          aspectRatio: 375 / 828,
        ),
      ],
    ),
    Project(
      id: 'laundo-delivery',
      name: 'Laundo Delivery',
      category: 'Driver app · Laundry logistics',
      context: 'Nahr Development',
      platform: 'iOS · Android',
      role: 'UI development · REST API integration',
      description:
          'Application for laundry pickup and delivery drivers, covering task '
          'management and details with live tracking, QR scanning, signature '
          'capture, task history, authentication with password recovery and an '
          'account section for personal info, documents and service areas, plus '
          'a support system with tickets, complaints and FAQs. I developed the '
          'UI and integrated the RESTful APIs.',
      tint: Color(0xFF6FC3E0),
      icon: Icons.delivery_dining_rounded,
      iconAsset: 'assets/images/projects/laundo_driver/icon.png',
      features: [
        'Task management and task details with live tracking',
        'QR scanning for order handover',
        'Signature capture on delivery',
        'Task history with status filters',
        'Account section — personal info, documents and service areas',
        'Authentication with password recovery',
        'Support system with tickets, complaints and FAQs',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Cubit',
        'Clean Architecture',
        'REST APIs',
        'Dio',
        'GetIt',
        'Dartz',
        'Easy Localization',
        'Secure Storage',
        'Shared Preferences',
        'Google Maps',
        'Geolocator',
        'Mobile Scanner',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/laundo_driver/01_login.png',
          caption: 'Driver login — phone number and password',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo_driver/02_home.png',
          caption: 'Home — availability, daily summary and current task',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo_driver/03_tasks.png',
          caption: 'Tasks — search and filter by status',
          aspectRatio: 375 / 812,
        ),
        Screenshot(
          asset: 'assets/images/projects/laundo_driver/04_history.png',
          caption: 'History — completed and failed pickups and deliveries',
          aspectRatio: 375 / 812,
        ),
      ],
    ),
    Project(
      id: 'qarar',
      name: 'Qarar',
      category: 'Consultation booking',
      context: 'Nahr Development',
      platform: 'iOS · Android',
      role: 'App architecture · UI development · REST API integration',
      description:
          'Flutter consultation-booking app for clients and service providers. '
          'I set up the project and its architecture, built the networking '
          'layer, authentication with OTP, onboarding, profiles and account '
          'security, financial transactions, certificates, charity committees, '
          'help center, notification badges and theme management, and improved '
          'bookings with pagination, filtering and shimmer loading.',
      tint: Color(0xFFD4AF6A),
      icon: Icons.medical_services_rounded,
      iconAsset: 'assets/images/projects/qarar/icon.png',
      features: [
        'Project setup, architecture and networking layer',
        'Authentication with OTP and onboarding',
        'Profiles and account security',
        'Financial transactions and certificates',
        'Charity committees and help center',
        'Bookings with pagination, filtering and shimmer loading',
        'Notification badges and theme management',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Bloc (Cubit)',
        'Dio',
        'GetIt',
        'Dartz',
        'RESTful APIs',
        'Shared Preferences',
        'Flutter ScreenUtil',
        'Shimmer',
        'Toastification',
        'Flutter SVG',
        'Image Picker',
        'File Picker',
        'Intl',
        'Git',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/qarar/01_splash.png',
          caption: 'Splash — the Qarar brand mark',
          aspectRatio: 1320 / 2868,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/qarar/02_home.png',
          caption: 'Home — categories and featured experts',
          aspectRatio: 1320 / 2868,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/qarar/03_financial.png',
          caption: 'Specialties — financial advisors and market insight',
          aspectRatio: 1320 / 2868,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/qarar/04_legal.png',
          caption: 'Legal experts — ratings, session price and booking',
          aspectRatio: 1320 / 2868,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/qarar/05_committee.png',
          caption: 'Charity committee — details and supported cases',
          aspectRatio: 1320 / 2868,
          hasDeviceFrame: true,
        ),
      ],
    ),
    Project(
      id: 'book-iraq',
      name: 'Book Iraq',
      category: 'Travel & property booking',
      context: 'Nahr Development',
      platform: 'iOS · Android',
      role: 'UI development · REST API integration',
      description:
          'Flutter booking application covering search, property listings, the '
          'booking flow and reservation management. I developed UI screens and '
          'integrated RESTful APIs, with recent work on the FCM token flow and '
          'async Cubit lifecycle stability.',
      tint: Color(0xFFA3E4D7),
      icon: Icons.domain_rounded,
      iconAsset: 'assets/images/projects/book_iraq/icon.png',
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
      context: 'Nahr Development',
      platform: 'iOS · Android',
      role: 'REST API integration · Google Maps integration',
      description:
          'Delivery mobile application built with Flutter. I implemented the '
          'RESTful API integration and Google Maps for real-time order tracking '
          'and delivery management.',
      tint: Color(0xFFBB8FCE),
      icon: Icons.local_shipping_rounded,
      iconAsset: 'assets/images/projects/fresh_driver/icon.png',
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
        'Cubit',
        'REST APIs',
        'Dio',
        'Google Maps',
        'Firebase',
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
      context: 'Nahr Development',
      platform: 'iOS · Android',
      role: 'UI development · REST API integration',
      description:
          'Flutter social media app with posts, comments, likes and saved '
          'posts. It supports creating posts with images or polls, sharing '
          'posts, and a profile section for editing name, nickname and photo. '
          'I developed the UI and integrated the RESTful APIs.',
      tint: Color(0xFFBB8FCE),
      icon: Icons.forum_rounded,
      iconAsset: 'assets/images/projects/quartz/icon.png',
      features: [
        'Posts with comments, likes, sharing and bookmarks',
        'Post composer supporting images or polls',
        'Threaded replies on every post',
        'Nearby discovery within a set radius',
        'Profile editing — name, nickname and profile photo',
        'Saved posts and account management',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Cubit',
        'Clean Architecture',
        'REST APIs',
        'Dio',
        'Hive',
        'Shared Preferences',
      ],
      screenshots: [
        Screenshot(
          asset: 'assets/images/projects/quartz/01_splash.jpg',
          caption: 'Splash — the Quartz brand mark',
          aspectRatio: 555 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/02_home.jpg',
          caption: 'Home feed — local posts, tags and reactions',
          aspectRatio: 555 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/03_thread.jpg',
          caption: 'Post thread — replies and likes',
          aspectRatio: 555 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/04_nearby.jpg',
          caption: 'Nearby — discover people within range',
          aspectRatio: 555 / 1200,
          hasDeviceFrame: true,
        ),
        Screenshot(
          asset: 'assets/images/projects/quartz/05_profile.jpg',
          caption: 'Profile — stats, points and account settings',
          aspectRatio: 555 / 1200,
          hasDeviceFrame: true,
        ),
      ],
    ),
    Project(
      id: 'yourseat',
      name: 'YourSeat',
      category: 'Seat reservation · Cinema',
      context: 'Graduation project · Grade: A+',
      platform: 'iOS · Android · Flutter Web',
      role: 'Flutter UI · Firebase · AI features · Web admin dashboard',
      description:
          'Seat reservation platform built as a team graduation project. I '
          'contributed to Flutter UI development, Firebase integration, the AI '
          'features and a Flutter Web admin dashboard.',
      tint: Color(0xFFBB8FCE),
      icon: Icons.theaters_rounded,
      iconAsset: 'assets/images/projects/yourseat/icon.png',
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

  /// Named in the CV, no screenshots supplied.
  static const List<AdditionalProject> additionalProjects = [
    AdditionalProject(
      name: 'Trimly',
      category: 'Freelancer booking application',
      contribution: 'UI development · REST API integration',
      icon: Icons.content_cut_rounded,
      description:
          'Built customer booking requests (upcoming/completed/complaints), '
          'the freelancer chat, freelancer profile and portfolio '
          '(image/video/PDF), freelancer wallet, push notifications for both '
          'roles, and map-based location selection for subscriptions. '
          'Developed the UI and integrated RESTful APIs using Clean '
          'Architecture with Cubit state management.',
      technologies: [
        'Flutter',
        'Dart',
        'BLoC/Cubit',
        'Clean Architecture',
        'RESTful APIs',
        'Dio',
        'Dartz',
        'GetIt',
        'Firebase Cloud Messaging',
        'Flutter Local Notifications',
        'Google Maps',
        'Easy Localization',
        'ScreenUtil',
        'Image Picker',
        'File Picker',
        'Video Player',
        'Syncfusion PDF Viewer',
      ],
    ),
    AdditionalProject(
      name: 'MAS',
      category: 'Multi-service application',
      contribution: 'Networking layer · REST API integration · UI',
      icon: Icons.dashboard_customize_rounded,
      description:
          'Built the networking layer and connected the app to the backend: '
          'phone OTP login, onboarding, profile and logout, orders list and '
          'details, order tracking, Help Center, Loyalty Points, Rewards and '
          'Referral, Terms and Privacy. Redesigned the onboarding, language, '
          'and service-detail screens with a feature-based Clean '
          'Architecture. Developed the UI and integrated RESTful APIs using '
          'Bloc/Cubit.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc/Cubit',
        'Dio',
        'RESTful APIs',
        'GetIt',
        'Dartz',
        'Easy Localization',
        'Flutter ScreenUtil',
        'SharedPreferences',
        'Connectivity Plus',
        'Flutter SVG',
        'URL Launcher',
        'Shimmer',
        'Intl',
      ],
    ),
    AdditionalProject(
      name: 'Rawdy',
      category: 'Shopify e-commerce application',
      contribution: 'GraphQL data layer · UI development',
      icon: Icons.local_mall_rounded,
      description:
          'Customer authentication & registration, profile management, '
          'address book (CRUD, country selection, validation), order history '
          '& order details, guest mode with auth guard, runtime '
          'Arabic/English switching with RTL, localized API error handling. '
          "Migrated the networking layer to Shopify Storefront GraphQL, built "
          "the data layer, and integrated the APIs into the app's UI.",
      technologies: [
        'Flutter',
        'Dart',
        'Bloc (Cubit)',
        'Shopify Storefront API',
        'GraphQL',
        'Dio',
        'GetIt',
        'Dartz',
        'Equatable',
        'Easy Localization',
        'Flutter ScreenUtil',
        'SharedPreferences',
        'Lottie',
        'Flutter SVG',
        'Country Code Picker',
        'Flutter Test',
      ],
    ),
    AdditionalProject(
      name: 'Shahy Eissa',
      category: 'Site & worker management application',
      contribution: 'UI development · REST API integration',
      icon: Icons.shopping_bag_rounded,
      description:
          'Implemented Worker Profile, Site Photos gallery, Materials, '
          'Reports and Activity Log modules, and enhanced Worker Monitoring, '
          'Home Manager and Marble Promo screens. Developed the UI and '
          'integrated RESTful APIs, replacing mock data with live endpoints.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc/Cubit',
        'Dio',
        'GetIt',
        'Dartz',
        'Easy Localization',
        'ScreenUtil',
        'Shimmer',
        'Flutter SVG',
      ],
    ),
    AdditionalProject(
      name: 'Re3ayaPlus',
      category: 'Healthcare application',
      contribution: 'Localization · UI development · REST API integration',
      icon: Icons.health_and_safety_rounded,
      description:
          'Implemented bilingual Arabic/English support (with RTL/LTR) plus '
          'the Settings, Profile Info, Language Selection and Terms/Support '
          "screens, and made the network layer send the user's selected "
          'language. Built new feature screens, integrated the Definitions '
          'REST endpoint, and refactored large existing screens into '
          'modular, reusable widgets.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc (Cubit)',
        'easy_localization',
        'Dio',
        'dartz',
        'Flutter ScreenUtil',
        'flutter_svg',
        'SharedPreferences',
      ],
    ),
    AdditionalProject(
      name: 'Yummy Diet',
      category: 'Diet & meal subscription application',
      contribution: 'UI development · Shared UI kits · Refactoring',
      icon: Icons.restaurant_menu_rounded,
      description:
          "Built the Yummy Kids module (child profiles, kids' subscription "
          "and plans, meal selection, Today's Meals, Kids Home, daily gift, "
          'calorie calculator) and turned repeated Adult/Kids screens into '
          'shared UI kits (plans, duration, subscription, meal schedule, '
          'cart, checkout). Refactored existing screens for RTL support, '
          'accessibility, performance and a consistent design system. '
          "Developed the UI and restructured teammates' screens into "
          'reusable, tested components.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc (Cubit)',
        'Equatable',
        'Easy Localization',
        'ScreenUtil',
        'Flutter SVG',
        'Shared Preferences',
        'Fortune Wheel',
        'Flutter Test',
      ],
    ),
    AdditionalProject(
      name: 'Full Day 24',
      category: 'Flutter application',
      contribution: 'UI development',
      icon: Icons.access_time_filled_rounded,
      description:
          'Built the authentication flow (Welcome, Login, Register, OTP '
          'verification, Forgot/Reset Password) and the account support '
          'screens (Help/FAQ, Contact Us, Invite Friend, Privacy Policy), '
          'with bilingual Arabic/English UI, shimmer loading states, and '
          'reusable form widgets. Developed responsive, pixel-accurate '
          'Flutter UI with Cubit state management.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc (Cubit)',
        'Flutter ScreenUtil',
        'Easy Localization',
        'Shimmer',
        'Flutter SVG',
        'Pinput',
        'Flutter HTML',
        'URL Launcher',
      ],
    ),
    AdditionalProject(
      name: 'Fresh Market',
      category: 'Grocery shopping application',
      contribution: 'UI development · REST API integration',
      icon: Icons.local_grocery_store_rounded,
      description:
          'Built language switching with backend sync (including the profile '
          'language settings) and the logout flow. Enhanced the '
          'Arabic/English localization, Firebase push notifications, the '
          'order summary breakdown (fees, tax, promo discount, net amount), '
          'and 401/403 handling that sends the user back to login. Developed '
          'the UI and integrated RESTful APIs using Cubit state management.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc (Cubit)',
        'Dio',
        'GetIt',
        'Dartz',
        'Easy Localization',
        'Firebase Cloud Messaging',
        'Flutter Local Notifications',
        'SharedPreferences',
        'Flutter ScreenUtil',
        'Gradle',
      ],
    ),
    AdditionalProject(
      name: 'Car Club',
      category: 'Automotive services application',
      contribution: 'UI development · State management',
      icon: Icons.directions_car_rounded,
      description:
          'Carnet de Passage booking (multi-step form), International '
          'Driving License, Customs Clearance with document upload, Quick '
          'Registration, Payment & Credit Card checkout, Wallet, Order '
          'Success & Tracking, Branches, Notifications, plus refactoring of '
          'Auth/OTP, Onboarding and Home flows. Developed the UI and state '
          'management for these features end-to-end using Bloc/Cubit.',
      technologies: [
        'Flutter',
        'Dart',
        'Bloc/Cubit',
        'GetIt',
        'Easy Localization',
        'Flutter ScreenUtil',
        'Flutter SVG',
        'Image Picker',
        'Pinput',
      ],
    ),
    AdditionalProject(
      name: 'Rawnaq',
      category: 'Flutter application',
      contribution: 'UI development',
      icon: Icons.auto_awesome_rounded,
    ),
    AdditionalProject(
      name: 'Nagaa',
      category: 'Flutter application',
      contribution: 'REST API integration',
      icon: Icons.storefront_rounded,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Credentials
  // ---------------------------------------------------------------------------
  static const Education education = Education(
    degree: "BSc. Degree, Information Technology",
    institution: 'Egyptian E-Learning University (EELU)',
    period: 'Sept. 2021 – Jun. 2025 · Grade: A+ (Graduation Project: YourSeat)',
    location: 'Fayoum Branch',
  );

  static const List<Certification> certifications = [
    Certification(
      name: 'Flutter Development Diploma',
      issuer: 'Route IT Training Center',
      detail: 'May 2023 – Nov. 2023 · Accredited by the Egyptian Syndicate of '
          'Engineers · 120 hours, 5 practical projects',
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
      value: 'Cairo, Egypt',
      url: '',
      kind: ContactKind.location,
    ),
  ];

  /// Public profiles and messaging channels.
  static const List<ContactLink> socialLinks = <ContactLink>[
    ContactLink(
      label: 'LinkedIn',
      value: 'Ahmed Esam',
      url: 'https://www.linkedin.com/in/ahmed-esam-042032347/',
      kind: ContactKind.linkedin,
    ),
    ContactLink(
      label: 'GitHub',
      value: 'ahmed2782002',
      url: 'https://github.com/ahmed2782002',
      kind: ContactKind.github,
    ),
    ContactLink(
      label: 'WhatsApp',
      value: '+20 101 783 7378',
      url: 'https://wa.me/201017837378',
      kind: ContactKind.whatsapp,
    ),
  ];

  /// Core development and engineering services.
  static const List<ServiceOffering> services = [
    ServiceOffering(
      title: 'Cross-Platform Mobile Apps',
      description:
          'End-to-end mobile app development for iOS and Android using Flutter & Dart. Clean code, high responsiveness, and platform-native feel.',
      icon: Icons.phone_iphone_rounded,
      badge: 'Core Focus',
      deliverables: [
        'iOS & Android builds',
        'Responsive phone & tablet UI',
        'Offline caching & persistence',
        'App store compliance',
      ],
    ),
    ServiceOffering(
      title: 'State Management & Architecture',
      description:
          'Structuring scalable and maintainable Flutter applications using BLoC/Cubit, Clean Architecture, and strict separation of concerns.',
      icon: Icons.account_tree_rounded,
      badge: 'Architecture',
      deliverables: [
        'BLoC / Cubit implementation',
        'Clean Architecture layers',
        'Repository pattern & DI',
        'Testable business logic',
      ],
    ),
    ServiceOffering(
      title: 'REST API & Backend Integration',
      description:
          'Connecting mobile apps with backend RESTful services, JSON APIs, and cloud services with robust error handling and token authentication.',
      icon: Icons.cloud_sync_rounded,
      deliverables: [
        'Dio client setup & interceptors',
        'JWT Auth & Refresh tokens',
        'Firebase integration',
        'Real-time data handling',
      ],
    ),
    ServiceOffering(
      title: 'Payments, Maps & Notifications',
      description:
          'Wiring the integrations real products depend on — PayMob payments, Google Maps tracking, and Firebase Cloud Messaging push notifications.',
      icon: Icons.integration_instructions_rounded,
      badge: 'Integrations',
      deliverables: [
        'PayMob payment flows',
        'Google Maps & live tracking',
        'FCM push notifications',
        'Local storage with Hive',
      ],
    ),
    ServiceOffering(
      title: 'Figma to Flutter UI/UX',
      description:
          'Translating design prototypes into pixel-perfect Flutter widgets with micro-animations, smooth transitions, and custom themes.',
      icon: Icons.palette_outlined,
      deliverables: [
        'Pixel-perfect screen coding',
        'Smooth 60fps micro-animations',
        'Light & Dark mode themes',
        'Custom interactive components',
      ],
    ),
    ServiceOffering(
      title: 'Performance & App Refactoring',
      description:
          'Auditing, optimizing, and fixing existing Flutter codebases to eliminate frame drops, minimize memory leaks, and upgrade legacy packages.',
      icon: Icons.speed_rounded,
      deliverables: [
        'Repaint boundary profiling',
        'Memory leak elimination',
        'Widget rebuild optimization',
        'Code refactoring & bug fixing',
      ],
    ),
  ];
}
