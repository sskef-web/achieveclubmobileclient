import 'package:achieveclubmobileclient/main.dart';
import 'package:achieveclubmobileclient/registerpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function() loginCallback;
  final Function() registerCallback;
  final Function(String) updateEmail;
  final Function(String) updatePassword;
  final Function(String) updateFirstName;
  final Function(String) updateLastName;
  final Function(int) updateClubId;
  final Function(BuildContext) uploadAvatar;

  const LoginPage({
    super.key,
    required this.loginCallback,
    required this.registerCallback,
    required this.updateEmail,
    required this.updatePassword,
    required this.updateFirstName,
    required this.updateLastName,
    required this.updateClubId,
    required this.uploadAvatar,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isPasswordHidden = true;
  IconData passIcon = Icons.visibility;
  final _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;

  void navigateToRegisterPage(BuildContext context) {
    email = '';
    password = '';
    firstName = '';
    lastName = '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegisterPage(
              registerCallback: widget.registerCallback,
              updateEmail: widget.updateEmail,
              updatePassword: widget.updatePassword,
              updateFirstName: widget.updateFirstName,
              updateLastName: widget.updateLastName,
              updateClubId: widget.updateClubId,
              uploadAvatar: widget.uploadAvatar,
            ),
      ),
    );
  }

  void updatePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
      switch (passIcon) {
        case Icons.visibility_off:
          passIcon = Icons.visibility;
          break;
        case Icons.visibility:
          passIcon = Icons.visibility_off;
          break;
      }
    });
  }

  bool _isPasswordValid(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                setState(() {
                  isButtonEnabled = _formKey.currentState?.validate() ?? false;
                });
              },
              child: Column(
                children: [
                  TextFormField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: email,
                        selection: TextSelection.collapsed(
                            offset: email.length),
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: email.isNotEmpty && !EmailValidator.validate(email)
                          ? 'Некорректный адрес электронной почты'
                          : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    onChanged: (value) {
                      widget.updateEmail(value);
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email обязателен для заполнения';
                      }
                      if (!EmailValidator.validate(value!)) {
                        return 'Почта должна быть валидной';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    //controller: _passwordController,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: password,
                        selection: TextSelection.collapsed(
                            offset: password.length),
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      suffixIcon: IconButton(
                        icon: Icon(passIcon),
                        onPressed: () {
                          updatePasswordVisibility();
                        },
                      ),
                      errorText: password.isNotEmpty && (password.length < 6 || !_isPasswordValid(password))
                          ? 'Пароль должен содержать не менее 6 символов и \nкак минимум 1 букву или 1 цифру'
                          : null,
                    ),
                    obscureText: isPasswordHidden,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    onChanged: (value) {
                      widget.updatePassword(value);
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Пароль обязателен для заполнения';
                      }
                      if (value!.length < 6 || !_isPasswordValid(value)) {
                        return 'Пароль должен содержать не менее 6 символов и \nкак минимум 1 букву или 1 цифру';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: (_formKey.currentState?.validate() ?? false) && clubId != 0
                  ? () {
                widget.loginCallback();
              }
                  : null,
              child: const Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Войти',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                navigateToRegisterPage(context);
              },
              child: const Text(
                  'Зарегистрироваться', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}