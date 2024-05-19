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
  String email;
  String password;
  String confirmPassword;
  String firstName;
  String lastName;

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
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  IconData passIcon = Icons.visibility;
  bool isButtonEnabled = false;
  final List<Club> _clubs = [];

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
      widget.confirmPassword = value;
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

  int? clubId; // Change the type of clubId to int?

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
                        isButtonEnabled = _formKey.currentState?.validate() ?? false;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
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
                              hint: Text('Выберите клуб'),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.firstName,
                              selection: TextSelection.collapsed(
                                  offset: widget.firstName.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Имя',
                            errorText: widget.firstName.isNotEmpty && widget.firstName.length < 2
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
                              text: widget.lastName,
                              selection: TextSelection.collapsed(
                                  offset: widget.lastName.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Фамилия',
                            errorText: widget.lastName.isNotEmpty && widget.lastName.length < 4
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
                        TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: widget.password,
                              selection: TextSelection.collapsed(offset: widget.password.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            errorText: widget.password.isNotEmpty && (widget.password.length < 6 || !_isPasswordValid(widget.password))
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
                              text: widget.confirmPassword,
                              selection: TextSelection.collapsed(
                                  offset: widget.confirmPassword.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Подтвердите пароль',
                            errorText: widget.confirmPassword!=widget.password
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
                            if (value != widget.password) {
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
                    onPressed: (_formKey.currentState?.validate() ?? false) && clubId != null
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
              return const Text('Ошибка при загрузке клубов');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }


}