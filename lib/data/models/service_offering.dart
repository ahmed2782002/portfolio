import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show IconData;

/// A professional service offered to clients and employers.
@immutable
class ServiceOffering {
  const ServiceOffering({
    required this.title,
    required this.description,
    required this.icon,
    required this.deliverables,
    this.badge,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> deliverables;
  final String? badge;
}
