import 'dart:convert';
import 'package:achieveclubmobileclient/items/fourDigitCodeInput.dart';
import 'package:http/http.dart' as http;
import 'package:achieveclubmobileclient/main.dart';
import 'package:achieveclubmobileclient/pages/registerPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function() loginCallback;
  final Function() registerCallback;
  final Function() changePassword;
  final Function(String) updateEmail;
  final Function(String) updatePassword;
  final Function(String) updateFirstName;
  final Function(String) updateLastName;
  final Function(String) updateProofCode;
  final Function(int) updateClubId;
  final Function(BuildContext) uploadAvatar;
  String email;
  String password;
  String confirmPassword;
  String firstName;
  String lastName;
  String proofCode;

  LoginPage({
    super.key,
    required this.loginCallback,
    required this.registerCallback,
    required this.changePassword,
    required this.updateEmail,
    required this.updatePassword,
    required this.updateFirstName,
    required this.updateLastName,
    required this.updateProofCode,
    required this.updateClubId,
    required this.uploadAvatar,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    required this.proofCode
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isPasswordHidden = true;
  IconData passIcon = Icons.visibility;
  final _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  bool isEmailProofed = false;
  String password = '';
  String email = '';

  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegisterPage(
              key: widget.key,
              registerCallback: widget.registerCallback,
              updateEmail: widget.updateEmail,
              updatePassword: widget.updatePassword,
              updateFirstName: widget.updateFirstName,
              updateLastName: widget.updateLastName,
              updateClubId: widget.updateClubId,
              uploadAvatar: widget.uploadAvatar,
              email: widget.email,
              password: widget.password,
              firstName: widget.firstName,
              lastName: widget.lastName,
              confirmPassword: widget.confirmPassword,
              proofCode: widget.proofCode,
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

  void _updateProofCode(String value) {
    setState(() {
      widget.proofCode = value;
    });
    widget.updateProofCode(value);
    debugPrint(widget.proofCode);
  }
  void _updatePassword(String value) {
    setState(() {
      widget.password = value;
    });
    widget.updatePassword(value);
    debugPrint(widget.password);
  }

  void _updateEmail(String value) {
    widget.email = value;
    email = value;
    widget.updateEmail(value);
    debugPrint(widget.email);
  }

  Future<void> validateEmail(String email, String proofCode) async {
    var url = Uri.parse('${baseURL}auth/ValidateProofCode');

    var body = jsonEncode({
      'emailAddress': email,
      'proofCode': proofCode,
    });

    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      setState(() {
        isEmailProofed == true;
      });
      showResultDialog(context, true);
    }
    else {
      showResultDialog(context, false);
      throw response.body;
    }
  }

  void showChangePassword(BuildContext context) async {
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
                const Text ('Подтверждение адреса электронной почты', textAlign: TextAlign.center, textScaler: TextScaler.linear(1.2),),
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: email,
                      selection: TextSelection.collapsed(
                          offset: email.length),
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Введите свой email',
                    errorText: email.isNotEmpty && !EmailValidator.validate(email)
                        ? 'Некорректный адрес электронной почты'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      _updateEmail(value);
                      debugPrint(widget.email);
                    });
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
                const SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    debugPrint("\n\n\n\n${widget.email}\n\n\n\n");
                    sendProofCode(email);
                    showProofCodeDialog(context, email);
                  },
                  child: const Text('Отправить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> sendProofCode(String email) async {
    var url = Uri.parse('${baseURL}auth/SendProofCode');

    var body = jsonEncode(
      email,
    );

    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      debugPrint('code send to $email');
    }
    else {
      throw response.body;
    }
  }

  void showPasswordDialog(BuildContext context) async {
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
                const Text ('Введите новый пароль', textAlign: TextAlign.center, textScaler: TextScaler.linear(1.2),),
                const SizedBox(height: 16.0),
                TextFormField(
                  //controller: _passwordController,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: widget.password,
                      selection: TextSelection.collapsed(
                          offset: widget.password.length),
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
                    errorText: widget.password.isNotEmpty && (widget.password.length < 6 || !_isPasswordValid(widget.password))
                        ? 'Пароль должен содержать не менее 6 символов и \nкак минимум 1 букву или 1 цифру'
                        : null,
                  ),
                  obscureText: isPasswordHidden,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      _updatePassword(value);
                      debugPrint(widget.password);
                    });
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
                const SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    widget.changePassword();
                  },
                  child: const Text('Отправить'),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                const Text ('Подтверждение адреса электронной почты', textAlign: TextAlign.center, textScaler: TextScaler.linear(1.2),),
                Text ('Вам был отправлен код на Email - \n$email', textAlign: TextAlign.center,),
                const SizedBox(height: 16.0),
                FourDigitCodeInput(updateProofCode: _updateProofCode),
                const SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: widget.proofCode != 4 ? () {
                    Navigator.of(dialogContext).pop();
                    validateEmail(email, widget.proofCode);
                  } : null,
                  child: const Text('Отправить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showResultDialog(BuildContext context, bool isValidate) {
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
                isValidate != false ?
                const Text('Почта подтверждена', textAlign: TextAlign.center,) : const Text ('Ошибка!\nВведен не верный код', textAlign: TextAlign.center),
                const SizedBox(height: 16.0,),
                Row (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8.0,),
                    isValidate == false ? ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        showChangePassword(context);
                      },
                      child: const Center (child: Text('Повторить')),
                    ) : ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (isValidate == true) {
                          showPasswordDialog(context);
                        }
                      },
                      child: const Center (child: Text('Продолжить')),
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
                        text: widget.email,
                        selection: TextSelection.collapsed(
                            offset: widget.email.length),
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
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
                        text: widget.password,
                        selection: TextSelection.collapsed(
                            offset: widget.password.length),
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      suffixIcon: IconButton(
                        icon: Icon(passIcon),
                        onPressed: () {
                          setState(() {
                            updatePasswordVisibility();
                          });
                        },
                      ),
                      errorText: widget.password.isNotEmpty && (widget.password.length < 6 || !_isPasswordValid(widget.password))
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
            const SizedBox(height: 16.0,),
            TextButton(
              onPressed: () {
                showChangePassword(context);
              },
              child: const Text('Забыли пароль?', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: (_formKey.currentState?.validate() ?? false)
                  ? () {
                widget.loginCallback();
              }
                  : null,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
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