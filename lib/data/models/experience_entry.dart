import 'package:flutter/foundation.dart';

@immutable
class ExperienceEntry {
  const ExperienceEntry({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.workMode,
    required this.highlights,
    required this.technologies,
    required this.products,
  });

  final String company;
  final String role;
  final String period;
  final String location;
  final String workMode;

  /// Responsibilities and contributions, one line each.
  final List<String> highlights;
  final List<String> technologies;

  /// Products touched inside this role.
  final List<String> products;
}
