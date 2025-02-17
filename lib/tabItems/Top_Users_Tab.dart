import 'dart:convert';

import '../data/User.dart';
import '../items/User_Top_Item.dart';
import '../main.dart';
import '../pages/User_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Tab2Page extends StatefulWidget {
  final Function() logoutCallback;
  const Tab2Page({
    super.key,
    required this.logoutCallback
  });

  @override
  _Tab2Page createState() => _Tab2Page();

}

class _Tab2Page extends State<Tab2Page> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    var url = Uri.parse('${baseURL}api/users');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<User> users = [];
      for (final userData in data) {
        users.add(User.fromJson(userData));
      }
      return users;
    } else {
      throw Exception('Ошибка при получении пользователя');
    }
  }

  void navigateToUser(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserPage(
              userId: userId,
              logoutCallback: widget.logoutCallback,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data!;
            users.sort((a, b) => b.xpSum.compareTo(a.xpSum));
            users = users.take(100).toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        User user = users[index];

                        return UserTopItem(
                          onTap: () {
                            navigateToUser(user.id);
                          },
                          firstName: user.firstName,
                          lastName: user.lastName,
                          avatarPath: user.avatar,
                          userXP: user.xpSum,
                          // clubLogo: user.clubLogo,
                          topPosition: index + 1,
                          id: user.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка при построении страницы: ${snapshot.error}');
          } else {
            return const Center (child:CircularProgressIndicator());
          }
        },
      ),
    );
  }
}