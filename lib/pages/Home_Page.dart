import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/User.dart';
import '../items/Settings_Button.dart';
import '../main.dart';
import '../tabItems/Profile_Tab.dart';
import '../tabItems/Top_Users_Tab.dart';
import 'package:flutter/material.dart';

import '../tabItems/Shop_Tab.dart';
import '../tabItems/About_Tab.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final Function() logoutCallback;

  const HomePage({super.key, required this.logoutCallback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String appTitle = 'Профиль';

  int _currentIndex = 0;

  late List<Widget> _tabs;
  String locale = "";
  var userId;

  late Future<User> _userFuture;

  @override
  void initState(){
    super.initState();
    _userFuture = fetchUser();
  }

  String? extractUserIdFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-User-Id')) {
        var userId = cookie.split('=')[1];
        return userId;
      }
    }
    return null;
  }


  Future<User> fetchUser() async {
    var cookies = await loadCookies();
    userId = extractUserIdFromCookies(cookies!);
    var url = Uri.parse('${baseURL}api/users/${userId}');
    debugPrint(url.toString());
    debugPrint('Cookies - $cookies');
    debugPrint(Localizations.localeOf(context).languageCode);

    var response = await http.get(url,
        headers: {'Cookie': cookies, 'Accept-Language': 'RU'});
    debugPrint('${response.statusCode}');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      return fetchUser();
    } else {
      throw Exception(AppLocalizations.of(context)!.fetchUserError);
    }
  }

  Future<String?> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }

  String? extractTokenFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-Access-Token')) {
        var token = cookie.split('=')[1];
        return token;
      }
    }
    return null;
  }

  Future<void> fetchUserBalance() async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);
    var url = Uri.parse('${baseURL}api/balance');

    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    debugPrint('${response.statusCode}');

    if (response.statusCode == 200) {
      return setState(() {
        appTitle = 'Баланс: ${jsonDecode(response.body).toString()}xp';
      });
    }
    else if (response.statusCode == 401) {
      return fetchUserBalance();
    }
    else {
      throw Exception('Fetch user balance error!');
    }
  }

  @override
  Widget build(BuildContext context) {
    locale = Localizations.localeOf(context).languageCode;
    _tabs = [
      Tab1Page(logoutCallback: widget.logoutCallback, locale: locale,),
      Tab2Page(logoutCallback: widget.logoutCallback,),
      Tab3Page(),
      Tab4Page(),
    ];
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(alignment: Alignment.center,width: 48,height: 48, child: CircularProgressIndicator(), decoration: BoxDecoration(color: Color.fromRGBO(27, 26, 31, 1)),);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data');
        } else {
          User user = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text(
                appTitle,
                textAlign: TextAlign.center,
              ),
              leading: IconButton(
                iconSize: 32.0,
                icon: Transform.rotate(
                  angle: 3.14,
                  child: const Icon(Icons.logout),
                ),
                onPressed: () {
                  widget.logoutCallback();
                },
              ),
              actions: [
                _currentIndex == 0 ? SettingsButton(user: user,) : SizedBox(height: 0, width: 0,)
              ],
            ),
            body: _tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: true,
              selectedItemColor: Color(0xFFF56E0F),
              unselectedItemColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  switch (_currentIndex) {
                    case 0:
                      appTitle = 'Профиль';
                      break;
                    case 1:
                      appTitle = 'Топ 100';
                      break;
                    case 2:
                      fetchUserBalance();
                      break;
                    case 3:
                      appTitle = 'О приложении';
                      break;
                  }
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: 'Профиль',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.groups),
                  label: 'Топ 100',
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.shopify),
                    label: 'Магазин'
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.info),
                    label: 'О приложении'
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
