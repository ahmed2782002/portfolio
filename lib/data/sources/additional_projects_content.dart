import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

/// Projects the CV names but supplies no screenshots for.
abstract final class AdditionalProjectsContent {
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
      description:
          'Built the entire UI of the app end-to-end, every screen and '
          'flow, with bilingual Arabic/English support (RTL/LTR), shimmer '
          'loading states, and reusable widgets. Developed responsive, '
          'pixel-accurate Flutter UI with Cubit state management.',
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
      name: 'Nagaa Driver App',
      category: 'Delivery rider application',
      contribution: 'Feature development · REST API integration',
      icon: Icons.delivery_dining_rounded,
      description:
          'A delivery app for riders. Riders register with multi-step '
          'onboarding and document upload, then manage their profile and '
          'vehicle details. They can go online or offline with live location '
          'updates and handle internal and external partner orders with '
          'detailed order views. The app also covers wallet transaction '
          'history, a help center, and policy pages loaded from the API. '
          'Built the auth, profile, orders, and wallet features and '
          'integrated the RESTful APIs.',
      technologies: [
        'Flutter',
        'Dart',
        'Cubit',
        'Clean Architecture',
        'REST APIs',
        'Dio',
        'GetIt',
        'Dartz',
        'Google Maps',
        'Geolocator',
        'Easy Localization',
        'Image Picker',
      ],
    ),
  ];
}
