import 'package:achieveclubmobileclient/pages/settingsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatefulWidget {

  const SettingsButton({super.key,});

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
      MaterialPageRoute(builder: (context) => SettingsPage()),
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
