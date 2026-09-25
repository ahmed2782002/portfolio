import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project quartzProject = Project(
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
);
