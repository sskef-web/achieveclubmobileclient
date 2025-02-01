import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class UserTopItem extends StatelessWidget {
  final int id;
  final String firstName;
  final String lastName;
  final String avatarPath;
  // final String clubLogo;
  final int userXP;
  final int topPosition;
  final VoidCallback? onTap;

  const UserTopItem({
    super.key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarPath,
    // required this.clubLogo,
    required this.userXP,
    required this.topPosition,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color.fromRGBO(38, 38, 38, 1)
          : Color(0xFFDEDEDE),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          onTap: onTap,
          leading: ClipOval(
            child: CachedNetworkImage(
              imageUrl: '$baseURL/$avatarPath',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  '$firstName $lastName',
                  style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
              ),
              Text('$userXP XP', style: const TextStyle(fontSize: 12.0, color: Color.fromRGBO(245, 110, 15, 1))),
            ],
          ),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 4.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row (
                      children: [
                        Text(
                          '#',
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(2),
                          style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                          ),
                        ),
                        SizedBox(width: 4,),
                        Text(
                          '${topPosition}',
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(2),
                          style: TextStyle(
                              color: Color.fromRGBO(245, 110, 15, 1)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}