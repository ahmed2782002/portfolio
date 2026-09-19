import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the light/dark selection and persists it (localStorage on web).
///
/// Starts in [ThemeMode.system] so a first-time visitor gets the theme their OS
/// already asked for; an explicit toggle pins the choice and survives reloads.
class ThemeController extends ChangeNotifier {
  ThemeController._(this._mode);

  static const String _storageKey = 'portfolio.theme_mode';

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  /// Restores the persisted choice. Never throws — a failure here must not stop
  /// the site from rendering.
  static Future<ThemeController> restore() async {
    var mode = ThemeMode.light;
    try {
      final prefs = await SharedPreferences.getInstance();
      mode = _decode(prefs.getString(_storageKey));
    } catch (error, stack) {
      debugPrint('ThemeController: could not restore theme — $error\n$stack');
    }
    return ThemeController._(mode);
  }

  /// Resolves [ThemeMode.system] against the platform so the toggle always
  /// flips to the *visible* opposite.
  bool isDark(BuildContext context) => switch (_mode) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system =>
          MediaQuery.platformBrightnessOf(context) == Brightness.dark,
      };

  void toggle(BuildContext context) =>
      _set(isDark(context) ? ThemeMode.light : ThemeMode.dark);

  void _set(ThemeMode next) {
    if (_mode == next) return;
    _mode = next;
    notifyListeners();
    _persist(next);
  }

  Future<void> _persist(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, mode.name);
    } catch (error) {
      debugPrint('ThemeController: could not persist theme — $error');
    }
  }

  static ThemeMode _decode(String? raw) => switch (raw) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };
}
