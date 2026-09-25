import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

abstract final class ServicesContent {
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
