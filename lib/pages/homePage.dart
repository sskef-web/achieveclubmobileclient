import '../items/settingsButton.dart';
import '../main.dart';
import '../tabItems/tab1.dart';
import '../tabItems/tab2.dart';
import 'package:flutter/material.dart';

import '../tabItems/tab3.dart';
import '../tabItems/tab4.dart';

class HomePage extends StatefulWidget {
  final Function() logoutCallback;

  const HomePage({super.key, required this.logoutCallback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  late List<Widget> _tabs;
  String locale = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    locale = Localizations.localeOf(context).languageCode;
    _tabs = [
      Tab1Page(logoutCallback: widget.logoutCallback, locale: locale,),
      Tab2Page(logoutCallback: widget.logoutCallback,),
      Tab3Page(),
      Tab4Page(),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          appTitle,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          iconSize: 32.0,
          icon: Transform.rotate(
            angle: 3.14,
            child: const Icon(Icons.logout),
          ),
          onPressed: () {
            widget.logoutCallback();
          },
        ),
        actions: [
          _currentIndex == 0 ? SettingsButton() : SizedBox(height: 0, width: 0,)
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                appTitle = 'Профиль';
                break;
              case 1:
                appTitle = 'Топ 100';
                break;
              case 2:
                appTitle = 'Магазин';
                break;
              case 3:
                appTitle = 'О приложении';
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.groups),
            label: 'Топ 100',
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopify),
              label: 'Магазин'
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.info),
              label: 'О приложении'
          ),
        ],
      ),
    );
  }
}
