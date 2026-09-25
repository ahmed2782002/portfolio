import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:portfolio/core/constants/app_animations.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/utils/link_launcher.dart';
import 'package:portfolio/features/about/view/about_section.dart';
import 'package:portfolio/features/contact/view/contact_section.dart';
import 'package:portfolio/features/experience/view/experience_section.dart';
import 'package:portfolio/features/footer/view/site_footer.dart';
import 'package:portfolio/features/hero/view/hero_section.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/home/view/section_anchors.dart';
import 'package:portfolio/features/home/view_model/home_view_model.dart';
import 'package:portfolio/features/home/widgets/mobile_menu.dart';
import 'package:portfolio/features/home/widgets/nav_bar.dart';
import 'package:portfolio/features/home/widgets/scroll_progress.dart';
import 'package:portfolio/features/projects/view/projects_section.dart';
import 'package:portfolio/features/services/view/services_section.dart';
import 'package:portfolio/features/skills/view/skills_section.dart';

/// The single page.
///
/// Owns the scroll controller and the section anchors; all page state lives in
/// [HomeViewModel]. Scrolling never calls `setState` here — the sections are
/// built once and only the nav and the progress rule listen to the scroll.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final SectionAnchors _anchors = SectionAnchors();
  late final HomeViewModel _viewModel = HomeViewModel(context.repository);

  /// Coalesces a burst of scroll notifications into one post-frame check.
  bool _scrollSyncScheduled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _viewModel.dispose();
    super.dispose();
  }

  /// The scroll position notifies from inside the viewport's layout pass, where
  /// reading anchor geometry would re-enter layout. The spy therefore runs
  /// after the frame, when every box has settled.
  void _onScroll() {
    if (_scrollSyncScheduled) return;
    _scrollSyncScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollSyncScheduled = false;
      if (mounted && _scrollController.hasClients) _syncScrollState();
    });
  }

  void _syncScrollState() {
    final position = _scrollController.position;
    final spyLine = NavBar.heightCondensed + position.viewportDimension * 0.22;

    // At the very bottom the last section may never cross the spy line.
    final atBottom = position.pixels >= position.maxScrollExtent - 8;

    _viewModel.onScrolled(
      pixels: position.pixels,
      maxExtent: position.maxScrollExtent,
      heroExtent: _anchors.heightOf(PortfolioSection.home),
      active: atBottom
          ? PortfolioSection.values.last
          : _anchors.activeAt(spyLine),
    );
  }

  Future<void> _goTo(PortfolioSection section) async {
    _viewModel.closeMenu();
    if (!_scrollController.hasClients) return;

    double target = 0;
    if (section != PortfolioSection.home) {
      final top = _anchors.topOf(section);
      if (top == null) return;
      // Land the section top just under the condensed nav bar.
      target = (_scrollController.offset + top - NavBar.heightCondensed - 8)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
    }

    await _scrollController.animateTo(
      target,
      duration: AppAnimations.scrollTo,
      curve: AppAnimations.scrollCurve,
    );
  }

  void _downloadCv() {
    _viewModel.closeMenu();
    LinkLauncher.openAsset(context, _viewModel.profile.cvAsset);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.themeController;

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
                    _section(
                      PortfolioSection.home,
                      // Pause the hero's looping motion once it is off screen.
                      ValueListenableBuilder<bool>(
                        valueListenable: _viewModel.heroVisible,
                        builder: (context, visible, child) =>
                            TickerMode(enabled: visible, child: child!),
                        child: HeroSection(
                          onNavigate: _goTo,
                          onDownloadCv: _downloadCv,
                        ),
                      ),
                    ),
                    _section(PortfolioSection.about, const AboutSection()),
                    _section(PortfolioSection.skills, const SkillsSection()),
                    _section(
                      PortfolioSection.projects,
                      const ProjectsSection(),
                    ),
                    _section(
                      PortfolioSection.experience,
                      const ExperienceSection(),
                    ),
                    _section(
                      PortfolioSection.services,
                      const ServicesSection(),
                    ),
                    _section(
                      PortfolioSection.contact,
                      ContactSection(onDownloadCv: _downloadCv),
                    ),
                    RepaintBoundary(child: SiteFooter(onNavigate: _goTo)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ListenableBuilder(
              listenable: Listenable.merge([
                _viewModel.activeSection,
                _viewModel.condensed,
              ]),
              builder: (context, _) => NavBar(
                shortName: _viewModel.profile.shortName,
                active: _viewModel.activeSection.value,
                condensed: _viewModel.condensed.value,
                isDark: themeController.isDark(context),
                onNavigate: _goTo,
                onToggleTheme: () => themeController.toggle(context),
                onOpenMenu: _viewModel.openMenu,
                onDownloadCv: _downloadCv,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _viewModel.progress,
              builder: (context, progress, _) =>
                  ScrollProgressBar(progress: progress),
            ),
          ),
          Positioned.fill(
            child: ListenableBuilder(
              listenable: Listenable.merge([
                _viewModel.menuOpen,
                _viewModel.activeSection,
              ]),
              builder: (context, _) => MobileMenu(
                visible: _viewModel.menuOpen.value,
                active: _viewModel.activeSection.value,
                email: _viewModel.profile.email,
                onNavigate: _goTo,
                onClose: _viewModel.closeMenu,
                onDownloadCv: _downloadCv,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Wraps a section in its anchor key, a semantic boundary and its own
  /// repaint layer — scrolling then just moves cached layers instead of
  /// re-recording the whole page every frame.
  Widget _section(PortfolioSection section, Widget child) => KeyedSubtree(
    key: _anchors.keyFor(section),
    child: Semantics(
      container: true,
      label: '${section.label} section',
      child: RepaintBoundary(child: child),
    ),
  );
}
