import 'package:flutter/foundation.dart';

@immutable
class Education {
  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    required this.location,
  });

  final String degree;
  final String institution;
  final String period;
  final String location;
}

@immutable
class Certification {
  const Certification({
    required this.name,
    required this.issuer,
    this.detail = '',
  });

  final String name;
  final String issuer;
  final String detail;
}

@immutable
class LanguageSkill {
  const LanguageSkill({required this.name, required this.level});

  final String name;
  final String level;
}
