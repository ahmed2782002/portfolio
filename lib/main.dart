import 'package:flutter/material.dart';

import 'package:portfolio/app/app.dart';
import 'package:portfolio/core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore the visitor's theme before the first frame so the page never
  // flashes the wrong palette.
  final themeController = await ThemeController.restore();
  //1- new projects fixer and link apple and google
// new skills

 // firebase data upload

  runApp(PortfolioApp(themeController: themeController));
}
