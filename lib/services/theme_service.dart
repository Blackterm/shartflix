import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class ThemeService extends BaseViewModel {
  static final ThemeService _instance = ThemeService._internal();
  static const String _themeKey = 'theme_mode';

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  late SharedPreferences _prefs;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
