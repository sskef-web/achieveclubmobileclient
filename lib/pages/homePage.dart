import 'package:achieveclubmobileclient/main.dart';
import 'package:achieveclubmobileclient/tabItems/tab1.dart';
import 'package:achieveclubmobileclient/tabItems/tab2.dart';
import 'package:achieveclubmobileclient/tabItems/tab3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final Function() logoutCallback;

  HomePage({super.key, required this.logoutCallback});

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
      Tab3Page(logoutCallback: widget.logoutCallback,),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
            child: Text(
              appTitle,
            )
        ),
        leading: SizedBox(
          width: 48.0,
          height: 48.0,
          child: IconButton(
            iconSize: 32.0,
            icon: Transform.rotate(
              angle: 3.14,
              child: const Icon(Icons.logout),
            ),
            onPressed: () {
              widget.logoutCallback();
            },
          ),
        ),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                appTitle = AppLocalizations.of(context)!.tab1;
                break;
              case 1:
                appTitle = AppLocalizations.of(context)!.tab2;
                break;
              case 2:
                appTitle = AppLocalizations.of(context)!.tab3;
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.tab1,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.groups),
            label: AppLocalizations.of(context)!.tab2,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.apartment),
            label: AppLocalizations.of(context)!.tab3,
          ),
        ],
      ),
    );
  }
}
