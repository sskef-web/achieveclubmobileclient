import 'package:achieveclubmobileclient/main.dart';
import 'package:achieveclubmobileclient/tabItems/tab1.dart';
import 'package:achieveclubmobileclient/tabItems/tab2.dart';
import 'package:achieveclubmobileclient/tabItems/tab3.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function() logoutCallback;

  const HomePage({super.key, required this.logoutCallback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      Tab1Page(logoutCallback: widget.logoutCallback),
      Tab2Page(logoutCallback: widget.logoutCallback,),
      Tab3Page(logoutCallback: widget.logoutCallback,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(appTitle)),
        leading: SizedBox(
          width: 48.0,
          height: 48.0,
          child: IconButton(
            iconSize: 32.0,
            icon: Transform.rotate(
              angle: 3.14,
              child: const Icon(Icons.logout),
            ),
            onPressed: widget.logoutCallback,
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
                appTitle = 'Profil';
                break;
              case 1:
                appTitle = 'Top 100 użytkowników';
                break;
              case 2:
                appTitle = 'Top kluby';
                break;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Top 100 użytkowników',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Top kluby',
          ),
        ],
      ),
    );
  }
}
