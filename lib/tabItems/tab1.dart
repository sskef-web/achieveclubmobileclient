import 'dart:convert';
import 'package:achieveclubmobileclient/items/achievementItem.dart';
import 'package:achieveclubmobileclient/data/achievement.dart';
import 'package:achieveclubmobileclient/data/completedachievement.dart';
import 'package:achieveclubmobileclient/data/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../main.dart';

class Tab1Page extends StatefulWidget {
  const Tab1Page({super.key});

  @override
  _Tab1Page createState() => _Tab1Page();
}

class _Tab1Page extends State<Tab1Page> {
  late Future<User> _userFuture;
  late Future<List<Achievement>> _achieveFuture;
  late Future<List<CompletedAchievement>> _completedAchievementsFuture;
  bool _isFloatingActionButtonVisible = false;
  //int _completedAchievementsCount = 0;
  //int _totalAchievementsCount = 0;

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
  }

  String? extractTokenFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-Access-Token')) {
        var token = cookie.split('=')[1];
        return token;
      }
    }
    return null;
  }

  String? extractRefreshTokenFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-Refresh-Token')) {
        var token = cookie.split('=')[1];
        return token;
      }
    }
    return null;
  }

  String? extractUserIdFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-User-Id')) {
        var userId = cookie.split('=')[1];
        return userId;
      }
    }
    return null;
  }

  Future<List<CompletedAchievement>> fetchCompletedAchievements() async {
    var url = Uri.parse('${baseURL}completedachievements');
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
      throw Exception('Failed to load completed achievements');
    }
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
          'Failed to refresh Token (StatusCode: ${response.statusCode})\n${response.body}');
    }
  }

  Future<User> fetchUser() async {
    var url = Uri.parse('${baseURL}users/$userId');
    var cookies = await loadCookies();
    userId = extractUserIdFromCookies(cookies!);
    appTitle = 'Профиль';

    var response = await http.get(url, headers: {
      'Cookie': cookies,
    });

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      await refreshToken();
      return fetchUser();
    } else {
      throw Exception('Failed to load user');
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

  void generateQrCode(
    BuildContext context,
    String userId,
    List<int> selectedAchievementIds,
    String firstName,
    String lastName,
    String avatarPath,
  ) async {
    final selectedAchievements = <String>[];

    for (final achievementId in selectedAchievementIds) {
      final achievement = await getAchievementById(achievementId);
      if (achievement != null) {
        selectedAchievements.add(achievement.title);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          NetworkImage('https://sskef.site/$avatarPath'),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Text(
                            '$firstName $lastName',
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Достижения: ${selectedAchievements.length}\n${selectedAchievements.join(", ")}',
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: QrImageView(
                    data: '$userId:${selectedAchievementIds.join(":")}',
                    version: QrVersions.auto,
                    size: 200.0,
                    padding: const EdgeInsets.all(21),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Пожалуйста, покажите QR-код тренеру',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double calculateCompletionPercentage(
      int completedAchievements, int totalAchievements) {
    if (totalAchievements == 0) {
      return 0.0;
    }

    double percentage = (completedAchievements / totalAchievements) * 100;
    return percentage;
  }

  Future<List<Achievement>> fetchAchievements() async {
    final response = await http.get(Uri.parse('${baseURL}achievements'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Achievement.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load achievements');
    }
  }

  void _uploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    var cookies = await loadCookies();

    if (pickedImage != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseURL}avatar'),
      );
      request.headers['Cookie'] = cookies!;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          pickedImage.path,
        ),
      );

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          var imageUrl = response.body;

          setState(() {
            Avatar = imageUrl;
          });
        } else {
          print('Error uploading avatar. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error uploading avatar: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<List<dynamic>>? currentSnapshot;
    return Scaffold(
      floatingActionButton: _isFloatingActionButtonVisible
          ? FloatingActionButton(
        onPressed: () {
          final user = currentSnapshot!.data![0] as User;
          generateQrCode(
            context,
            userId,
            selectedAchievementIds,
            user.firstName,
            user.lastName,
            user.avatar,
          );
        },
        child: const Icon(Icons.qr_code),
      )
          : null,
      body: FutureBuilder(
        future: Future.wait(
            [_userFuture, _achieveFuture, _completedAchievementsFuture]),
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
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage:
                              NetworkImage('https://sskef.site/$Avatar'),
                          child: InkWell(
                            onTap: () {
                              _uploadAvatar(context);
                            },
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
                          backgroundImage: NetworkImage(
                              'https://sskef.site/${user.clubLogo}'),
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
                            'Выполнено достижений: ${completedAchievements.length}',
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
                              onTap: () {
                                setState(() {});
                              },
                              logo: 'https://sskef.site/${achievement.logoURL}',
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
                    const Text(
                      'Невыполненные достижения:',
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
                          itemCount: achievements.length,
                          itemBuilder: (context, index) {
                            final achievement = achievements[index];
                            final isCompleted = completedAchievements.any(
                                (completed) =>
                                    completed.achievementId == achievement.id);

                            if (!isCompleted) {
                              return AchievementItem(
                                onTap: () {
                                  setState(() {
                                    if (selectedAchievementIds
                                        .contains(achievement.id)) {
                                      selectedAchievementIds
                                          .remove(achievement.id);
                                      updateFloatingActionButtonVisibility();
                                    } else {
                                      selectedAchievementIds
                                          .add(achievement.id);
                                      updateFloatingActionButtonVisibility();
                                    }
                                  });
                                },
                                logo:
                                    'https://sskef.site/${achievement.logoURL}',
                                title: achievement.title,
                                description: achievement.description,
                                xp: achievement.xp,
                                completionRatio: achievement.completionRatio,
                                id: achievement.id,
                                isSelected: selectedAchievementIds
                                    .contains(achievement.id),
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
  void updateFloatingActionButtonVisibility() {
    setState(() {
      _isFloatingActionButtonVisible = selectedAchievementIds.isNotEmpty;
    });
  }

}
