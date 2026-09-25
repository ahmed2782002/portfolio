import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/di/app_scope.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/theme/theme_controller.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/features/home/view/home_page.dart';

Widget app() => AppScope(
  repository: const PortfolioRepository(),
  themeController: ThemeController(mode: ThemeMode.light),
  child: MaterialApp(theme: AppTheme.light(), home: const HomePage()),
);

Future<void> setSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('desktop page builds and scrolls to the bottom', (tester) async {
    await setSize(tester, const Size(1440, 900));
    await tester.pumpWidget(app());
    await tester.pump(const Duration(seconds: 2));

    await tester.fling(
      find.byType(SingleChildScrollView),
      const Offset(0, -20000),
      8000,
    );
    // The hero drift loops forever, so settle by time rather than pumpAndSettle.
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('Back to top'), findsOneWidget);
  });

  testWidgets('mobile menu opens and navigates', (tester) async {
    await setSize(tester, const Size(390, 844));
    await tester.pumpWidget(app());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byTooltip('Close menu'), findsOneWidget);

    await tester.tap(find.text('Contact').last);
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byTooltip('Close menu'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
