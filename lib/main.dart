import 'package:achieveclubmobileclient/authenticationpage.dart';
import 'package:flutter/material.dart';
String appTitle = "Профиль";
String email = '';
String password = '';
String firstName = '';
String lastName = '';
String avatarPath = '';
int clubId = 0;
String Avatar = "";
String baseURL = 'https://sskef.site/api/';
var userId;
var token;
var savedCookies;

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
                        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(
                            11, 106, 108, 1.0)),
                            useMaterial3: true,
                            fontFamily: 'Exo2',
                      ),
                      darkTheme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(
                              11, 106, 108, 1.0), brightness: Brightness.dark),
                          useMaterial3: true,
                          fontFamily: 'Exo2',
                      ),
                    home: const AuthenticationPage(),
          ),
        );
    }
}
