import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project qararProject = Project(
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
      asset: 'assets/images/projects/qarar/01_splash.jpg',
      caption: 'Splash — the Qarar brand mark',
      aspectRatio: 1320 / 2868,
      hasDeviceFrame: true,
    ),
    Screenshot(
      asset: 'assets/images/projects/qarar/02_home.jpg',
      caption: 'Home — categories and featured experts',
      aspectRatio: 1320 / 2868,
      hasDeviceFrame: true,
    ),
    Screenshot(
      asset: 'assets/images/projects/qarar/03_financial.jpg',
      caption: 'Specialties — financial advisors and market insight',
      aspectRatio: 1320 / 2868,
      hasDeviceFrame: true,
    ),
    Screenshot(
      asset: 'assets/images/projects/qarar/04_legal.jpg',
      caption: 'Legal experts — ratings, session price and booking',
      aspectRatio: 1320 / 2868,
      hasDeviceFrame: true,
    ),
    Screenshot(
      asset: 'assets/images/projects/qarar/05_committee.jpg',
      caption: 'Charity committee — details and supported cases',
      aspectRatio: 1320 / 2868,
      hasDeviceFrame: true,
    ),
  ],
);
