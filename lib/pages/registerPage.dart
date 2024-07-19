import 'dart:convert';
import 'package:achieveclubmobileclient/data/club.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../items/fourDigitCodeInput.dart';

class RegisterPage extends StatefulWidget {
  final Function() registerCallback;
  final Function(String) updateEmail;
  final Function(String) updatePassword;
  final Function(String) updateFirstName;
  final Function(String) updateLastName;
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

  @override
  void initState() {
    super.initState();
    fetchClubs();
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

  Future<List<Club>> fetchClubs() async {
    final url = Uri.parse('${baseURL}clubs');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Club> clubs = [];

        for (var clubData in data) {
          final club = Club(
              id: clubData['id'],
              title: clubData['title'],
              avgXp: 0,
              logoURL: clubData['logoURL'],
              description: '',
              address: ''
          );
          clubs.add(club);
        }

        return clubs;
      } else {
        throw Exception('${AppLocalizations.of(context)!.fetchClubsError}: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('${AppLocalizations.of(context)!.fetchClubsError}: $e');
    }
  }

  void _updateProofCode(String value) {
    setState(() {
      widget.proofCode = value;
    });
    debugPrint(widget.proofCode);
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
                    validateEmail(email, widget.proofCode);
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
      String errorMessage;
      throw errorMessage = response.body;
    }
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
                Text(AppLocalizations.of(context)!.emailConfirmed, textAlign: TextAlign.center,)
                    : Text ('${AppLocalizations.of(context)!.error}!\n${AppLocalizations.of(context)!.wrongCode}', textAlign: TextAlign.center),
                const SizedBox(height: 16.0,),
                Row (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8.0,),
                    isValidate == false ? ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        showProofCodeDialog(context, widget.email);
                      },
                      child: Center (child: Text(AppLocalizations.of(context)!.repeat)),
                    ) : ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (isValidate == true) {
                          widget.registerCallback();
                        }
                      },
                      child: Center (child: Text(AppLocalizations.of(context)!.continued)),
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
        child: FutureBuilder<List<Club>>(
          future: fetchClubs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final clubs = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8.0),
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
                        SizedBox(
                          width: double.infinity, // Set the width to full width
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: clubId,
                              items: clubs.map((club) {
                                return DropdownMenuItem<int>(
                                  value: club.id,
                                  child: Text(club.title),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  clubId = value;
                                });
                                widget.updateClubId(clubId!);
                              },
                              hint: Text(AppLocalizations.of(context)!.selectClub),
                            ),
                          ),
                        ),
                        TextFormField(
                          /*controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.firstName,
                              selection: TextSelection.collapsed(
                                  offset: widget.firstName.length),
                            ),
                          ),*/
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.name,
                            errorText: widget.firstName.isNotEmpty && widget.firstName.length < 2
                                ? AppLocalizations.of(context)!.nameError
                                : null,
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
                          /*controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.lastName,
                              selection: TextSelection.collapsed(
                                  offset: widget.lastName.length),
                            ),
                          ),*/
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.surname,
                            errorText: widget.lastName.isNotEmpty && widget.lastName.length < 2
                                ? AppLocalizations.of(context)!.surnameError
                                : null,
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
                            if (value!.length <= 1) {
                              return AppLocalizations.of(context)!.surnameError;
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          /*controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.email,
                              selection: TextSelection.collapsed(
                                  offset: widget.email.length),
                            ),
                          ),*/
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            errorText: widget.email.isNotEmpty && !EmailValidator.validate(widget.email)
                                ? AppLocalizations.of(context)!.emailError
                                : null,
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
                          /*controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.password,
                              selection: TextSelection.collapsed(offset: widget.password.length),
                            ),
                          ),*/
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.password,
                            errorText: widget.password.isNotEmpty && (widget.password.length < 6 || !_isPasswordValid(widget.password))
                                ? AppLocalizations.of(context)!.passwordError
                                : null,
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
                          /*controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.confirmPassword,
                              selection: TextSelection.collapsed(
                                  offset: widget.confirmPassword.length),
                            ),
                          ),*/
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.confirmPassword,
                            errorText: confirmPasswordController.text != passwordController.text
                                ? AppLocalizations.of(context)!.confirmPasswordError
                                : null,
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
                    onPressed: (_formKey.currentState?.validate() ?? false) && clubId != null ? () {
                      debugPrint("\n\n\n\n${widget.email}\n\n\n\n");
                        sendProofCode(email!);
                        showProofCodeDialog(context, email!);
                    } : null,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context)!.registrate,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(AppLocalizations.of(context)!.loadingPageError);
            } else {
              return const Center (child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }


}