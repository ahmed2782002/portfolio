import 'package:flutter/foundation.dart';

@immutable
class SkillGroup {
  const SkillGroup({required this.title, required this.items});

  final String title;
  final List<String> items;
}
