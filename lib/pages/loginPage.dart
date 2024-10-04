import 'dart:convert';
import 'package:achieveclubmobileclient/items/fourDigitCodeInput.dart';
import 'package:achieveclubmobileclient/pages/changePassPage.dart';
import 'package:http/http.dart' as http;
import 'package:achieveclubmobileclient/main.dart';
import 'package:achieveclubmobileclient/pages/registerPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../items/languageSelectionButton.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _forgotEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String proofCode = "";

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
              updateProofCode: widget.updateProofCode,
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

  void _updateEmail(String value) {
    widget.email = value;
    email = value;
    widget.updateEmail(value);
    debugPrint(widget.email);
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
    }
    else {
      showResultDialog(context, false, false);
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
                Text (AppLocalizations.of(context)!.confirmEmail, textAlign: TextAlign.center, textScaler: TextScaler.linear(1.2)),
                TextFormField(
                  controller: _forgotEmailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    errorText: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
                        ? AppLocalizations.of(context)!.emailError
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
                      return AppLocalizations.of(context)!.emptyEmail;
                    }
                    if (!EmailValidator.validate(value!)) {
                      return AppLocalizations.of(context)!.emailError;
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
                  },
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
    var url = Uri.parse('${baseURL}api/email/change_password');

    var body = jsonEncode(
      email,
    );

    var response = await http.post(url, body: body, headers: {
      'Accept-Language': Localizations.localeOf(context).languageCode,
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      debugPrint('code send to $email');
      showProofCodeDialog(context, email);
    } else {
      showResultDialog(context, true, true);
      debugPrint('${response.body}, Status code: ${response.statusCode}');
      throw response.body;
    }
  }

  void navigateToPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePassPage(changePassword: widget.changePassword, updatePassword: widget.updatePassword),
      ),
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
                Text (AppLocalizations.of(context)!.confirmEmail, textAlign: TextAlign.center, textScaler: TextScaler.linear(1.2),),
                Text ('${AppLocalizations.of(context)!.codeSended} - \n$email', textAlign: TextAlign.center,),
                const SizedBox(height: 16.0),
                FourDigitCodeInput(updateProofCode: _updateProofCode),
                const SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: widget.proofCode != 4 ? () {
                    Navigator.of(dialogContext).pop();
                    navigateToPasswordPage();
                  } : null,
                  child: Text(AppLocalizations.of(context)!.send),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showResultDialog(
      BuildContext context, bool isValidate, bool isCodeSended) {
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
                  '${AppLocalizations.of(context)!.error}\n${AppLocalizations.of(context)!.codeSendedAfter}',
                  textAlign: TextAlign.center,
                )
                    : isValidate != false
                    ? Text(
                  AppLocalizations.of(context)!.emailConfirmed,
                  textAlign: TextAlign.center,
                )
                    : Text(
                    '${AppLocalizations.of(context)!.error}!\n${AppLocalizations.of(context)!.wrongCode}',
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
                        showChangePassword(context);
                      },
                      child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.repeat)),
                    )
                        : ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (isValidate == true) {
                          showChangePassword(context);
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
        title: Text(AppLocalizations.of(context)!.authorization),
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      errorText: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
                          ? AppLocalizations.of(context)!.emailError
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
                        return AppLocalizations.of(context)!.emptyEmail;
                      }
                      if (!EmailValidator.validate(value!)) {
                        return AppLocalizations.of(context)!.emailError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
                      suffixIcon: IconButton(
                        icon: Icon(passIcon),
                        onPressed: () {
                          setState(() {
                            updatePasswordVisibility();
                          });
                        },
                      ),
                      errorText: widget.password.isNotEmpty && (widget.password.length < 6 || !_isPasswordValid(widget.password))
                          ? AppLocalizations.of(context)!.passwordError
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
                        return AppLocalizations.of(context)!.emptyPassword;
                      }
                      if (value!.length < 6 || !_isPasswordValid(value)) {
                        return AppLocalizations.of(context)!.passwordError;
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
              child: Text(AppLocalizations.of(context)!.forgotPassword, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: (_formKey.currentState?.validate() ?? false)
                  ? () {
                widget.loginCallback();
              }
                  : null,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                navigateToRegisterPage(context);
              },
              child: Text(AppLocalizations.of(context)!.registrate, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16.0,),
            LanguageSelectionButton(updateAchievements: () => (),),
          ],
        ),
      ),
    );
  }
}