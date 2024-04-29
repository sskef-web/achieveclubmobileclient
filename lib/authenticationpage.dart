import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:achieveclubmobileclient/homepage.dart';
import 'package:achieveclubmobileclient/loginpage.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginResponse {
  String token;
  String userId;

  LoginResponse(this.token, this.userId);
}

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
      var token = extractTokenFromCookies(cookies);
      var userId = extractUserIdFromCookies(cookies);
      return LoginResponse(token!, userId!);
    }
    else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<LoginResponse> registrate(String email, String password, String firstName, String lastName, String avatarPath, int clubId) async {
    var url = Uri.parse('${baseURL}auth/registration');
    var body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'clubId': clubId,
      'email': email,
      'password': password,
      'avatarURL': avatarPath,
    });

    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      var cookies = response.headers['set-cookie'];
      await saveCookies(cookies!);
      var token = extractTokenFromCookies(cookies);
      var userId = extractUserIdFromCookies(cookies);
      return LoginResponse(token!, userId!);
    }
    else {
      throw Exception('Failed to registrate: ${response.statusCode}');
    }
  }


  void _login() async {

    await login(email, password);
    savedCookies = await loadCookies();
    //print('${savedCookies}');

    //password = HashService.generateHash(password,  );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    setState(() {
      _isLoggedIn = true;
    });
  }

  void _register() async {
    Navigator.pop(context, true);

    await registrate(email, password, firstName, lastName, avatarPath, clubId);
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

    setState(() {
      _isLoggedIn = false;
    });
  }

  void _updateEmail(String value) {
    setState(() {
      email = value;
    });
  }

  void _updatePassword(String value) {
    setState(() {
      password = value;
    });
  }

  void _updateFirstName(String value) {
    setState(() {
      firstName = value;
    });
  }

  void _updateLastName(String value) {
    setState(() {
      lastName = value;
    });
  }

  void _updateClubId(int value) {
    setState(() {
      clubId = value;
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
          loginCallback: _login,
          registerCallback: _register,
          updateEmail: _updateEmail,
          updatePassword: _updatePassword,
          updateFirstName: _updateFirstName,
          updateLastName: _updateLastName,
          updateClubId: _updateClubId,
          uploadAvatar: _uploadAvatar,
      );
    }
  }
}