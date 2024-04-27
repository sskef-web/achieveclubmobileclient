import 'package:achieveclubmobileclient/homepage.dart';
import 'package:achieveclubmobileclient/loginpage.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  void _login() async {
    // Здесь можно добавить логику для проверки введенных данных и выполнения входа в систему
    // Проверка может быть выполнена с помощью сервера или локально

    // Пример успешного входа в систему
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    setState(() {
      _isLoggedIn = true;
    });
  }

  void _register() async {
    // Здесь можно добавить логику для регистрации нового пользователя
    // Регистрация может быть выполнена с помощью сервера или локально

    // Пример успешной регистрации
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    setState(() {
      _isLoggedIn = true;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    setState(() {
      _isLoggedIn = false;
    });
  }

  void _updateUserId(String value) {
    setState(() {
      userId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return HomePage(logoutCallback: _logout);
    } else {
      return LoginPage(loginCallback: _login, registerCallback: _register, updateUserId: _updateUserId);
    }
  }
}