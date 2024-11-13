import 'dart:convert';
import '../data/loginresponse.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';
import 'loginPage.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



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
  String avatarPath = 'avatars/9e318d73-c569-424c-8ea8-f5e34b7d67c7.jpeg';
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
    debugPrint('LOAD COOKIES - ${prefs.getString('proofCode')}');
    return prefs.getString('cookies');
  }

  Future<String?> loadProofCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('LOAD PROOF-CODE - ${prefs.getString('proofCode')}');
    return prefs.getString('proofCode');
  }

  Future<void> _changePassword(String email, String password) async {
    var newProofCode = await loadProofCode();
    var url = Uri.parse('${baseURL}api/auth/change_password');
    var body = jsonEncode(
        {
          'emailAddress': email,
          'proofCode': newProofCode,
          'password': password
        });
    debugPrint("${jsonDecode(body)}");
    
    var response = await http.patch(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      debugPrint('Password changed. Status Code: ${response.statusCode}');
      throw AlertDialog(
        content: Text('Пароль изменен.', textAlign: TextAlign.center, ),
      );
    }
    else {
      debugPrint('Failed to change password\n ${response.body}. \nStatus Code: ${response.statusCode}');
      throw response.body;
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    var url = Uri.parse('${baseURL}api/auth/login');
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
        debugPrint(responseJson.toString());
        throw showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.error),
              content: Text(AppLocalizations.of(context)!.emailPassError),
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
        debugPrint(responseJson);
        throw showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.error),
              content: Text('${AppLocalizations.of(context)!.loginError}:\n$emailError\n$passError'),
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
      String firstName, String lastName, String avatarPath, var proofCode) async {
    var url = Uri.parse('${baseURL}api/auth/registration?api-version:1.0');

    var body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'clubId': 1,
      'password': password,
      'avatarURL': avatarPath,
      'emailAddress': email,
      'proofCode': proofCode
    });
    debugPrint('====== REG DATA ======\n$firstName\n$lastName\n$clubId\n$email\n$proofCode\n$password\n$avatarPath\n====== REG DATA ======');
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
      debugPrint('Failed registration. Status code: ${response.statusCode}. Body: ${response.body}');
      throw AlertDialog(
        content: Text('Ошибка в поле ${response.body}'),
      );
    }
  }

  void changePassword() async {
    debugPrint('EMAIL: $email | PASSWORD: $password');
    _changePassword(email, password);
  }

  void _login() async {
    if (email == '' || password == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(AppLocalizations.of(context)!.emptyFields),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      setState(() {
        appTitle = AppLocalizations.of(context)!.profil;
        _isLoggedIn = true;
      });
    }
  }

  void _register() async {
      Navigator.pop(context, true);
      var proofCode = await loadProofCode();

      await registrate(email, password, firstName, lastName, avatarPath, proofCode);
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
    email = '';
    password = '';
    setState(() {
      _isLoggedIn = false;
      appTitle = AppLocalizations.of(context)!.authorization;
    });
  }

  void _updateEmail(String value) {
    setState(() {
      email = value;
      debugPrint('NEW EMAIL: $email');
    });
  }

  void _updatePassword(String value) {
    setState(() {
      password = value;
      debugPrint('NEW PASS: $password');
    });
  }

  void _updateFirstName(String value) {
    setState(() {
      firstName = value;
      debugPrint('NEW FIRSTNAME: $firstName');
    });
  }

  void _updateProofCode(String value) {
    setState(() {
      proofCode = value;
      debugPrint('NEW PROOFCODE: $proofCode');
    });
  }

  void _updateLastName(String value) {
    setState(() {
      lastName = value;
      debugPrint('NEW LASTNAME: $lastName');
    });
  }

  void _updateClubId(int value) {
    setState(() {
      clubId = value;
      debugPrint('NEW CLUB ID: $clubId');
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
          debugPrint('Error uploading avatar. Status Code: ${response.statusCode}');
        }
      } catch (error) {
        debugPrint('Erorr uploading avatar: $error');
      }
    }
  }

  Widget _buildHomePage() {
    setState(() {
      appTitle = AppLocalizations.of(context)!.tab1;
    });
    return HomePage(
      logoutCallback: _logout,
    );
  }

    @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return _buildHomePage();
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
