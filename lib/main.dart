import 'package:achieveclubmobileclient/pages/authenticationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'data/language_provider.dart';

String appTitle = "";
String baseURL = 'https://achieveclub-ekdpajekhkd0amct.polandcentral-01.azurewebsites.net/api/';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (_, languageProvider, __) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', ''), // Русский
              Locale('pl', ''), // Польский
              Locale('en', '') // Английский
            ],
            locale: languageProvider.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromRGBO(11, 106, 108, 1.0)),
              useMaterial3: true,
              fontFamily: 'Exo2',
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromRGBO(11, 106, 108, 1.0),
                  brightness: Brightness.dark),
              useMaterial3: true,
              fontFamily: 'Exo2',
            ),
            home: const AuthenticationPage(),
          );
        },
      ),
    );
  }
}
