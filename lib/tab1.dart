import 'dart:convert';
import 'package:achieveclubmobileclient/data/achievementitem.dart';
import 'package:achieveclubmobileclient/data/achievement.dart';
import 'package:achieveclubmobileclient/data/completedachievement.dart';
import 'package:achieveclubmobileclient/data/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'main.dart';

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
    _userFuture.then((user) {
      setState(() {
        Avatar = user.avatar;
      });
    });
    _achieveFuture = fetchAchievements();
    _completedAchievementsFuture = fetchCompletedAchievements();
  }

  Future<List<CompletedAchievement>> fetchCompletedAchievements() async {
    final response = await http.get(Uri.parse('${baseURL}api/completedachievements/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CompletedAchievement.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load completed achievements');
    }
  }

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('${baseURL}api/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Achievement>> fetchAchievements() async {
    final response = await http.get(Uri.parse('${baseURL}api/achievements'));

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

    if (pickedImage != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseURL}api/avatar/$userId'),
      );

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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                    const SizedBox(height: 16.0),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Column(
                      children: [
                        Text(
                          user.clubName,
                          textScaler: const TextScaler.linear(1.3),
                        ),
                        const SizedBox(height: 8.0),
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage('https://sskef.site/${user.clubLogo}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
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
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Процент выполненных достижений: 100%',
                            textAlign: TextAlign.center,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: completedAchievements.length,
                      itemBuilder: (context, index) {
                        final completedAchievement = completedAchievements[index];
                        final achievement = achievements.firstWhere((achieve) => achieve.id == completedAchievement.achievementId);

                        return AchievementItem(
                          logo: 'https://sskef.site/${achievement.logoURL}',
                          title: achievement.title,
                          description: achievement.description,
                          xp: achievement.xp,
                          completionPercentage: 8,
                          //id: achievement.id,
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Достижения:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: achievements.length,
                      itemBuilder: (context, index)
                      {
                        final achievement = achievements[index];
                        final isCompleted = completedAchievements.any((completed) => completed.achievementId == achievement.id);

                        if (!isCompleted) {
                          return AchievementItem(
                            logo: 'https://sskef.site/${achievement.logoURL}',
                            title: achievement.title,
                            description: achievement.description,
                            xp: achievement.xp,
                            completionPercentage: 8,
                            //id: achievement.id,
                          );
                        }
                        return Container();
                      },
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
}