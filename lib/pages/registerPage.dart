import 'dart:convert';

import 'package:achieveclubmobileclient/data/club.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  final Function() registerCallback;
  final Function(String) updateEmail;
  final Function(String) updatePassword;
  final Function(String) updateFirstName;
  final Function(String) updateLastName;
  final Function(int) updateClubId;
  final Function(BuildContext) uploadAvatar;

  const RegisterPage({
    super.key,
    required this.registerCallback,
    required this.updateEmail,
    required this.updatePassword,
    required this.updateFirstName,
    required this.updateLastName,
    required this.updateClubId,
    required this.uploadAvatar,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  IconData passIcon = Icons.visibility;
  bool isButtonEnabled = false;
  List<Club> _clubs = [];

  @override
  void initState() {
    super.initState();
    fetchClubs();
  }

  String getClubName(int clubId) {
    switch (clubId) {
      case 1:
        return 'Клуб Двойной Чикаго';
      case 2:
        return 'Клуб Дворец';
      default:
        return '';
    }
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

  void updateConfirmPassword(String value) {
    setState(() {
      confirmPassword = value;
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
        throw Exception('Ошибка при загрузке клубов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке клубов: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
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
                        isButtonEnabled = _formKey.currentState?.validate() ??
                            false;
                      });
                    },
                    child: Column(
                      children: [
                        SegmentedButton(
                          segments: clubs.map((club) {
                            return ButtonSegment(
                              value: club.id,
                              label: Text(club.title),
                              icon: Container(
                                width: 24,
                                height: 24,
                                child: Image.network('https://sskef.site/${club.logoURL}',),
                              ),
                            );
                          }).toList(),
                          selected: {clubId},
                          onSelectionChanged: (value) {
                            setState(() {
                              clubId = value.first;
                            });
                            widget.updateClubId(clubId);
                          },
                        ),
                        TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: firstName,
                              selection: TextSelection.collapsed(
                                  offset: firstName.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Имя',
                            errorText: firstName.isNotEmpty && firstName.length < 2
                                ? 'Имя должно содержать не менее 2 символов'
                                : null,
                          ),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          onChanged: (value) {
                            widget.updateFirstName(value);
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Имя обязательно для заполнения';
                            }
                            if (value!.length < 2) {
                              return 'Имя должно содержать не менее 2 символов';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: lastName,
                              selection: TextSelection.collapsed(
                                  offset: lastName.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Фамилия',
                            errorText: lastName.isNotEmpty && lastName.length < 4
                                ? 'Фамилия должна содержать не менее 4 символов'
                                : null,
                          ),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          onChanged: (value) {
                            widget.updateLastName(value);
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Фамилия обязательна для заполнения';
                            }
                            if (value!.length < 4) {
                              return 'Фамилия должна содержать не менее 4 символов';
                            }
                            return null;
                          },
                        ),
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
                        TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: password,
                              selection: TextSelection.collapsed(offset: password.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            errorText: password.isNotEmpty && (password.length < 6 || !_isPasswordValid(password))
                                ? 'Пароль должен содержать не менее 6 символов и \nкак минимум 1 букву или 1 цифру'
                                : null,
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
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
                        TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: confirmPassword,
                              selection: TextSelection.collapsed(
                                  offset: confirmPassword.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Подтвердите пароль',
                            errorText: confirmPassword!=password
                                ? 'Пароли должны совпадать'
                                : null,
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                          onChanged: (value) {
                            updateConfirmPassword(value);
                            updateButtonEnabled();
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Подтверждение пароля обязательно для заполнения';
                            }
                            if (value != password) {
                              return 'Пароли не совпадают';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: (_formKey.currentState?.validate() ?? false) &&
                        clubId != 0
                        ? () {
                      widget.registerCallback();
                    }
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Зарегистрироваться',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Ошибка при загрузке клубов');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}