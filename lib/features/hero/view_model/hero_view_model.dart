import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';

/// State and content for the opening screen.
///
/// The pointer parallax lives in a [ValueListenable]: moving the mouse only
/// repaints the backdrop washes and repositions the portrait layers — it never
/// rebuilds the hero.
class HeroViewModel {
  HeroViewModel(this._repository);

  final PortfolioRepository _repository;

  final ValueNotifier<Offset> _parallax = ValueNotifier(Offset.zero);

  /// Small offset opposing the pointer, in logical pixels.
  ValueListenable<Offset> get parallax => _parallax;

  Profile get profile => _repository.profile;
  List<ContactLink> get socialLinks => _repository.socialLinks;
  ExperienceEntry get currentRole => _repository.currentRole;

  bool get isCurrentlyEmployed =>
      currentRole.period.toLowerCase().contains('present');

  String get statusText => isCurrentlyEmployed
      ? 'Currently at ${currentRole.company}'
      : 'Previously at ${currentRole.company}';

  /// The name set on two lines: the short name, then the rest.
  (String, String) get nameLines {
    final full = profile.fullName;
    final short = profile.shortName;
    return full.startsWith(short)
        ? (short, full.substring(short.length).trim())
        : (full, '');
  }

  /// Maps the pointer's position within the hero ([size]) to the parallax.
  void onPointerMoved(Offset localPosition, Size size) {
    if (size.isEmpty || !size.isFinite) return;
    final delta = localPosition - size.center(Offset.zero);
    _parallax.value = Offset(
      (delta.dx / size.width) * -22,
      (delta.dy / size.height) * -16,
    );
  }

  void onPointerLeft() => _parallax.value = Offset.zero;

  void dispose() => _parallax.dispose();
}
