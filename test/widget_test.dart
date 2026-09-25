import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/theme/theme_controller.dart';
import 'package:portfolio/data/models/models.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/features/projects/view/projects_section.dart';
import 'package:portfolio/shared/widgets/device/screenshot_plate.dart';

const repository = PortfolioRepository();

/// Wraps a section in just enough app scaffolding to pump it.
Widget host(Widget child, {Size size = const Size(1440, 1200)}) => AppScope(
  repository: repository,
  themeController: ThemeController(mode: ThemeMode.light),
  child: MaterialApp(
    theme: AppTheme.light(),
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  ),
);

void main() {
  group('portfolio data', () {
    test('every image the content references exists on disk', () {
      final assets = [
        repository.profile.photoAsset,
        repository.profile.cvAsset,
        for (final project in repository.projects) ...[
          ?project.iconAsset,
          ?project.bannerAsset,
          for (final shot in project.screenshots) shot.asset,
        ],
      ];
      for (final asset in assets) {
        expect(File(asset).existsSync(), isTrue, reason: asset);
      }
    });

    test('every screenshot asset is declared exactly once', () {
      final assets = [
        for (final project in repository.projects)
          for (final shot in project.screenshots) shot.asset,
      ];
      expect(
        assets.toSet().length,
        assets.length,
        reason: 'a screenshot is listed twice',
      );
    });

    test('every project has screenshots, features and a stack', () {
      for (final project in repository.projects) {
        expect(project.screenshots, isNotEmpty, reason: project.name);
        expect(project.features, isNotEmpty, reason: project.name);
        expect(project.technologies, isNotEmpty, reason: project.name);
      }
    });

    test('screenshot aspect ratios are plausible portrait values', () {
      for (final project in repository.projects) {
        for (final shot in project.screenshots) {
          expect(shot.aspectRatio, greaterThan(0.2), reason: shot.asset);
          expect(shot.aspectRatio, lessThan(1.0), reason: shot.asset);
        }
      }
    });

    test('contact links carry a scheme where they are actionable', () {
      for (final link in repository.contactChannels) {
        if (link.url.isEmpty) continue;
        expect(Uri.parse(link.url).hasScheme, isTrue, reason: link.label);
      }
    });
  });

  group('ScreenshotPlate.widthForHeight', () {
    test('a pre-framed asset maps height through its aspect ratio', () {
      const shot = Screenshot(
        asset: 'a.jpg',
        caption: 'a',
        aspectRatio: 0.5,
        hasDeviceFrame: true,
      );
      expect(ScreenshotPlate.widthForHeight(shot, 400), closeTo(200, 0.01));
    });

    test('a raw screenshot accounts for the bezel it will be wrapped in', () {
      const shot = Screenshot(asset: 'a.jpg', caption: 'a', aspectRatio: 0.5);
      final width = ScreenshotPlate.widthForHeight(shot, 400);

      // Reconstructing the frame from that width must give the height back.
      const bezelRatio = 0.035;
      final bezel = width * bezelRatio;
      final height = (width - bezel * 2) / shot.aspectRatio + bezel * 2;
      expect(height, closeTo(400, 0.01));
    });

    test('taller screens come out narrower at the same height', () {
      const short = Screenshot(asset: 'a.jpg', caption: 'a', aspectRatio: 0.46);
      const tall = Screenshot(asset: 'b.jpg', caption: 'b', aspectRatio: 0.37);
      expect(
        ScreenshotPlate.widthForHeight(tall, 500),
        lessThan(ScreenshotPlate.widthForHeight(short, 500)),
      );
    });
  });

  group('projects showcase', () {
    testWidgets('opens on the first project and can switch to another', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const ProjectsSection()));
      await tester.pumpAndSettle();

      final first = repository.projects[0];
      final second = repository.projects[1];

      // The first case study's description is on screen.
      expect(find.text(first.description), findsOneWidget);

      await tester.tap(find.text(second.name).first);
      await tester.pumpAndSettle();

      expect(find.text(second.description), findsOneWidget);
      expect(find.text(first.description), findsNothing);
    });

    testWidgets('selecting a screenshot updates the caption and counter', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const ProjectsSection()));
      await tester.pumpAndSettle();

      final shots = repository.projects.first.screenshots;
      expect(find.text(shots[0].caption), findsOneWidget);
      expect(find.text('01'), findsWidgets);

      // Advance with the "next" control.
      await tester.tap(find.byTooltip('Next screenshot'));
      await tester.pumpAndSettle();

      expect(find.text(shots[1].caption), findsOneWidget);
    });
  });
}
