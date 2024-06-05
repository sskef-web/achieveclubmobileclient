import 'dart:convert';
import 'package:achieveclubmobileclient/items/achievementItem.dart';
import 'package:achieveclubmobileclient/data/achievement.dart';
import 'package:achieveclubmobileclient/data/completedachievement.dart';
import 'package:achieveclubmobileclient/data/user.dart';
import 'package:achieveclubmobileclient/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../main.dart';

class Tab1Page extends StatefulWidget {
  final Function() logoutCallback;

  const Tab1Page({super.key, required this.logoutCallback});

  @override
  _Tab1Page createState() => _Tab1Page();
}

class _Tab1Page extends State<Tab1Page> {
  late Future<User> _userFuture;
  late Future<List<Achievement>> _achieveFuture;
  late Future<List<CompletedAchievement>> _completedAchievementsFuture;
  bool _isFloatingActionButtonVisible = false;
  late String Avatar = '';
  var userId;
  List<int> selectedAchievementIds = [];

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
    var url = Uri.parse('${baseURL}completedachievements/current');
    var cookies = await loadCookies();
    appTitle = "Профиль";

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
      throw Exception('Ошибка при загрузке выполненных достижений');
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
    var refreshUrl = Uri.parse('${baseURL}auth/refresh');
    var cookies = await loadCookies();
    appTitle = "Профиль";

    var response = await http.get(refreshUrl, headers: {
      'Cookie': cookies!,
    });

    if (response.statusCode == 200) {
      var newCookies = response.headers['set-cookie'];
      if (newCookies != null) {
        await saveCookies(newCookies);
      }
    } else {
      throw Exception('Ошибка обновления токена (Код: ${response.statusCode}');
    }
  }

  Future<void> updatePage() async{
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              HomePage(logoutCallback: widget.logoutCallback)),
    );
  }

  Future<User> fetchUser() async {
      var cookies = await loadCookies();
      userId = extractUserIdFromCookies(cookies!);
      var url = Uri.parse('${baseURL}users/$userId');
      appTitle = 'Профиль';

      var response = await http.get(url, headers: {
        'Cookie': cookies,
      });
      debugPrint('${response.statusCode}');

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
      else if (response.statusCode == 401) {
        await refreshToken();
        await updatePage();
        return fetchUser();
      } else {
        throw Exception('Ошибка при загрузке пользователя');
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

  void showAchievementDialog(BuildContext context, Achievement achievement) {
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
                Image.network(
                  'https://sskef.site/${achievement.logoURL}',
                  width: 50.0,
                  height: 50.0,
                ),
                const SizedBox(height: 8.0),
                Text(
                  achievement.title,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'XP: ${achievement.xp}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
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

  void generateQrCode(
    BuildContext context,
    String userId,
    List<int> selectedAchievementIds,
    String firstName,
    String lastName,
    String avatarPath,
  ) async {
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
                  'Достижения: ${selectedAchievementIds.length}',
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedAchievementIds.map((achievementId) {
                      return FutureBuilder<Achievement?>(
                        future: getAchievementById(achievementId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final achievement = snapshot.data!;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: 100.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(128, 128, 128, 0.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        'https://sskef.site/${achievement.logoURL}',
                                        width: 50.0,
                                        height: 50.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      achievement.title,
                                      style: const TextStyle(fontSize: 12.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),
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
                    selectedAchievementIds = [];
                    Navigator.of(dialogContext).pop();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage(logoutCallback: widget.logoutCallback)),
                    );
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
      throw Exception('Ошибка при загрузке достижений');
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
          throw Exception('Ошибка при смене аватара. Код: ${response.statusCode}');
        }
      } catch (error) {
        throw Exception('Ошибка при смене аватара: $error');
      }
    }
  }

  void updateFloatingActionButtonVisibility() {
    setState(() {
      _isFloatingActionButtonVisible = selectedAchievementIds.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<List<dynamic>>? currentSnapshot;
    return Scaffold(
      floatingActionButton: _isFloatingActionButtonVisible
          ? FloatingActionButton(
        onPressed: () {
          final user = currentSnapshot?.data![0] as User;
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
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage: NetworkImage('https://sskef.site/$Avatar'),
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
                          radius: 50.0,
                          backgroundColor: Colors.grey[200],
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
            return const Center(
              child: Text('Ошибка при загрузке страницы (Snapshot error)'),
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
