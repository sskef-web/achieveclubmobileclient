import 'dart:async';
import 'dart:convert';
import '../data/Category.dart';
import '../pages/Authentication_Page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../items/Achievement_Item.dart';
import '../data/Achievement.dart';
import '../data/Completed_Achievement.dart';
import '../data/User.dart';
import '../pages/Club_Page.dart';
import '../pages/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../main.dart';

class Tab1Page extends StatefulWidget {
  final Function() logoutCallback;
  String locale;

  Tab1Page({super.key, required this.logoutCallback, required this.locale});

  @override
  _Tab1Page createState() => _Tab1Page();
}

class _Tab1Page extends State<Tab1Page> {
  late Future<User> _userFuture;
  late Future<List<Achievement>> _achieveFuture;
  late Future<List<CompletedAchievement>> _completedAchievementsFuture;
  late Future<List<Category>> _categoriesFuture;
  bool _isFloatingActionButtonVisible = false;
  bool _showCompletedAchievements = false;
  late String Avatar = '';
  var userId;
  List<int> selectedAchievementIds = [];
  List<int> multipleSelectedAchievementIds = [];
  List<CompletedAchievement> multipleCompletedAchievements = [];
  List<CompletedAchievement> nonMultipleCompletedAchievements = [];
  List<Category> categories = [];
  String searchText = '';
  int? _selectedCategoryId;

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

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${baseURL}api/tags'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<CompletedAchievement>> fetchCompletedAchievements() async {
    var url = Uri.parse('${baseURL}api/completedachievements/current');
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
      throw Exception('Ошибка при получении всех достижений.');
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

  void navigateToClubPage(int clubId, String position) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubPage(
          clubId: clubId,
          position: position,
          logoutCallback: widget.logoutCallback,
        ),
      ),
    );
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
      widget.logoutCallback();
      navigateToAuthPage();
      throw Exception(
          'Ошибка при обновлении токена (code: ${response.statusCode}');
    }
  }

  void _updatePage() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => HomePage(
                logoutCallback: widget.logoutCallback,
              )),
    );
  }

  Future<User> fetchUser() async {
    var cookies = await loadCookies();
    userId = extractUserIdFromCookies(cookies!);
    var url = Uri.parse('${baseURL}api/users/${userId}');
    debugPrint(url.toString());
    debugPrint(Localizations.localeOf(context).languageCode);

    var response = await http.get(url,
        headers: {'Cookie': cookies, 'Accept-Language': widget.locale});
    debugPrint('${response.statusCode}');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      await refreshToken();
      _updatePage();
      return fetchUser();
    } else {
      throw Exception('Ошибка при получении пользователя');
    }
  }

  Future<List<Achievement>> fetchAchievements() async {
    debugPrint('LOCALE: $widget.locale');
    final response = await http.get(Uri.parse('${baseURL}api/achievements'),
        headers: {'Accept-Language': widget.locale});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Achievement.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка при получении достижений');
    }
  }

  void _uploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    var cookies = await loadCookies();

    if (pickedImage != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseURL}api/avatar'),
      );
      request.headers['Authorization'] =
          'Bearer ${extractTokenFromCookies(cookies!)}';

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
          throw Exception(
              'Ошибка при загрузке аватара. Code: ${response.statusCode} \n ${response.body}');
        }
      } catch (error) {
        throw Exception('Ошибка при загрузке аватара: $error');
      }
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
          backgroundColor: Color.fromRGBO(27, 26, 31, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: '$baseURL${achievement.logoURL}',
                  width: 50.0,
                  height: 50.0,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    _updatePage();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(38, 38, 38, 1)),
                  child: Text('Закрыть'),
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
    List<int> multipleSelectedAchievementIds,
    String firstName,
    String lastName,
    String avatarPath,
  ) async {
    debugPrint(multipleSelectedAchievementIds.isNotEmpty
        ? selectedAchievementIds.isNotEmpty
            ? '$userId:${selectedAchievementIds.join(":")}:${multipleSelectedAchievementIds.join(":")}'
            : '$userId:${multipleSelectedAchievementIds.join(":")}'
        : '$userId:${selectedAchievementIds.join(":")}');
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
                    SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: '$baseURL$Avatar',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
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
                    children: [
                      ...selectedAchievementIds.map((achievementId) {
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
                                    color: const Color.fromRGBO(
                                        128, 128, 128, 0.2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          '$baseURL${achievement.logoURL}',
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
                      ...multipleSelectedAchievementIds.map((achievementId) {
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
                                    color: const Color.fromRGBO(
                                        128, 128, 128, 0.2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          '$baseURL${achievement.logoURL}',
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '${achievement.title}',
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
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: QrImageView(
                    data: multipleSelectedAchievementIds.isNotEmpty
                        ? selectedAchievementIds.isNotEmpty
                            ? '$userId:${selectedAchievementIds.join(":")}:${multipleSelectedAchievementIds.join(":")}'
                            : '$userId:${multipleSelectedAchievementIds.join(":")}'
                        : '$userId:${selectedAchievementIds.join(":")}',
                    version: QrVersions.auto,
                    size: 200.0,
                    padding: const EdgeInsets.all(21),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Пожалуйста, покажите QR-код тренеру.',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFF56E0F)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
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
                  child: Text('Закрыть'),
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
    return double.parse(percentage.toStringAsFixed(2));
  }

  void updateFloatingActionButtonVisibility() {
    if (selectedAchievementIds.isNotEmpty ||
        multipleSelectedAchievementIds.isNotEmpty) {
      debugPrint(
          'Selected - ${selectedAchievementIds.length}\n Multiple - ${multipleSelectedAchievementIds.length}');
      setState(() {
        _isFloatingActionButtonVisible = true;
      });
    } else {
      setState(() {
        _isFloatingActionButtonVisible = false;
      });
    }
  }

  void navigateToAuthPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => AuthenticationPage()),
    );
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
            multipleSelectedAchievementIds,
            user.firstName,
            user.lastName,
            user.avatar,
          );
        },
        child: const Icon(Icons.qr_code),
      )
          : null,
      body: FutureBuilder(
        future: Future.wait([
          _userFuture,
          _achieveFuture,
          _completedAchievementsFuture,
          _categoriesFuture
        ]),
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
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16.0),
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
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
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
                    const SizedBox(height: 16.0),
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
                            style: const TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Процент выполненных достижений: ${calculateCompletionPercentage(completedAchievements.length, achievements.length)}%',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18.0, height: 1),
                          ),
                          const SizedBox(height: 16.0),
                          LinearProgressIndicator(
                            color:
                            Theme.of(context).brightness == Brightness.dark
                                ? const Color.fromRGBO(245, 110, 15, 1)
                                : const Color.fromRGBO(245, 110, 15, 1),
                            backgroundColor: Colors.white,
                            value: calculateCompletionPercentage(
                                completedAchievements.length,
                                achievements.length) /
                                100,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(height: 8.0),
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
                                        setState(() {
                                          if (selectedAchievementIds.contains(achievement.id)) {
                                            selectedAchievementIds.remove(achievement.id);
                                          } else {
                                            selectedAchievementIds.add(achievement.id);
                                          }
                                          updateFloatingActionButtonVisibility();
                                        });
                                      },
                                      logo: '$baseURL${achievement.logoURL}',
                                      title: achievement.title,
                                      description: achievement.description,
                                      xp: achievement.xp,
                                      id: achievement.id,
                                      isSelected: selectedAchievementIds.contains(achievement.id),
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
              child: Text(
                  'Ошибка при формировании страницы (Snapshot error) ${snapshot.error}'),
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
