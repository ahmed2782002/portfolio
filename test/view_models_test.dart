import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/features/hero/view_model/hero_view_model.dart';
import 'package:portfolio/features/home/models/portfolio_section.dart';
import 'package:portfolio/features/home/view_model/home_view_model.dart';
import 'package:portfolio/features/projects/view_model/projects_view_model.dart';

const repository = PortfolioRepository();

void main() {
  group('ProjectsViewModel', () {
    test('switching project resets the screenshot and notifies', () {
      final viewModel = ProjectsViewModel(repository);
      var notified = 0;
      viewModel.addListener(() => notified++);

      viewModel.step(1);
      expect(viewModel.shotIndex, 1);

      viewModel.selectProject(1);
      expect(viewModel.projectIndex, 1);
      expect(viewModel.shotIndex, 0);
      expect(notified, 2);
    });

    test('stepping is clamped to the gallery', () {
      final viewModel = ProjectsViewModel(repository);
      expect(viewModel.canStepBack, isFalse);

      viewModel.step(-1);
      expect(viewModel.shotIndex, 0);

      viewModel.selectShot(999);
      expect(viewModel.shotIndex, viewModel.project.screenshots.length - 1);
      expect(viewModel.canStepForward, isFalse);
    });

    test('re-selecting the current project does not notify', () {
      final viewModel = ProjectsViewModel(repository);
      var notified = false;
      viewModel.addListener(() => notified = true);

      viewModel.selectProject(0);
      expect(notified, isFalse);
    });
  });

  group('HomeViewModel', () {
    test('derives nav and progress state from the scroll position', () {
      final viewModel = HomeViewModel(repository);

      viewModel.onScrolled(
        pixels: 500,
        maxExtent: 1000,
        heroExtent: 900,
        active: PortfolioSection.about,
      );
      expect(viewModel.condensed.value, isTrue);
      expect(viewModel.progress.value, closeTo(0.5, 0.001));
      expect(viewModel.activeSection.value, PortfolioSection.about);
      expect(viewModel.heroVisible.value, isTrue);

      viewModel.onScrolled(
        pixels: 950,
        maxExtent: 1000,
        heroExtent: 900,
        active: PortfolioSection.skills,
      );
      expect(viewModel.heroVisible.value, isFalse);

      viewModel.dispose();
    });

    test('opens and closes the mobile menu', () {
      final viewModel = HomeViewModel(repository);
      viewModel.openMenu();
      expect(viewModel.menuOpen.value, isTrue);
      viewModel.closeMenu();
      expect(viewModel.menuOpen.value, isFalse);
      viewModel.dispose();
    });
  });

  group('HeroViewModel', () {
    test('parallax opposes the pointer and resets on exit', () {
      final viewModel = HeroViewModel(repository);
      const size = Size(1000, 800);

      viewModel.onPointerMoved(const Offset(1000, 800), size);
      expect(viewModel.parallax.value.dx, lessThan(0));
      expect(viewModel.parallax.value.dy, lessThan(0));

      viewModel.onPointerLeft();
      expect(viewModel.parallax.value, Offset.zero);
      viewModel.dispose();
    });

    test('ignores an unlaid-out hero', () {
      final viewModel = HeroViewModel(repository);
      viewModel.onPointerMoved(const Offset(10, 10), Size.zero);
      expect(viewModel.parallax.value, Offset.zero);
      viewModel.dispose();
    });

    test('splits the full name into the short name and the rest', () {
      final viewModel = HeroViewModel(repository);
      final (first, second) = viewModel.nameLines;
      expect('$first $second', repository.profile.fullName);
      expect(first, repository.profile.shortName);
      viewModel.dispose();
    });
  });
}
