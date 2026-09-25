import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project laundoProject = Project(
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
      asset: 'assets/images/projects/laundo/01_home.jpg',
      caption: 'Home — offers, current order and quick tracking',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo/02_create_order.jpg',
      caption: 'Create order — step-by-step with pickup address',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo/03_tracking.jpg',
      caption: 'Live tracking — driver route, ETA and contact',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo/04_prices.jpg',
      caption: 'Prices — per service and garment category',
      aspectRatio: 375 / 812,
    ),
    Screenshot(
      asset: 'assets/images/projects/laundo/05_pickup_location.jpg',
      caption: 'Pickup location — choose the address on the map',
      aspectRatio: 375 / 828,
    ),
  ],
);
