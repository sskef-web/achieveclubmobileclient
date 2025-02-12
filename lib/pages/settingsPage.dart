import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/user.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'homePage.dart';

class SettingsPage extends StatefulWidget {

  String avatar;

  SettingsPage({super.key, required this.avatar});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var userId;
  late Future<User> _userFuture;

  @override
  void initState(){
    super.initState();
    _userFuture = fetchUser();
  }

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
    debugPrint('Access Token - ${extractTokenFromCookies(cookies)}');

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

  void _showFirstConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Вы уверены, что хотите удалить аккаунт?',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    fontSize: 18
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showSecondConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
                      side: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Удалить',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSecondConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Восстановить аккаунт будет невозможно после удаления',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    fontSize: 18
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Действие при нажатии на "Удалить"
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
                      side: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Удалить',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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

  void _uploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);

    if (pickedImage != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseURL}api/avatar'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          pickedImage.path,
        ),
      );
      
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

      try {
        debugPrint("Avatar request - ${request}");
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          debugPrint('Avatar request - Status Code 200');
          var imageUrl = response.body;

          setState(() {
            widget.avatar = imageUrl;
          });
        } else {
          throw Exception(
              '${AppLocalizations.of(context)!.uploadAvatarError}. Code: ${response.statusCode} \n ${response.headers} \n ${response.body}');
        }
      } catch (error) {
        throw Exception(
            '${AppLocalizations.of(context)!.uploadAvatarError}: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        centerTitle: true,
        actions: [Icon(Icons.settings, color: Color.fromRGBO(245, 110, 15, 1),)],
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          } else {
            final user = snapshot.data as User;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      radius: 70,
                      backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                      child: CircleAvatar(
                          radius: 67,
                          backgroundImage: CachedNetworkImageProvider('$baseURL/${widget.avatar}'),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(27, 26, 31, 0.7) : Color(0x99DEDEDE)
                            ),
                            child: IconButton(
                                onPressed: () {
                                  _uploadAvatar(context);
                                },
                                icon: Icon(Icons.edit, color: Color.fromRGBO(245, 110, 15, 1), size: 32,)
                            ),
                          )
                      )
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Изменить Имя и Фамилию',
                        style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontSize: 18
                        ),
                      ),
                      subtitle: Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                  color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
                                ),
                                height: 240,
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
                                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
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
                                          hintText: '${user.firstName} ${user.lastName}',
                                          hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                                        ),
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
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Изменить почту',
                        style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontSize: 18
                        ),
                      ),
                      subtitle: Text(
                        'example@mail.com',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14
                        ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                  color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Colors.white,
                                ),
                                height: 240,
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
                                              'Почта',
                                              style: TextStyle(
                                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
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
                                          hintText: 'example@mail.com',
                                          hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                                        ),
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
                              ),
                            );
                          },
                        );
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
                        _showFirstConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(27, 26, 31, 1) : Colors.white,
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
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
