import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class UserTopItem extends StatelessWidget {
  final int id;
  final String firstName;
  final String lastName;
  final String avatarPath;
  final String clubLogo;
  final int userXP;
  final int topPosition;
  final VoidCallback? onTap;

  const UserTopItem({
    super.key,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarPath,
    required this.clubLogo,
    required this.userXP,
    required this.topPosition,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color.fromRGBO(11, 106, 108, 0.25)
          : Color.fromRGBO(255, 255, 255, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: CachedNetworkImageProvider('$baseURL/$avatarPath'),
            backgroundColor: Colors.transparent,
            onBackgroundImageError: (exception, stackTrace) => Icon(Icons.error, color: Colors.grey,),
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
              Text('$userXP XP', style: const TextStyle(fontSize: 12.0)),
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
                    Text('# $topPosition', textAlign: TextAlign.center, textScaler: const TextScaler.linear(2)),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}