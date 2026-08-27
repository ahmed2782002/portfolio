import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/constants/app_animations.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/link_launcher.dart';
import '../../data/portfolio_data.dart';
import '../about/about_section.dart';
import '../contact/contact_section.dart';
import '../experience/experience_section.dart';
import '../footer/site_footer.dart';
import '../hero/hero_section.dart';
import '../projects/projects_section.dart';
import '../skills/skills_section.dart';
import 'portfolio_section.dart';
import 'widgets/mobile_menu.dart';
import 'widgets/nav_bar.dart';
import 'widgets/scroll_progress.dart';

/// The single page.
///
/// Owns the scroll controller, the section anchors and the scroll-spy that
/// keeps the nav in sync. Everything below it is presentational.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  /// One anchor per section, used both for scroll-to and for the spy.
  final Map<PortfolioSection, GlobalKey> _anchors = {
    for (final section in PortfolioSection.values) section: GlobalKey(),
  };

  PortfolioSection _active = PortfolioSection.home;
  bool _condensed = false;
  bool _menuOpen = false;
  double _progress = 0;

  /// Coalesces a burst of scroll notifications into one post-frame check.
  bool _scrollSyncScheduled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Scroll spy
  // ---------------------------------------------------------------------------

  /// The scroll position notifies from inside the viewport's layout pass, where
  /// reading anchor geometry (or calling `setState`) would re-enter layout. The
  /// spy therefore runs after the frame, when every box has settled.
  void _onScroll() {
    if (_scrollSyncScheduled) return;
    _scrollSyncScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollSyncScheduled = false;
      if (mounted) _syncScrollState();
    });
  }

  void _syncScrollState() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;

    final condensed = position.pixels > 40;
    final maxExtent = position.maxScrollExtent;
    final progress =
        maxExtent <= 0 ? 0.0 : (position.pixels / maxExtent).clamp(0.0, 1.0);
    final active = _resolveActiveSection(position.viewportDimension);

    // Only rebuild when something a widget actually renders has changed.
    if (condensed == _condensed &&
        active == _active &&
        (progress - _progress).abs() < 0.002) {
      return;
    }

    setState(() {
      _condensed = condensed;
      _active = active;
      _progress = progress;
    });
  }

  /// The active section is the last one whose top edge has passed the spy line,
  /// which sits just below the nav bar.
  PortfolioSection _resolveActiveSection(double viewportHeight) {
    final spyLine = NavBar.heightCondensed + viewportHeight * 0.22;
    var active = PortfolioSection.home;

    for (final section in PortfolioSection.values) {
      final box =
          _anchors[section]?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= spyLine) active = section;
    }

    // At the very bottom the last section may never cross the line — if the
    // page is scrolled out, treat the final section as active.
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 8) {
      active = PortfolioSection.values.last;
    }
    return active;
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  Future<void> _goTo(PortfolioSection section) async {
    if (_menuOpen) setState(() => _menuOpen = false);

    if (section == PortfolioSection.home) {
      await _scrollController.animateTo(
        0,
        duration: AppAnimations.scrollTo,
        curve: AppAnimations.scrollCurve,
      );
      return;
    }

    final box =
        _anchors[section]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !_scrollController.hasClients) return;

    // Land the section top just under the condensed nav bar.
    final delta = box.localToGlobal(Offset.zero).dy - NavBar.heightCondensed - 8;
    final target = (_scrollController.offset + delta)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(
      target,
      duration: AppAnimations.scrollTo,
      curve: AppAnimations.scrollCurve,
    );
  }

  void _downloadCv() =>
      LinkLauncher.openAsset(context, PortfolioData.profile.cvAsset);

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeController.isDark(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _anchor(
                      PortfolioSection.home,
                      HeroSection(
                        onNavigate: _goTo,
                        onDownloadCv: _downloadCv,
                      ),
                    ),
                    _anchor(PortfolioSection.about, const AboutSection()),
                    _anchor(
                      PortfolioSection.experience,
                      const ExperienceSection(),
                    ),
                    _anchor(PortfolioSection.skills, const SkillsSection()),
                    _anchor(PortfolioSection.projects, const ProjectsSection()),
                    _anchor(
                      PortfolioSection.contact,
                      ContactSection(onDownloadCv: _downloadCv),
                    ),
                    SiteFooter(onNavigate: _goTo),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              active: _active,
              onNavigate: _goTo,
              condensed: _condensed,
              isDark: isDark,
              onToggleTheme: () => widget.themeController.toggle(context),
              onOpenMenu: () => setState(() => _menuOpen = true),
              onDownloadCv: _downloadCv,
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ScrollProgressBar(progress: _progress),
          ),

          Positioned.fill(
            child: MobileMenu(
              visible: _menuOpen,
              active: _active,
              onNavigate: _goTo,
              onClose: () => setState(() => _menuOpen = false),
              onDownloadCv: () {
                setState(() => _menuOpen = false);
                _downloadCv();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Wraps a section in its anchor key and a semantic heading boundary.
  Widget _anchor(PortfolioSection section, Widget child) => KeyedSubtree(
        key: _anchors[section],
        child: Semantics(
          container: true,
          label: '${section.label} section',
          child: child,
        ),
      );
}
