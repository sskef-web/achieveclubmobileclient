import 'pages/authenticationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'data/language_provider.dart';

String appTitle = "";
String baseURL = 'https://achieve.by:5001/';

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
              colorScheme: ColorScheme.light(
                  primary: Color.fromRGBO(245, 110, 15, 1),
                  onError: Color.fromRGBO(251, 251, 251, 1),
                  surface: Color.fromRGBO(251, 251, 251, 1),
                  brightness: Brightness.light
              ),
              useMaterial3: true,
              fontFamily: 'Exo2',
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.dark(
                primary: Color.fromRGBO(245, 110, 15, 1),
                  onError: Colors.white,
                  surface: Color.fromRGBO(27, 26, 31, 1),
                brightness: Brightness.dark
              ),
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
