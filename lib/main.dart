import 'dart:convert';
import 'dart:io';
import 'package:achieveclubmobileclient/authenticationpage.dart';
import 'package:achieveclubmobileclient/homepage.dart';
import 'package:achieveclubmobileclient/loginpage.dart';
import 'package:achieveclubmobileclient/tab1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
String appTitle = "Профиль";
String userId = '149';
String Avatar = "";
String baseURL = 'https://sskef.site/';

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
