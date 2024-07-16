import 'dart:convert';
import 'package:achieveclubmobileclient/main.dart';
import 'package:http/http.dart' as http;
import 'package:achieveclubmobileclient/data/club.dart';
import 'package:achieveclubmobileclient/items/clubTopItem.dart';
import 'package:achieveclubmobileclient/pages/clubPage.dart';
import 'package:flutter/material.dart';

class Tab3Page extends StatefulWidget {
  final Function() logoutCallback;
  const Tab3Page({
    super.key,
    required this.logoutCallback
  });

  @override
  _Tab3Page createState() => _Tab3Page();

}

class _Tab3Page extends State<Tab3Page> {

  late Future<List<Club>> _clubs;

  @override
  void initState() {
    super.initState();
    _clubs = fetchClubs();
  }

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
    var url = Uri.parse('${baseURL}clubs');
    var response = await http.get(url);

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
      throw Exception('Błąd podczas ładowania klubów');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Club>>(
      future: _clubs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var clubs = snapshot.data!;
          clubs.sort((a, b) => b.avgXp.compareTo(a.avgXp));

          return SingleChildScrollView(
            child: ListView.builder(
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
          );
        } else if (snapshot.hasError) {
          return Text('Błąd: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}