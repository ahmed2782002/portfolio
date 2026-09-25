/// The page's top-level sections, in scroll order.
///
/// The nav, the scroll-spy and the anchor keys all derive from this one list,
/// so adding a section is a single-line change.
enum PortfolioSection {
  home('Home', showInNav: false),
  about('About Me'),
  skills('Skills'),
  projects('Projects'),
  experience('Experience'),
  services('Services'),
  contact('Contact');

  const PortfolioSection(this.label, {this.showInNav = true});

  final String label;
  final bool showInNav;

  /// `01`, `02`, … used by the section eyebrows.
  String get displayIndex => index.toString().padLeft(2, '0');

  static List<PortfolioSection> get navItems =>
      values.where((s) => s.showInNav).toList(growable: false);
}
