import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data/achievement.dart';
import '../data/completedachievement.dart';
import '../data/user.dart';
import '../items/achievementItem.dart';
import 'homePage.dart';

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
  late String Avatar = '';
  String locale = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.remove('cookies');
    await prefs.setString('cookies', cookies);
  }

  Future<String?> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }

  Future<void> refreshToken() async {
    var refreshUrl = Uri.parse('${baseURL}auth/refresh');
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
          '${AppLocalizations.of(context)!.refreshTokenError} (Code: ${response.statusCode})\n${response.body}');
    }
  }

  Future<List<CompletedAchievement>> fetchCompletedAchievements() async {
    var url = Uri.parse('${baseURL}completedachievements/${widget.userId}');
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
      throw Exception(AppLocalizations.of(context)!.fetchCompletedAchieveError);
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
    final response = await http.get(Uri.parse('${baseURL}achievements'),
        headers: {'Accept-Language': locale});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Achievement.fromJson(item)).toList();
    } else {
      throw Exception(AppLocalizations.of(context)!.fetchAchievementError);
    }
  }

  Future<User> fetchUser() async {
    try {
      var cookies = await loadCookies();
      var url = Uri.parse('${baseURL}users/${widget.userId}');
      appTitle = AppLocalizations.of(context)!.profil;

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
        throw Exception(AppLocalizations.of(context)!.fetchUserError);
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
    _userFuture = fetchUser();
    _userFuture.then((user) {
      setState(() {
        Avatar = user.avatar;
      });
    });
    _achieveFuture = fetchAchievements();
    _completedAchievementsFuture = fetchCompletedAchievements();
    AsyncSnapshot<List<dynamic>>? currentSnapshot;
    return Scaffold(
      appBar: AppBar(
        title:  Center(
          child: Text(
            AppLocalizations.of(context)!.userProfile,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([_userFuture, _achieveFuture, _completedAchievementsFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          currentSnapshot = snapshot;
          if (snapshot.hasData) {
            final user = snapshot.data![0] as User;
            final achievements = snapshot.data![1] as List<Achievement>;
            final completedAchievements =
            snapshot.data![2] as List<CompletedAchievement>;
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
                              imageUrl: 'https://achieveclub-ekdpajekhkd0amct.polandcentral-01.azurewebsites.net/$Avatar',
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(
                              'https://achieveclub-ekdpajekhkd0amct.polandcentral-01.azurewebsites.net/${user.clubLogo}'),
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          user.clubName,
                          textScaler: const TextScaler.linear(1.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromRGBO(11, 106, 108, 0.15)
                            : const Color.fromRGBO(11, 106, 108, 0.15),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.completedAchievements}: ${completedAchievements.length}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${AppLocalizations.of(context)!.percentCompletedAchievements}: ${calculateCompletionPercentage(completedAchievements.length, achievements.length)}%',
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (completedAchievements.length > 0) Text(
                      AppLocalizations.of(context)!.completedAchievements,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Stack(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: completedAchievements.length,
                          itemBuilder: (context, index) {
                            final completedAchievement =
                            completedAchievements[index];
                            final achievement = achievements.firstWhere(
                                    (achieve) =>
                                achieve.id ==
                                    completedAchievement.achievementId);

                            return AchievementItem(
                              onTap: null,
                              logo: 'https://achieveclub-ekdpajekhkd0amct.polandcentral-01.azurewebsites.net/${achievement.logoURL}',
                              title: achievement.title,
                              description: achievement.description,
                              xp: achievement.xp,
                              completionRatio: achievement.completionRatio,
                              id: achievement.id,
                              isSelected: false,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${AppLocalizations.of(context)!.unCompletedAchievements}:',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Stack(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: achievements.length,
                          itemBuilder: (context, index) {
                            final achievement = achievements[index];
                            final isCompleted = completedAchievements.any(
                                    (completed) =>
                                completed.achievementId == achievement.id);

                            if (!isCompleted) {
                              return AchievementItem(
                                onTap: null,
                                logo: 'https://achieveclub-ekdpajekhkd0amct.polandcentral-01.azurewebsites.net/${achievement.logoURL}',
                                title: achievement.title,
                                description: achievement.description,
                                xp: achievement.xp,
                                completionRatio: achievement.completionRatio,
                                id: achievement.id,
                                isSelected: false,
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}\n ${snapshot.stackTrace}'),
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