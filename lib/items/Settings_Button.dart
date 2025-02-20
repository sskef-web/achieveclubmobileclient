import 'package:achieveclubmobileclient/pages/Settings_Page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/User.dart';

class SettingsButton extends StatefulWidget {
  final Function() logoutCallback;
  User user;

  SettingsButton({super.key, required this.user, required this.logoutCallback});

  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {

  @override
  void initState() {
    super.initState();
  }

  void navigateToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SettingsPage(avatar: widget.user.avatar,logoutCallback: widget.logoutCallback,)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            navigateToSettingsPage();
          });
        },
        icon: Icon(
          Icons.settings,
        )
    );
  }
}
