import 'package:achieveclubmobileclient/pages/authenticationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String appTitle = "Autoryzacja";
String baseURL = 'https://sskef.site/api/';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('pl'),
      supportedLocales: [
        const Locale('ru'),
        const Locale('pl'),
      ],
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
  }
}
