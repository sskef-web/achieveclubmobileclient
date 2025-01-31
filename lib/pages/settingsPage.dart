import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/user.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key,});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var userId;

  Future<String?> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
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

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        centerTitle: true,
        actions: [Icon(Icons.settings, color: Color.fromRGBO(245, 110, 15, 1),)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundColor: Color.fromRGBO(245, 110, 15, 1),
              child: CircleAvatar(
                  radius: 67,
                  backgroundImage: NetworkImage('https://i1.sndcdn.com/avatars-000622840725-lun48d-t240x240.jpg'),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                      color: Color.fromRGBO(27, 26, 31, 0.7)
                    ),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: Color.fromRGBO(245, 110, 15, 1), size: 32,)
                    ),
                  )
              )
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(38, 38, 38, 1),
                borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  'Изменить Имя и Фамилию',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  'Зубенко Михаил Петрович',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          color: Color.fromRGBO(38, 38, 38, 1),
                        ),
                        height: 230,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 11),
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      'Имя Фамилия',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(91, 91, 91, 1)
                                    ),
                                    icon: Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 16,),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Имя Фамилия',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                    textStyle: TextStyle(fontSize: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Сохранить',
                                    style: TextStyle(color: Colors.white,  fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(38, 38, 38, 1),
                  borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  'Изменить почту',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  'zybenkoMixailPetrovich@gmail.com',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                onTap: () {
                  // Действие при нажатии
                },
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent,
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Действие при нажатии
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(27, 26, 31, 1),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Удалить аккаунт',
                  style: TextStyle(
                      color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
