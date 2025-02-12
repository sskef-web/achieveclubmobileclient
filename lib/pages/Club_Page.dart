import '../main.dart';
import '../pages/User_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClubPage extends StatefulWidget {
  final int clubId;
  final String position;
  final Function() logoutCallback;

  const ClubPage({
    super.key,
    required this.clubId,
    required this.position,
    required this.logoutCallback
  });

  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  Map<String, dynamic>? clubData;
  List<dynamic>? userList;
  String locale = "";
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    final clubResponse = await http.get(Uri.parse('${baseURL}api/clubs/${widget.clubId}'),
        headers: {'Accept-Language': locale});

    if (clubResponse.statusCode == 200) {
      final clubData = jsonDecode(clubResponse.body);

      setState(() {
        this.clubData = clubData;
        userList = clubData['users'];
      });
      isDataFetched = true;
      if (clubData['users'] == []) {
        setState(() {
          userList = null;
        });
      }
      debugPrint('fetch user List $userList');
    } else {

      throw Exception('${AppLocalizations.of(context)!.fetchClubsError}: ${clubResponse.body} [${clubResponse.statusCode}]');
    }
  }

  LinearGradient getPositionColor(String position) {
    if (position == "1") {
      // Золотой цвет
      return const LinearGradient(
        colors: [Color(0xffedcf33), Color(0xffdaaa30)],
        stops: [0.25, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (position == "2") {
      // Серебряный цвет
      return const LinearGradient(
        colors: [Color(0xff6a6a6a), Color(0xffd1d1cf)],
        stops: [0.25, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (position == "3") {
      // Бронзовый цвет
      return const LinearGradient(
        colors: [Color(0xffe58f3f), Color(0xffbe7532)],
        stops: [0.25, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xffc9d6ff), Color(0xffe2e2e2)],
        stops: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
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
    locale = Localizations.localeOf(context).languageCode;
    isDataFetched == true ? null : fetchData();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '${AppLocalizations.of(context)!.club} "${clubData?['title']}"',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: clubData != null ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: getPositionColor(widget.position),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     if (int.parse(widget.position) >= 1) Text(
                      '# ${widget.position}',
                      style: const TextStyle(fontSize: 64.0,color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('$baseURL/${clubData?['logoURL']}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromRGBO(11, 106, 108, 0.15)
                      : const Color.fromRGBO(11, 106, 108, 0.15),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.clubHistory,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${clubData?['description']}',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    Text('${clubData?['address']}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userList != [] ? '${AppLocalizations.of(context)!.clubStudents}:' : '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              userList != null
                  ? ListView.builder(
                shrinkWrap: true,
                itemCount: userList!.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final sortedUsers = [...userList!];
                  sortedUsers.sort((a, b) => b['xpSum'].compareTo(a['xpSum']));
                  final user = sortedUsers[index];

                  return ListTile(
                    onTap: () {
                      navigateToUser(user['id']);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('$baseURL/${user['avatar']}'),
                    ),
                    title: Text('${user['firstName']} ${user['lastName']}'),
                    subtitle: Text('${AppLocalizations.of(context)!.avgXP}: ${user['xpSum']}'),
                  );
                },
              )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}