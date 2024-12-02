import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:http/http.dart' as http;
import 'package:achieveclubmobileclient/data/club.dart';
import 'package:achieveclubmobileclient/items/clubTopItem.dart';
import 'package:achieveclubmobileclient/pages/clubPage.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import '../items/customDotIndicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
>>>>>>> Stashed changes

class Tab3Page extends StatefulWidget {
  final Function() logoutCallback;
  const Tab3Page({
    super.key,
    required this.logoutCallback
  });

  @override
  _Tab3Page createState() => _Tab3Page();

}

<<<<<<< Updated upstream
class _Tab3Page extends State<Tab3Page> {
  String locale = "";
  late Future<List<Club>> _clubs;

  @override
  void initState() {
    super.initState();
  }
=======
class _Tab3PageState extends State<Tab3Page> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  late List<Map<String, dynamic>> data = [];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      data = [
        {
          'title': AppLocalizations.of(context)!.achievementTitle,
          'description': AppLocalizations.of(context)!.achievementDescription,
          'icon': Icons.qr_code
        },
        {
          'title': AppLocalizations.of(context)!.earnPdTitle,
          'description': AppLocalizations.of(context)!.earnPdDescription,
          'icon': Icons.assistant_rounded
        },
        {
          'title': AppLocalizations.of(context)!.multipleAchievementsTitle,
          'description': AppLocalizations.of(context)!.multipleAchievementsDescription,
          'icon': Icons.auto_awesome_rounded
        },
        {
          'title': AppLocalizations.of(context)!.topUsersTitle,
          'description': AppLocalizations.of(context)!.topUsersDescription,
          'icon': Icons.groups
        },
      ];
    });
>>>>>>> Stashed changes

  void navigateToClubPage(int clubId, String position) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClubPage(
              clubId: clubId,
              position: position,
              logoutCallback: widget.logoutCallback,
            ),
      ),
    );
  }

  Future<List<Club>> fetchClubs() async {
    var url = Uri.parse('${baseURL}api/clubs');
    var response = await http.get(url,
        headers: {
          'Accept-Language': locale
        }
        );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var clubList = <Club>[];

      for (var clubData in data) {
        var club = Club(
          id: clubData['id'],
          title: clubData['title'],
          logoURL: clubData['logoURL'],
          avgXp: clubData['avgXp'],
          description: '',
          address: '',
        );
        clubList.add(club);
      }

      return clubList;
    } else {
      throw Exception(AppLocalizations.of(context)!.fetchClubsError);
    }
  }

  @override
  Widget build(BuildContext context) {
    locale = Localizations.localeOf(context).languageCode;
    _clubs = fetchClubs();
    return FutureBuilder<List<Club>>(
      future: _clubs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var clubs = snapshot.data!;
          clubs.sort((a, b) => b.avgXp.compareTo(a.avgXp));
          return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: clubs.length,
                      itemBuilder: (context, index) {
                        final club = clubs[index];
                        final position = (index + 1).toString();
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClubTopItem(
                                onTap: () {
                                  navigateToClubPage(club.id, position);
                                },
                                clubName: club.title,
                                clubLogo: club.logoURL,
                                xp: club.avgXp,
                                id: club.id,
                                position: position,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                )
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}