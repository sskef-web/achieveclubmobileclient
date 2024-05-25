import 'dart:convert';
import 'package:achieveclubmobileclient/data/loginresponse.dart';
import 'package:http/http.dart' as http;
import 'package:achieveclubmobileclient/pages/homePage.dart';
import 'package:achieveclubmobileclient/pages/loginPage.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isLoggedIn = false;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String firstName = '';
  String lastName = '';
  String avatarPath = 'StaticFiles/avatars/38c7301d-b794-44b4-935b-aeb70527b1a5.jpeg';
  int clubId = 0;
  var userId;
  var token;
  var refreshToken;
  var savedCookies;
  String proofCode = '';

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

  String? extractRefreshTokenFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-Refresh-Token')) {
        var token = cookie.split('=')[1];
        return token;
      }
    }
    return null;
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

  Future<void> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookies', cookies);
  }

  Future<String?> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }

  Future<void> _changePassword(String email, String password) async {
    var url = Uri.parse('${baseURL}auth/ChangePassword');

    var body = jsonEncode({
    'emailAndProof': {
    'emailAddress': email,
    'proofCode': proofCode
    },
      'password': password
    });
    var response = await http.patch(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw response.body;
    }
    else {

    }
  }

  Future<LoginResponse> login(String email, String password) async {
    var url = Uri.parse('${baseURL}auth/login');
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      var cookies = response.headers['set-cookie'];
      await saveCookies(cookies!);
      token = extractTokenFromCookies(cookies);
      userId = extractUserIdFromCookies(cookies);
      refreshToken = extractRefreshTokenFromCookies(cookies);
      return LoginResponse(token, userId, refreshToken, response.body);
    } else {
      final responseJson = jsonDecode(response.body);
      if (responseJson['title'] == 'Bad Request') {
        throw showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Почта или пароль указаны не верно.'),
              actions: [
                TextButton(
                  child: const Text('ОК'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        String emailError = '${responseJson['errors']['Email']}';
        String passError = '${responseJson['errors']['Password']}';
        //throw Exception('Failed to login: ${response.statusCode}');
        print(responseJson);
        throw showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: Text('Не удалось войти:\n$emailError\n$passError'),
              actions: [
                TextButton(
                  child: const Text('ОК'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<LoginResponse> registrate(String email, String password,
      String firstName, String lastName, String avatarPath, int clubId, String proofCode) async {
    var url = Uri.parse('${baseURL}auth/registration');

    var body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'clubId': clubId,
      'password': password,
      'avatarURL': avatarPath,
      'emailAndProof': {
        'emailAddress': email,
        'proofCode': '1111'
      },
    });
    debugPrint('====== REG DATA ======\n$firstName\n$lastName\n$clubId\n$email\n$proofCode\n$password\n$avatarPath\n====== REG DATA ======');
    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      var cookies = response.headers['set-cookie'];
      await saveCookies(cookies!);
      var token = extractTokenFromCookies(cookies);
      var userId = extractUserIdFromCookies(cookies);
      var refreshToken = extractRefreshTokenFromCookies(cookies);
      return LoginResponse(token!, userId!, refreshToken!, response.body);
    } else {
      throw response.body;
    }
  }

  void changePassword() async {
    debugPrint('EMAIL: ${email} | PASSWORD: ${password}');
    _changePassword(email, password);
  }

  void _login() async {
    if (email == '' || password == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Пожалуйста, заполните все поля'),
            actions: [
              TextButton(
                child: const Text('ОК'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      await login(email, password);
      savedCookies = await loadCookies();
      //print('${savedCookies}');

      //password = HashService.generateHash(password,  );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      setState(() {
        appTitle = 'Профиль';
        _isLoggedIn = true;
      });
    }
  }

  void _register() async {

      Navigator.pop(context, true);
      await registrate(
          email, password, firstName, lastName, avatarPath, clubId, proofCode);
      savedCookies = await loadCookies();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      setState(() {
        _isLoggedIn = true;
      });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    email = '';
    password = '';
    setState(() {
      appTitle = 'Авторизация';
    });
  }

  void _updateEmail(String value) {
    setState(() {
      email = value;
      print('NEW EMAIL: $email');
    });
  }

  void _updatePassword(String value) {
    setState(() {
      password = value;
      print('NEW PASS: $password');
    });
  }

  void _updateFirstName(String value) {
    setState(() {
      firstName = value;
      print('NEW FIRSTNAME: $firstName');
    });
  }

  void _updateProofCode(String value) {
    setState(() {
      proofCode = value;
      print('NEW PROOFCODE: $proofCode');
    });
  }

  void _updateLastName(String value) {
    setState(() {
      lastName = value;
      print('NEW LASTNAME: $lastName');
    });
  }

  void _updateClubId(int value) {
    setState(() {
      clubId = value;
      print('NEW CLUB ID: $clubId');
    });
  }

  void _uploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    var cookies = await loadCookies();

    if (pickedImage != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseURL}avatar'),
      );
      request.headers['Cookie'] = cookies!;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          pickedImage.path,
        ),
      );

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var imageUrl = response.body;

          setState(() {
            avatarPath = imageUrl;
          });
        } else {
          print('Error uploading avatar. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error uploading avatar: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return HomePage(logoutCallback: _logout);
    } else {
      return LoginPage(
        key: widget.key,
        loginCallback: _login,
        registerCallback: _register,
        updateEmail: _updateEmail,
        changePassword: changePassword,
        updatePassword: _updatePassword,
        updateFirstName: _updateFirstName,
        updateLastName: _updateLastName,
        updateProofCode: _updateProofCode,
        updateClubId: _updateClubId,
        uploadAvatar: _uploadAvatar,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        proofCode: proofCode,
      );
    }
  }
}
