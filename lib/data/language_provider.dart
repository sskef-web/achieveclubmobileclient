import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('pl');

  Locale get locale => _locale;

  void changeLanguage(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}