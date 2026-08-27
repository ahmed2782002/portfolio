import 'package:flutter/material.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore the visitor's theme before the first frame so the page never
  // flashes the wrong palette.
  final themeController = await ThemeController.restore();

  runApp(PortfolioApp(themeController: themeController));
}
