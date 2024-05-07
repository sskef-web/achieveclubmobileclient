import 'package:achieveclubmobileclient/items/clubTopItem.dart';
import 'package:achieveclubmobileclient/pages/clubPage.dart';
import 'package:flutter/material.dart';

class Tab3Page extends StatefulWidget {
  const Tab3Page({super.key});

  @override
  _Tab3Page createState() => _Tab3Page();

}

class _Tab3Page extends State<Tab3Page> {

  final clubId = 1;

  void navigateToClubPage(int clubId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubPage(clubId: clubId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: null,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, index)
                    {
                      return ClubTopItem(
                        onTap: () {
                          navigateToClubPage(clubId);
                        },
                        clubName: 'Dvorec',
                        clubLogo: 'StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
                        xp: 150195,
                        topPosition: 1,
                        id: 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}