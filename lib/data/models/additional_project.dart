import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show IconData;

/// Projects the CV names but supplies no screenshots for.
@immutable
class AdditionalProject {
  const AdditionalProject({
    required this.name,
    required this.category,
    required this.contribution,
    this.description,
    this.technologies = const [],
    this.icon,
  });

  final String name;
  final String category;

  /// e.g. "UI development", "REST API integration".
  final String contribution;

  /// Present only where the CV gives one. Revealed when the card is expanded.
  final String? description;

  /// Stack used on the project, revealed alongside [description].
  final List<String> technologies;

  /// Whether the card has anything to reveal on tap.
  bool get hasDetails => description != null || technologies.isNotEmpty;

  /// Optional domain icon.
  final IconData? icon;
}
