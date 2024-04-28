import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Function() loginCallback;
  final Function() registerCallback;
  final Function(String) updateEmail;
  final Function(String) updatePassword;

  LoginPage({super.key, required this.loginCallback, required this.registerCallback, required this.updateEmail, required this.updatePassword});

  //final TextEditingController _emailController = TextEditingController(text: userId);
  //final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _registerFirstnameController = TextEditingController();
  final TextEditingController _registerLastnameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$appTitle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              //controller: _emailController,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: email,
                  selection: TextSelection.collapsed(offset: email.length),
                ),
              ),
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              onChanged: (value) {
                updateEmail(value);
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              //controller: _passwordController,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: password,
                  selection: TextSelection.collapsed(offset: password.length),
                ),
              ),
              decoration: const InputDecoration(
                labelText: 'Пароль',
              ),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              onChanged: (value) {
                updatePassword(value);
              },
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: 150.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: loginCallback,
                child: const Text('Войти', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Регистрация', textAlign: TextAlign.center,),
                        content: SizedBox(
                          width: 500,
                          height: 500,
                          child: Column(
                            children: [
                              TextField(
                                controller: _registerFirstnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Имя',
                                ),
                              ),
                              TextField(
                                controller: _registerLastnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Фамиллия',
                                ),
                              ),
                              TextField(
                                controller: _registerEmailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextField(
                                controller: _registerPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'Пароль',
                                ),
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          Center (
                            child: SizedBox(
                              width: 200.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: registerCallback,
                                child: const Text('Зарегистрироваться', textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ]);
                  },
                );
              },
              child: const Text('Зарегистрироваться', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}