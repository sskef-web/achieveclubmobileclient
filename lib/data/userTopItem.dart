import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          onTap: onTap,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://sskef.site/$avatarPath'),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$firstName $lastName'),
                  Text('$userXP XP'),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('# $topPosition', textAlign: TextAlign.center),
                ],
              ),
              const SizedBox(width: 16.0),
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://sskef.site/$clubLogo'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}