import 'package:flutter/foundation.dart';

@immutable
class Profile {
  const Profile({
    required this.fullName,
    required this.shortName,
    required this.role,
    required this.summary,
    required this.tagline,
    required this.location,
    required this.email,
    required this.phone,
    required this.photoAsset,
    required this.cvAsset,
    required this.cvFileName,
    required this.stats,
    required this.focusAreas,
  });

  final String fullName;

  /// Used in the nav mark and the footer.
  final String shortName;
  final String role;

  /// The CV's professional summary, verbatim in substance.
  final String summary;

  /// One line the hero leads with.
  final String tagline;
  final String location;
  final String email;
  final String phone;
  final String photoAsset;
  final String cvAsset;
  final String cvFileName;

  /// Three at-a-glance numbers for the hero rail.
  final List<Stat> stats;

  /// Technology labels that float around the hero portrait.
  final List<String> focusAreas;

  String get mailtoUri => 'mailto:$email';

  /// `tel:` needs the number without separators.
  String get telUri => 'tel:${phone.replaceAll(RegExp(r'[^\d+]'), '')}';
}

@immutable
class Stat {
  const Stat({required this.value, required this.label});

  final String value;
  final String label;
}

/// A short, factual statement about how Ahmed works.
typedef Principle = ({String title, String body});
