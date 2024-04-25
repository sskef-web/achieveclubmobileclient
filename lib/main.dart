import 'package:flutter/material.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Tab Navigation Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: AuthenticationPage(),
        );
    }
}

class AuthenticationPage extends StatefulWidget {
    @override
    _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
    bool _isLoggedIn = false;

    void _login() {
        // Add your logic here to check the entered credentials and perform the login
        // The check can be done either with a server or locally

        // Example of successful login
        setState(() {
            _isLoggedIn = true;
        });
    }

    void _register() {
        // Add your logic here to register a new user
        // The registration can be done either with a server or locally

        // Example of successful registration
        setState(() {
            _isLoggedIn = true;
        });
    }

    void _logout() {
        setState(() {
            _isLoggedIn = false;
        });
    }

    @override
    Widget build(BuildContext context) {
        if (_isLoggedIn) {
            return HomePage(logoutCallback: _logout);
        } else {
            return LoginPage(loginCallback: _login, registerCallback: _register);
        }
    }
}

class LoginPage extends StatelessWidget {
    final Function() loginCallback;
    final Function() registerCallback;

    LoginPage({required this.loginCallback, required this.registerCallback});

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _registerEmailController = TextEditingController();
    final TextEditingController _registerPasswordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Login Page'),
            ),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: 'Email',
                            ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                            ),
                            obscureText: true,
                        ),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                            onPressed: loginCallback,
                            child: Text('Login'),
                        ),
                        SizedBox(height: 16.0),
                        TextButton(
                            onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text('Register'),
                                            content: Column(
                                                children: [
                                                    TextField(
                                                        controller: _registerEmailController,
                                                        decoration: InputDecoration(
                                                            labelText: 'Email',
                                                        ),
                                                    ),
                                                    SizedBox(height: 16.0),
                                                    TextField(
                                                        controller: _registerPasswordController,
                                                        decoration: InputDecoration(
                                                            labelText: 'Password',
                                                        ),
                                                        obscureText: true,
                                                    ),
                                                ],
                                            ),
                                            actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                        registerCallback();
                                                        Navigator.of(context).pop();
                                                    },
                                                    child: Text('Register'),
                                                ),
                                            ],
                                        );
                                    },
                                );
                            },
                            child: Text('Register'),
                        ),
                    ],
                ),
            ),
        );
    }
}

class HomePage extends StatefulWidget {
    final Function() logoutCallback;

    HomePage({required this.logoutCallback});

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    int _currentIndex = 0;

    final List<Widget> _tabs = [
        Tab1Page(),
        Tab2Page(),
        Tab3Page(),
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Home Page'),
            ),
            body: _tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                    setState(() {
                        _currentIndex = index;
                    });
                },
                items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.tab),
                        label: 'Tab 1',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.tab),
                        label: 'Tab 2',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.tab),
                        label: 'Tab 3',
                    ),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: widget.logoutCallback,
                child: Icon(Icons.logout),
            ),
        );
    }
}

class Tab1Page extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Text('Tab 1'),
        );
    }
}

class Tab2Page extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Text('Tab 2'),
        );
    }
}

class Tab3Page extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Text('Tab 3'),
        );
    }
}