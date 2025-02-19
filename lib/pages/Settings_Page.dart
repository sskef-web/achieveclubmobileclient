import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/User.dart';
import '../items/Four_Digit_Code_Input.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Home_Page.dart';

class SettingsPage extends StatefulWidget {
  String avatar;

  SettingsPage({super.key, required this.avatar});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var userId;
  late Future<User> _userFuture;
  String email = '';
  String username = '';
  String proofCode = '';

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
  }

  void _updateProofCode(String value) {
    setState(() {
      proofCode = value;
    });
    saveProofCode();
    debugPrint('NEW proof-code - ${proofCode}');
  }

  Future<bool> saveProofCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('proofCode', proofCode);
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
    var url = Uri.parse('${baseURL}api/users/current');
    debugPrint(url.toString());
    debugPrint(Localizations.localeOf(context).languageCode);
    debugPrint('Access Token - ${extractTokenFromCookies(cookies)}');

    var response = await http
        .get(url, headers: {'Cookie': cookies, 'Accept-Language': 'RU'});
    debugPrint('${response.statusCode}');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      return fetchUser();
    } else {
      throw Exception(AppLocalizations.of(context)!.fetchUserError);
    }
  }

  Future<void> changeEmail(String email, var proofCode) async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);
    var url = Uri.parse('${baseURL}api/users/change_email');

    var body = jsonEncode({
      'proofCode': proofCode,
      'emailAddress': email,
    });
    var response = await http.patch(url, body: body, headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    if (response.statusCode == 204) {
      Navigator.pop(context);

    } else {
      debugPrint('${response.body}, Status code: ${response.statusCode}');
      throw showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Ошибка: ${response.body}'),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Закрыть'))
          ],
        );
      });
    }
  }

  Future<void> changeUsername(String firstname, String lastName) async {
    var cookies = await loadCookies();
    var url = Uri.parse('${baseURL}api/users/change_name');

    var body;

    if (firstname.isNotEmpty) {
      body = jsonEncode({
        'firstName': firstname,
      });
    }
    else {
      body = jsonEncode({
        'lastName': lastName,
      });
    }

    var response = await http.patch(url, body: body, headers: {
      'Content-Type': 'application/json',
      'Cookie': cookies!
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);

    } else {
      debugPrint('Ошибка при смене имени или фамилии - ${response.body}. SC - ${response.statusCode}');
      throw AlertDialog(
        content: Text('Ошибка: ${response.body}'),
      );
    }
  }

  void _showFirstConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Color.fromRGBO(38, 38, 38, 1)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Вы уверены, что хотите удалить аккаунт?',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showSecondConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Color.fromRGBO(38, 38, 38, 1)
                              : Colors.white,
                      side: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Удалить',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500),
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Color.fromRGBO(38, 38, 38, 1)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Восстановить аккаунт будет невозможно после удаления',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Действие при нажатии на "Удалить"
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Color.fromRGBO(38, 38, 38, 1)
                              : Colors.white,
                      side: BorderSide(color: Color.fromRGBO(245, 110, 15, 1)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Удалить',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500),
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

  void showProofCodeDialog(BuildContext context, String email) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.confirmEmail,
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(1.2),
                ),
                Text(
                  '${AppLocalizations.of(context)!.codeSended} - \n$email',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                FourDigitCodeInput(updateProofCode: _updateProofCode),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: proofCode != 4
                      ? () {
                    Navigator.of(dialogContext).pop();
                    changeEmail(email, proofCode);
                  }
                      : null,
                  child: Text(AppLocalizations.of(context)!.send),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendProofCode(String email) async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);
    var url = Uri.parse('${baseURL}api/email/change_email');

    var body = jsonEncode(
      email,
    );

    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    if (response.statusCode == 204) {
      debugPrint('code send to $email');
      showProofCodeDialog(context, email);
    }
    else if (response.statusCode == 409) {
      debugPrint('${response.body}, Status code: ${response.statusCode}');
      if (response.body.contains('email')) {
        showEmailErrorDialog(context);
      }
      else {
        debugPrint('${response.body}, Status code: ${response.statusCode}');
        showResultDialog(context, true, true);
      }
    }
    else {
      showResultDialog(context, true, true);
      debugPrint('${response.body}, Status code: ${response.statusCode}');
      throw response.body;
    }
  }

  void showEmailErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ошибка \n Пользователь с таким email уже зарегистрирован.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.close)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showResultDialog(BuildContext context, bool isValidate,
      bool isCodeSended) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isCodeSended
                    ? Text(
                  '${AppLocalizations.of(context)!.error}\n${AppLocalizations
                      .of(context)!.codeSendedAfter}',
                  textAlign: TextAlign.center,
                )
                    : isValidate != false
                    ? Text(
                  AppLocalizations.of(context)!.emailConfirmed,
                  textAlign: TextAlign.center,
                )
                    : Text(
                    '${AppLocalizations.of(context)!.error}!\n${AppLocalizations
                        .of(context)!.wrongCode}',
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 8.0,
                    ),
                    isCodeSended
                        ? Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            showProofCodeDialog(context, email);
                          },
                          child: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.writeCode)),
                        ),
                        const SizedBox(width: 8.0,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.close)),
                        )
                      ],
                    )
                        : isValidate == false
                        ? ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        showProofCodeDialog(context, email);
                      },
                      child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.repeat)),
                    )
                        : ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (isValidate == true) {
                          saveProofCode();
                          changeEmail(email, proofCode);
                        }
                      },
                      child: Center(
                          child: Text(AppLocalizations.of(context)!
                              .continued)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            child: Icon(
              Icons.settings,
              color: Color.fromRGBO(245, 110, 15, 1),
            ),
          )
        ],
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
                          backgroundImage: CachedNetworkImageProvider(
                              '$baseURL/${widget.avatar}'),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Color.fromRGBO(27, 26, 31, 0.7)
                                    : Color(0x99DEDEDE)),
                            child: IconButton(
                                onPressed: () {
                                  _uploadAvatar(context);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Color.fromRGBO(245, 110, 15, 1),
                                  size: 32,
                                )),
                          ))),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromRGBO(38, 38, 38, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Изменить Имя',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        '${user.firstName}',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onTap: () {
                        final TextEditingController usernameController = TextEditingController();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Color.fromRGBO(38, 38, 38, 1)
                                      : Colors.white,
                                ),
                                height: 240,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 11),
                                            child: Text(
                                              textAlign: TextAlign.left,
                                              'Имя',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          IconButton(
                                            style: IconButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    91, 91, 91, 1)),
                                            icon: Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          hintText:
                                              '${user.firstName}',
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    245, 110, 15, 1)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    245, 110, 15, 1)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final username = usernameController.text;
                                            if (username.length >= 1) {
                                              changeUsername(usernameController.text, '');
                                              Navigator.pop(context);
                                            } else {
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Ошибка изменения'),
                                                    content: const Text(
                                                      'Вы указали слишком короткое Имя и Фамилию.',
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                                        child: const Text('Закрыть'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                Color.fromRGBO(245, 110, 15, 1),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 20),
                                            textStyle: TextStyle(fontSize: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: Text(
                                            'Сохранить',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromRGBO(38, 38, 38, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Изменить Фамилию',
                        style: TextStyle(
                            color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        '${user.lastName}',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onTap: () {
                        final TextEditingController usernameController = TextEditingController();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? Color.fromRGBO(38, 38, 38, 1)
                                      : Colors.white,
                                ),
                                height: 240,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 11),
                                            child: Text(
                                              textAlign: TextAlign.left,
                                              'Фамилия',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .brightness ==
                                                      Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          IconButton(
                                            style: IconButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    91, 91, 91, 1)),
                                            icon: Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          hintText:
                                          '${user.lastName}',
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    245, 110, 15, 1)),
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    245, 110, 15, 1)),
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                        ),
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final username = usernameController.text;
                                            if (username.length >= 1) {
                                              changeUsername('',usernameController.text);
                                              Navigator.pop(context);
                                            } else {
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Ошибка изменения'),
                                                    content: const Text(
                                                      'Вы указали слишком короткую Фамилию.',
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                                        child: const Text('Закрыть'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                            Color.fromRGBO(245, 110, 15, 1),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 20),
                                            textStyle: TextStyle(fontSize: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: Text(
                                            'Сохранить',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromRGBO(38, 38, 38, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Изменить почту',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        '${user.email}',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onTap: () {
                        final TextEditingController emailController = TextEditingController();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Color.fromRGBO(38, 38, 38, 1)
                                      : Colors.white,
                                ),
                                height: 240,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 11),
                                            child: Text(
                                              textAlign: TextAlign.left,
                                              'Почта',
                                              style: TextStyle(
                                                  color: Theme.of(context).brightness ==
                                                      Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          IconButton(
                                            style: IconButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(91, 91, 91, 1)),
                                            icon: Icon(Icons.close, color: Colors.white),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          hintText: '${user.email}',
                                          errorText: emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text)
                                              ? AppLocalizations.of(context)!.emailError
                                              : null,
                                          errorStyle: const TextStyle(color: Color(0xFFD7181D)),
                                          hintStyle: TextStyle(
                                              color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text)
                                                  ? const Color(0xFFD7181D)
                                                  : const Color.fromRGBO(245, 110, 15, 1),
                                            ),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xFFD7181D)),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xFFD7181D)),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: emailController.text.isNotEmpty && !EmailValidator.validate(emailController.text)
                                                  ? const Color(0xFFD7181D)
                                                  : const Color.fromRGBO(245, 110, 15, 1),
                                            ),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return AppLocalizations.of(context)!.emptyEmail;
                                          }
                                          if (!EmailValidator.validate(value!)) {
                                            return AppLocalizations.of(context)!.emailError;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          email = value;
                                        },
                                        style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final email = emailController.text;
                                            if (EmailValidator.validate(email)) {
                                              sendProofCode(emailController.text);
                                              Navigator.pop(context);
                                            } else {
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Ошибка смены почты'),
                                                    content: const Text(
                                                      'Указанная почта не валидна.',
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                                        child: const Text('Закрыть'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 20),
                                            textStyle: TextStyle(fontSize: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: Text(
                                            'Сохранить',
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w500),
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
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Color.fromRGBO(27, 26, 31, 1)
                                : Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromRGBO(245, 110, 15, 1)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Удалить аккаунт',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.w500),
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
