import 'package:flutter/material.dart';

import 'package:portfolio/data/models/models.dart';

const Project freshDriverProject = Project(
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
);
