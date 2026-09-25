import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project bookIraqProject = Project(
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
);
