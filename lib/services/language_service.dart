import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:stacked/stacked.dart';

class LanguageService extends BaseViewModel {
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  Locale get currentLocale => _context?.locale ?? const Locale('en', 'US');

  void changeLanguage(String languageCode, String countryCode) {
    if (_context != null) {
      _context!.setLocale(Locale(languageCode, countryCode));
      notifyListeners();
    }
  }
}
