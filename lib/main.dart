import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
String appTitle = "Achieve Club";

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return Center(
          child: MaterialApp(
            title: '$appTitle',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(
                    11, 106, 108, 1.0)),
                    useMaterial3: true,
              ),
              darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(
                      11, 106, 108, 1.0), brightness: Brightness.dark),
                  useMaterial3: true,
              ),
            home: AuthenticationPage(),
          ),
        );
    }
}

class AuthenticationPage extends StatefulWidget {
    @override
    _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
    bool _isLoggedIn = false;

    @override
    void initState() {
        super.initState();
        _checkLoginStatus();
    }

    void _checkLoginStatus() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        setState(() {
            _isLoggedIn = isLoggedIn;
        });
    }

    void _login() async {
        // Здесь можно добавить логику для проверки введенных данных и выполнения входа в систему
        // Проверка может быть выполнена с помощью сервера или локально

        // Пример успешного входа в систему
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        setState(() {
            _isLoggedIn = true;
        });
    }

    void _register() async {
        // Здесь можно добавить логику для регистрации нового пользователя
        // Регистрация может быть выполнена с помощью сервера или локально

        // Пример успешной регистрации
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        setState(() {
            _isLoggedIn = true;
        });
    }

    void _logout() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);

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
                title: Text('$appTitle'),
                centerTitle: true,
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
                        SizedBox(
                            width: 150.0,
                            height: 75.0,
                            child: ElevatedButton(
                                child: Text('Login', textAlign: TextAlign.center),
                                onPressed: loginCallback,
                            ),
                        ),
                        SizedBox(height: 16.0),
                        TextButton(
                            onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text('Register', textAlign: TextAlign.center,),
                                            content: Container(
                                                width: 500,
                                                height: 500,
                                                child: Column(
                                                    children: [
                                                        TextField(
                                                            controller: _registerEmailController,
                                                            decoration: InputDecoration(
                                                                labelText: 'Name',
                                                            ),
                                                        ),
                                                        TextField(
                                                            controller: _registerEmailController,
                                                            decoration: InputDecoration(
                                                                labelText: 'Surname',
                                                            ),
                                                        ),
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
                                            ),
                                            actions: [
                                                SizedBox(
                                                    width: 150.0,
                                                    height: 75.0,
                                                    child: ElevatedButton(
                                                        child: Text('Registrate', textAlign: TextAlign.center),
                                                        onPressed: registerCallback,
                                                    ),
                                                ),
                                        ]);
                                    },
                                );
                            },
                            child: Text('Registration', textAlign: TextAlign.center),
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
            title: Text(appTitle),
                centerTitle: true,
        ),
            body: _tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                    setState(() {
                        _currentIndex = index;
                        switch (_currentIndex) {
                            case 0:
                                appTitle = 'User';
                                break;
                            case 1:
                                appTitle = 'Top 100 users';
                                break;
                            case 2:
                                appTitle = 'Top clubs';
                                break;
                        }
                    });
                },
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.tab),
                        label: 'User',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.tab),
                        label: 'Top 100 users',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.tab),
                        label: 'Top clubs',
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
        return Center (
            child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(500.0)),
                child: Image.network("https://scontent-fra3-2.xx.fbcdn.net/v/t39.30808-6/351172401_580626204259601_4702578806292022547_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=5f2048&_nc_ohc=y0Tz4XfPWqUAb5vSiGw&_nc_ht=scontent-fra3-2.xx&oh=00_AfA8xurik-zP7srJY1FEY9mvVABy5nN35NZ9ypvGJOrnUg&oe=6631C943",
                height: 300.0,
                width: 300.0,
                ),
        ),
        );
    }
}

class Tab2Page extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child:
            Text('Top 100 users'),
        );
    }
}

class Tab3Page extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Text('Top clubs'),
        );
    }
}