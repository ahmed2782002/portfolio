import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project yourSeatProject = Project(
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
  technologies: ['Flutter', 'Dart', 'Firebase', 'Flutter Web', 'AI Assistant'],
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
);
