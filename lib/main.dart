import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
String appTitle = "User";


void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return Center(
          child: MaterialApp(
            title: appTitle,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(
                    11, 106, 108, 1.0)),
                    useMaterial3: true,
              ),
              darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(
                      11, 106, 108, 1.0), brightness: Brightness.dark),
                  useMaterial3: true,
              ),
            home: const AuthenticationPage(),
          ),
        );
    }
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

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

    LoginPage({super.key, required this.loginCallback, required this.registerCallback});

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _registerEmailController = TextEditingController();
    final TextEditingController _registerPasswordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(appTitle),
                centerTitle: true,
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                            ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                            ),
                            obscureText: true,
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                            width: 150.0,
                            height: 75.0,
                            child: ElevatedButton(
                                onPressed: loginCallback,
                                child: const Text('Login', textAlign: TextAlign.center),
                            ),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                            onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text('Register', textAlign: TextAlign.center,),
                                            content: SizedBox(
                                                width: 500,
                                                height: 500,
                                                child: Column(
                                                    children: [
                                                        TextField(
                                                            controller: _registerEmailController,
                                                            decoration: const InputDecoration(
                                                                labelText: 'Name',
                                                            ),
                                                        ),
                                                        TextField(
                                                            controller: _registerEmailController,
                                                            decoration: const InputDecoration(
                                                                labelText: 'Surname',
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
                                                        onPressed: registerCallback,
                                                        child: const Text('Registrate', textAlign: TextAlign.center),
                                                    ),
                                                ),
                                        ]);
                                    },
                                );
                            },
                            child: const Text('Registration', textAlign: TextAlign.center),
                        ),
                    ],
                ),
            ),
        );
    }
}

class HomePage extends StatefulWidget {
    final Function() logoutCallback;

    const HomePage({super.key, required this.logoutCallback});

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    int _currentIndex = 0;

    final List<Widget> _tabs = [
        const Tab1Page(),
        const Tab2Page(),
        const Tab3Page(),
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
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
                child: const Icon(Icons.logout),
            ),
        );
    }
}


class Tab1Page extends StatefulWidget {
  const Tab1Page({super.key});

    @override
    _Tab1Page createState() => _Tab1Page();

}

class _Tab1Page extends State<Tab1Page> {
    late Future<User> _userFuture;
    late Future<List<Achievement>> _achieveFuture;
    late Future<List<CompletedAchievement>> _completedAchievementsFuture;

    @override
    void initState() {
        super.initState();
        _userFuture = fetchUser();
        _achieveFuture = fetchAchievements();
        _completedAchievementsFuture = fetchCompletedAchievements();
    }

    Future<List<CompletedAchievement>> fetchCompletedAchievements() async {
        final response = await http.get(Uri.parse('https://sskef.site/api/completedachievements/149'));

        if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            return data.map((item) => CompletedAchievement.fromJson(item)).toList();
        } else {
            throw Exception('Failed to load completed achievements');
        }
    }

    Future<User> fetchUser() async {
        final response = await http.get(Uri.parse('https://sskef.site/api/users/149'));

        if (response.statusCode == 200) {
            return User.fromJson(jsonDecode(response.body));
        } else {
            throw Exception('Failed to load user');
        }
    }

    Future<List<Achievement>> fetchAchievements() async {
        final response = await http.get(Uri.parse('https://sskef.site/api/achievements'));

        if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            return data.map((item) => Achievement.fromJson(item)).toList();
        } else {
            throw Exception('Failed to load achievements');
        }
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Center(child: Text(appTitle)),
            ),
            body: FutureBuilder(
                future: Future.wait([_userFuture, _achieveFuture, _completedAchievementsFuture]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                        final user = snapshot.data![0] as User;
                        final achievements = snapshot.data![1] as List<Achievement>;
                        final completedAchievements = snapshot.data![2] as List<CompletedAchievement>;


                        return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    CircleAvatar(
                                        radius: 80.0,
                                        backgroundImage: NetworkImage('https://sskef.site/${user.avatar}'),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        child: const Column(
                                            children: [
                                                Text(
                                                    'Выполнено достижений: 15',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                    ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                    'Процент выполненных достижений: 15%',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                        'Завершенные достижения:',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: completedAchievements.length,
                                            itemBuilder: (context, index) {
                                                final completedAchievement = completedAchievements;
                                                final achievement = achievements;

                                                for (var i in completedAchievement)
                                                {
                                                            final _achieve = achievements[index];

                                                            return AchievementItem(
                                                                logo: 'https://sskef.site/${_achieve.logoURL}',
                                                                title: '${_achieve.title}',
                                                                description: '${_achieve.description}',
                                                                xp: _achieve.xp,
                                                                completionPercentage: 8,
                                                            );
                                                }
                                            },
                                        ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                        'Достижения:',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: achievements.length,
                                            itemBuilder: (context, index) {
                                                final achievement = achievements[index];
                                                return AchievementItem(
                                                    logo: 'https://sskef.site/${achievement.logoURL}',
                                                    title: achievement.title,
                                                    description: achievement.description,
                                                    xp: achievement.xp,
                                                    completionPercentage: 8,
                                                );
                                            },
                                        ),
                                    ),
                                ],
                            ),
                        );
                    } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'),
                        );
                    } else {
                        return const Center(
                            child: CircularProgressIndicator(),
                        );
                    }
                },
            ),
        );
    }
}

class AchievementItem extends StatelessWidget {
    final String logo;
    final String title;
    final String description;
    final int xp;
    final int completionPercentage;

    const AchievementItem({super.key, required this.logo, required this.title, required this.description, required this.xp, required this.completionPercentage});

    @override
    Widget build(BuildContext context) {
        return Card(
            child: ListTile(
                leading: Image.network(logo),
                title: Text(title),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(description),
                        const SizedBox(height: 4.0),
                        Text('XP: $xp'),
                        const SizedBox(height: 4.0),
                        Text('Процент выполнения: $completionPercentage%'),
                    ],
                ),
            ),
        );
    }
}

class Tab2Page extends StatelessWidget {
  const Tab2Page({super.key});

    @override
    Widget build(BuildContext context) {
        return const Center(
            child:
            Text('Top 100 users'),
        );
    }
}

class Tab3Page extends StatelessWidget {
  const Tab3Page({super.key});

    @override
    Widget build(BuildContext context) {
        return const Center(
            child: Text('Top clubs'),
        );
    }
}

class User {
    final int id;
    final String firstName;
    final String lastName;
    final String avatar;
    final int clubId;
    final String clubName;
    final String clubLogo;

    const User({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.avatar,
        required this.clubId,
        required this.clubName,
        required this.clubLogo,
    });

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            id: json['id'],
            firstName: json['firstName'],
            lastName: json['lastName'],
            avatar: json['avatar'],
            clubId: json['clubId'],
            clubName: json['clubName'],
            clubLogo: json['clubLogo'],
        );
    }
}

class CompletedAchievement {
    final int achievementId;

    CompletedAchievement({
        required this.achievementId,
    });

    factory CompletedAchievement.fromJson(Map<String, dynamic> json) {
        return CompletedAchievement(
            achievementId: json['achieveId'],
        );
    }
}

CompletedAchievement findElementWithMaxId(List<CompletedAchievement> elements) {
    if (elements.isEmpty) {
        throw Exception("The list is empty!");
    }

    CompletedAchievement elementWithMaxId = elements[0];

    for (var element in elements) {
        if (element.achievementId > elementWithMaxId.achievementId) {
            elementWithMaxId = element;
        }
    }

    return elementWithMaxId;
}

class Achievement {
    final int id;
    final int xp;
    final String title;
    final String description;
    final String logoURL;
    final bool isMultiple;

    Achievement({
        required this.id,
        required this.xp,
        required this.title,
        required this.description,
        required this.logoURL,
        required this.isMultiple,
    });

    factory Achievement.fromJson(Map<String, dynamic> json) {
        return Achievement(
            id: json['id'],
            xp: json['xp'],
            title: json['title'],
            description: json['description'],
            logoURL: json['logoURL'],
            isMultiple: json['isMultiple'],
        );
    }

}