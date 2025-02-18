import 'dart:convert';
import '../data/Club.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../items/Four_Digit_Code_Input.dart';

class RegisterPage extends StatefulWidget {
  final Function() registerCallback;
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

  RegisterPage({
    super.key,
    required this.registerCallback,
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
    required this.proofCode,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  IconData passIcon = Icons.visibility;
  bool isButtonEnabled = false;
  int? clubId;
  String? firstName;
  String? email;
  String? lastName;
  String? password;
  String? confirmPassword;
  bool isEmailProofed = false;
  String proofCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool _isPasswordValid(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$');
    return passwordRegex.hasMatch(password);
  }

  void registerCallback() {
    if (_formKey.currentState?.validate() == true) {
      widget.registerCallback();
    }
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

  void updateButtonEnabled() {
    setState(() {
      isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }


  void _updateProofCode(String value) {
    setState(() {
      widget.proofCode = value;
      widget.updateProofCode;
      proofCode = value;
    });
    saveProofCode();
    debugPrint('NEW proof-code - ${widget.proofCode}');
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
                  onPressed: widget.proofCode != 4
                      ? () {
                    Navigator.of(dialogContext).pop();
                    widget.registerCallback();
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

  Future<void> validateEmail(String email, String proofCode) async {
    var url = Uri.parse('${baseURL}api/auth/ValidateProofCode');

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
      showResultDialog(context, true, false);
    } else {
      showResultDialog(context, false, false);
      throw response.body;
    }
  }


  Future<void> sendProofCode(String email) async {
    var url = Uri.parse('${baseURL}api/email/proof_email');

    var body = jsonEncode(
      email,
    );

    var response = await http.post(url, body: body, headers: {
      'Accept-Language': Localizations
          .localeOf(context)
          .languageCode,
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      debugPrint('code send to $email');
      showProofCodeDialog(context, email);
    }
    else if (response.statusCode == 409) {
      if (response.body.contains('email')) {
        showEmailErrorDialog(context);
      }
      else {
        showResultDialog(context, true, true);
      }
    }
    else {
      showResultDialog(context, true, true);
      debugPrint('${response.body}, Status code: ${response.statusCode}');
      throw response.body;
    }
  }

  Future<bool> saveProofCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('proofCode', proofCode);
  }

  Future<String?> loadProofCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('proofCode');
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
                            showProofCodeDialog(context, widget.email);
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
                        showProofCodeDialog(context, widget.email);
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
                          widget.registerCallback();
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
        title: Text(AppLocalizations.of(context)!.registration),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8.0),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              setState(() {
                isButtonEnabled =
                    _formKey.currentState?.validate() ?? false;
              });
            },
            child: Column(
              spacing: 8,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                    errorText: widget.firstName.isNotEmpty && widget.firstName.length < 2
                        ? AppLocalizations.of(context)!.nameError
                        : null,
                    errorStyle: const TextStyle(color: Color(0xFFD7181D)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.firstName.isNotEmpty && widget.firstName.length < 2
                            ? const Color(0xFFD7181D)
                            : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.firstName.isNotEmpty && widget.firstName.length < 2
                            ? const Color(0xFFD7181D)
                            : Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      firstName = value;
                    });
                    widget.updateFirstName(firstName!);
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.emptyName;
                    }
                    if (value!.length < 2) {
                      return AppLocalizations.of(context)!.nameError;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.surname,
                    errorText: widget.lastName.isNotEmpty && widget.lastName.length < 5
                        ? AppLocalizations.of(context)!.surnameError
                        : null,
                    errorStyle: const TextStyle(color: Color(0xFFD7181D)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.lastName.isNotEmpty && widget.lastName.length < 5
                            ? const Color(0xFFD7181D)
                            : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.lastName.isNotEmpty && widget.lastName.length < 5
                            ? const Color(0xFFD7181D)
                            : Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      lastName = value;
                    });
                    widget.updateLastName(lastName!);
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.emptySurname;
                    }
                    if (value!.length <= 4) {
                      return AppLocalizations.of(context)!.surnameError;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    errorText: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
                        ? AppLocalizations.of(context)!.emailError
                        : null,
                    errorStyle: const TextStyle(color: Color(0xFFD7181D)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
                            ? const Color(0xFFD7181D)
                            : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
                            ? const Color(0xFFD7181D)
                            : Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                    widget.updateEmail(email!);
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.emptyEmail;
                    }
                    if (!EmailValidator.validate(value!)) {
                      return AppLocalizations.of(context)!.emailError;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    errorText: widget.password.isNotEmpty &&
                        (widget.password.length < 6 || !_isPasswordValid(widget.password))
                        ? AppLocalizations.of(context)!.passwordError
                        : null,
                    errorStyle: const TextStyle(color: Color(0xFFD7181D)),
                    errorMaxLines: 2,
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.password.isNotEmpty &&
                            (widget.password.length < 6 || !_isPasswordValid(widget.password))
                            ? const Color(0xFFD7181D)
                            : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.password.isNotEmpty &&
                            (widget.password.length < 6 || !_isPasswordValid(widget.password))
                            ? const Color(0xFFD7181D)
                            : Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                    widget.updatePassword(password!);
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.emptyPassword;
                    }
                    if (value!.length < 6 || !_isPasswordValid(value)) {
                      return AppLocalizations.of(context)!.passwordError;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.confirmPassword,
                    errorText: confirmPasswordController.text != passwordController.text
                        ? AppLocalizations.of(context)!.confirmPasswordError
                        : null,
                    errorStyle: const TextStyle(color: Color(0xFFD7181D)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFD7181D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: confirmPasswordController.text != passwordController.text
                            ? const Color(0xFFD7181D)
                            : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: confirmPasswordController.text != passwordController.text
                            ? const Color(0xFFD7181D)
                            : Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                    updateButtonEnabled();
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.emptyConfirmPassword;
                    }
                    if (value != passwordController.text) {
                      return AppLocalizations.of(context)!.confirmPasswordError;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: (_formKey.currentState?.validate() ?? false) ? () {
              sendProofCode(email!);
            }
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(38,38,38, 1)
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.registrate,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ),);
  }
}
