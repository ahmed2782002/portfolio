import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project laundoDeliveryProject = Project(
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
      asset: 'assets/images/projects/laundo_driver/01_login.jpg',
      caption: 'Driver login — phone number and password',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo_driver/02_home.jpg',
      caption: 'Home — availability, daily summary and current task',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo_driver/03_tasks.jpg',
      caption: 'Tasks — search and filter by status',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo_driver/04_history.jpg',
      caption: 'History — completed and failed pickups and deliveries',
      aspectRatio: 375 / 812,
    ),
  ],
);
