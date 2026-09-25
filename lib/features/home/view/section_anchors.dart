import 'package:flutter/widgets.dart';

import 'package:portfolio/features/home/models/portfolio_section.dart';

/// One [GlobalKey] per section, plus the geometry queries the scroll-spy and
/// the nav's scroll-to need.
class SectionAnchors {
  final Map<PortfolioSection, GlobalKey> _keys = {
    for (final section in PortfolioSection.values) section: GlobalKey(),
  };

  GlobalKey keyFor(PortfolioSection section) => _keys[section]!;

  RenderBox? _boxOf(PortfolioSection section) {
    final box = _keys[section]?.currentContext?.findRenderObject();
    return box is RenderBox && box.hasSize ? box : null;
  }

  /// The section's top edge in global coordinates.
  double? topOf(PortfolioSection section) =>
      _boxOf(section)?.localToGlobal(Offset.zero).dy;

  double heightOf(PortfolioSection section) =>
      _boxOf(section)?.size.height ?? 0;

  /// The last section whose top edge has passed [spyLine].
  PortfolioSection activeAt(double spyLine) {
    var active = PortfolioSection.home;
    for (final section in PortfolioSection.values) {
      final top = topOf(section);
      if (top != null && top <= spyLine) active = section;
    }
    return active;
  }
}
