import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ChangePassPage extends StatefulWidget {
  final Function() changePassword;
  final Function(String) updatePassword;

  const ChangePassPage( {
    super.key,
    required this.changePassword,
    required this.updatePassword
  });

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  bool isPasswordHidden = true;
  final TextEditingController _forgotPasswordController =
      TextEditingController();
  String password = "";
  IconData passIcon = Icons.visibility;

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
  void _updatePassword(String value) {
    setState(() {
      password = value;
      widget.updatePassword(value);
    });
    debugPrint(password);
  }

  bool _isPasswordValid(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Смена пароля'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.writeNewPassword,
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.2),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _forgotPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                suffixIcon: IconButton(
                      icon: Icon(passIcon),
                      onPressed: () {
                        updatePasswordVisibility();
                      },
                    ),
                errorText: password.isNotEmpty &&
                        (password.length < 6 || !_isPasswordValid(password))
                    ? AppLocalizations.of(context)!.passwordError
                    : null,
              ),
              obscureText: isPasswordHidden,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              onChanged: (value) {
                setState(() {
                  _updatePassword(value);
                  debugPrint(password);
                });
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
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.changePassword();
              },
              child: Text(AppLocalizations.of(context)!.send),
            ),
          ],
        ),
      ),
    );
  }
}
