import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8.0),
                Form (
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column (
                    children: [
                      SegmentedButton(
                          segments: const [
                            ButtonSegment(
                              value: 1,
                              label: Text('Клуб Двойной Чикаго'),
                              icon: Icon(Icons.home),
                            ),
                            ButtonSegment(
                              value: 2,
                              label: Text('Клуб Дворец'),
                              icon: Icon(Icons.home),
                            ),
                          ],
                          selected: {clubId},
                          onSelectionChanged: (value) {
                            setState(() {
                              widget.updateClubId(value.first);
                            });
                          }),
                    /*CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage('https://sskef.site/$avatarPath'),
                      child: InkWell(
                        onTap: () {
                          uploadAvatar(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('Аватар', textAlign: TextAlign.center),*/
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
                        errorText:
                        _formKey.currentState?.validate() == false ? 'Ввод имя обязателен' : null,
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      onChanged: (value) {
                        widget.updateFirstName(value);
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Ввод имя обязателен';
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
                        errorText:
                        _formKey.currentState?.validate() == false ? 'Ввод фамилии обязателен' : null,
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      onChanged: (value) {
                        widget.updateLastName(value);
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Ввод фамилии обязателен';
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
                        errorText:
                        _formKey.currentState?.validate() == false ? 'Ввод email обязателен' : null,
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                      onChanged: (value) {
                        widget.updateEmail(value);
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Ввод email обязателен';
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
                        suffixIcon: IconButton(
                          icon: Icon(passIcon),
                          onPressed: () {
                            updatePasswordVisibility();
                          },
                        ),
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
                          return 'Ввод пароля обязателен';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    /*Container(
                      child: DropdownButton<int>(
                        value: clubId,
                        onChanged: (value) {
                          widget.updateClubId(value!);
                        },
                        items: const [
                          DropdownMenuItem<int>(
                              value: 1,
                              child: Text('Клуб Двойной Чикаго')
                          ),
                          DropdownMenuItem<int>(
                              value: 2,
                              child: Text('Клуб Дворец')
                          ),
                        ],
                        //hint: const Text('Выберите клуб'),
                        isExpanded: true,
                        selectedItemBuilder: (BuildContext context) {
                          return [Text(getClubName(clubId))];
                        },
                      ),
                    ),*/
                    const SizedBox(height: 16.0),
                      SizedBox(
                        width: 250.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: _formKey.currentState?.validate() == false
                              ? null
                              : widget.registerCallback,
                          child: const Text('Зарегистрироваться', textAlign: TextAlign.center),
                        ),
                      ),
                   ],
                ),
                ),
            ],
        ),
        ),
    );
  }
}