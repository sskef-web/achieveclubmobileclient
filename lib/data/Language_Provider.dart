import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  void changeLanguage(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}