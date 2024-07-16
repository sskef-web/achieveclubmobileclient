import 'package:achieveclubmobileclient/pages/authenticationPage.dart';
import 'package:flutter/material.dart';

String appTitle = "Autoryzacja";
String baseURL = 'https://sskef.site/api/';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        title: appTitle,
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
      ),
    );
  }
}
