import 'package:portfolio/data/models/models.dart';

abstract final class ExperienceContent {
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
        'Book Iraq',
        'Fresh Driver',
        'Quartz',
        'Trimly',
        'MAS',
        'Rawdy',
        'Shahy Eissa',
        'Re3ayaPlus',
        'Yummy Diet',
        'Full Day 24',
        'Fresh Market',
        'Car Club',
        'Rawnaq',
        'Nagaa Driver App',
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
}
