import 'package:achieveclubmobileclient/data/userTopItem.dart';
import 'package:flutter/material.dart';

class Tab2Page extends StatelessWidget {
  const Tab2Page({super.key});

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
                          return UserTopItem(
                            onTap: null,
                            firstName: 'Name',
                            lastName: 'Surname',
                            avatarPath: 'StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
                            userXP: 150195,
                            clubLogo: 'StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
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