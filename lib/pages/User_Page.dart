import 'package:cached_network_image/cached_network_image.dart';
import '../data/Category.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data/Achievement.dart';
import '../data/Completed_Achievement.dart';
import '../data/User.dart';
import '../items/Achievement_Item.dart';

class UserPage extends StatefulWidget {
  int userId;
  final Function() logoutCallback;

  UserPage({
    super.key,
    required this.userId,
    required this.logoutCallback
  });

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<User> _userFuture;
  late Future<List<Achievement>> _achieveFuture;
  late Future<List<CompletedAchievement>> _completedAchievementsFuture;
  late Future<List<Category>> _categoriesFuture;
  List<Category> categories = [];
  int? _selectedCategoryId;
  bool _showCompletedAchievements = false;
  late String Avatar = '';
  String locale = "";

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
    _userFuture.then((user) {
      setState(() {
        Avatar = user.avatar;
      });
    });
    _achieveFuture = fetchAchievements();
    _completedAchievementsFuture = fetchCompletedAchievements();
    _categoriesFuture = fetchCategories();
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${baseURL}api/tags'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookies', cookies);
  }

  Future<String?> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }

  Future<void> refreshToken() async {
    var refreshUrl = Uri.parse('${baseURL}api/auth/refresh');
    var cookies = await loadCookies();

    var response = await http.get(refreshUrl, headers: {
      'Cookie': cookies!,
    });

    if (response.statusCode == 200) {
      var newCookies = response.headers['set-cookie'];
      if (newCookies != null) {
        await saveCookies(newCookies);
      }
    } else {
      throw Exception(
          'Ошибка при обновлении токена (Code: ${response.statusCode})\n${response.body}');
    }
  }

  Future<List<CompletedAchievement>> fetchCompletedAchievements() async {
    var url = Uri.parse('${baseURL}api/completedachievements/${widget.userId}');
    var cookies = await loadCookies();

    var response = await http.get(url, headers: {
      'Cookie': cookies!,
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CompletedAchievement.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      await refreshToken();
      return fetchCompletedAchievements();
    } else {
      throw Exception('Ошибка при получении выполненных достижений');
    }
  }

  double calculateCompletionPercentage(
      int completedAchievements, int totalAchievements) {
    if (totalAchievements == 0) {
      return 0.0;
    }

    double percentage = (completedAchievements / totalAchievements) * 100;
    return double.parse(percentage.toStringAsFixed(2));
  }

  Future<List<Achievement>> fetchAchievements() async {
    final response = await http.get(Uri.parse('${baseURL}api/achievements'),
        headers: {'Accept-Language': locale});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Achievement.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка при получении всех достижений');
    }
  }

  Future<User> fetchUser() async {
    try {
      var cookies = await loadCookies();
      var url = Uri.parse('${baseURL}api/users/${widget.userId}');

      var response = await http.get(url, headers: {
        'Cookie': cookies!,
        'Accept-Language': locale
      });
      debugPrint('${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('USER - ${jsonDecode(response.body)}');
        return User.fromJson(jsonDecode(response.body));
      }
      else if (response.statusCode == 401) {
        await refreshToken();
        return fetchUser();
      } else {
        throw Exception('Ошибка при получении пользователя');
      }
    }
    catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      rethrow;
    }
  }

  Future<Achievement?> getAchievementById(int id) async {
    final achievements = await _achieveFuture;

    if (achievements.isNotEmpty) {
      final achievement = achievements.firstWhere((a) => a.id == id);
      return achievement;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    locale = Localizations.localeOf(context).languageCode;
    AsyncSnapshot<List<dynamic>>? currentSnapshot;
    return Scaffold(
      appBar: AppBar(
        title:  Center(
          child: Text(
            'Профиль пользователя',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([_userFuture, _achieveFuture, _completedAchievementsFuture, _categoriesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          currentSnapshot = snapshot;
          if (snapshot.hasData) {
            final user = snapshot.data![0] as User;
            final achievements = snapshot.data![1] as List<Achievement>;
            final completedAchievements =
            snapshot.data![2] as List<CompletedAchievement>;

            final categories = snapshot.data![3] as List<Category>;

            Map<Category, List<Achievement>> categorizedAchievements = {};

            for (var category in categories) {
              categorizedAchievements[category] = [];
            }

            for (var achievement in achievements) {
              var category =
              categories.firstWhere((cat) => cat.id == achievement.tagId);
              if (category != null) {
                categorizedAchievements[category]!.add(achievement);
              }
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: '$baseURL/$Avatar',
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Flexible(
                          child: Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    /*Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(
                              '$baseURL/${user.clubLogo}'),
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          'Дворец',
                          textScaler: const TextScaler.linear(1.5),
                        ),
                      ],
                    ),*/
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Color(0xFFDEDEDE)
                            : Color.fromRGBO(38, 38, 38, 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Выполненные достижения: ${completedAchievements.length}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Процент выполненных достижений: ${calculateCompletionPercentage(completedAchievements.length, achievements.length)}%',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          LinearProgressIndicator(
                            value: calculateCompletionPercentage(
                                completedAchievements.length,
                                achievements.length) /
                                100,
                            color:
                            Theme.of(context).brightness == Brightness.dark
                                ? const Color.fromRGBO(245, 110, 15, 1)
                                : const Color.fromRGBO(245, 110, 15, 1),
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(height: 8,)
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showCompletedAchievements = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _showCompletedAchievements
                                  ? const Color.fromRGBO(245, 110, 15, 1)
                                  : null,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: const Color.fromRGBO(245, 110, 15, 1),
                                width: _showCompletedAchievements ? 0 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 0.0),
                              child: Text('Выполненные', style: TextStyle(color: _showCompletedAchievements ? Colors.white : Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showCompletedAchievements = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_showCompletedAchievements
                                  ? const Color.fromRGBO(245, 110, 15, 1)
                                  : null,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: const Color.fromRGBO(245, 110, 15, 1),
                                width: !_showCompletedAchievements ? 0 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 0.0),
                              child: Text('Невыполненные', style: TextStyle(color: !_showCompletedAchievements ? Colors.white : Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategoryId = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedCategoryId == null
                                  ? const Color.fromRGBO(245, 110, 15, 1)
                                  : null,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: const Color.fromRGBO(245, 110, 15, 1),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10.0),
                              child: Text('Все категории', style: TextStyle(color: _selectedCategoryId == null ? Colors.white : Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                            ),
                          ),
                          ...categories.map((category) {
                            return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCategoryId = category.id;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedCategoryId == category.id
                                    ? const Color.fromRGBO(245, 110, 15, 1)
                                    : null,
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: const Color.fromRGBO(245, 110, 15, 1),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 10.0),
                                child: Text(category.title, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ...categorizedAchievements.entries.map((entry) {
                      final category = entry.key;
                      final categoryAchievements = entry.value;

                      if ((_selectedCategoryId != null && _selectedCategoryId != category.id) ||
                          categoryAchievements.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final filteredAchievements = categoryAchievements.where((achievement) {
                        final isCompleted = completedAchievements.any(
                              (completed) => completed.achievementId == achievement.id,
                        );
                        return _showCompletedAchievements == isCompleted;
                      }).toList();

                      if (filteredAchievements.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse('0xFF${category.color}')),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              category.title,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, right: 0, left: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  width: 2,
                                  color: Color(int.parse('0xFF${category.color}')),
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredAchievements.length,
                                  itemBuilder: (context, index) {
                                    final achievement = filteredAchievements[index];

                                    final completedAchievement = completedAchievements.firstWhere(
                                          (completed) => completed.achievementId == achievement.id,
                                      orElse: () => CompletedAchievement(achievementId: -1, nextTryUnix: null, completionCount: 0),
                                    );

                                    return AchievementItem(
                                      onTap: () {

                                      },
                                      logo: '$baseURL${achievement.logoURL}',
                                      title: achievement.title,
                                      description: achievement.description,
                                      xp: achievement.xp,
                                      id: achievement.id,
                                      isSelected: false,
                                      completionCount: completedAchievement.completionCount,
                                      isMultiple: false,
                                      nextTryUnix: completedAchievement.nextTryUnix,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка при построении страницы: ${snapshot.error}\n ${snapshot.stackTrace}'),
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