import 'package:flutter/material.dart';

class ClubTopItem extends StatelessWidget {
  final int id;
  final String clubName;
  final String clubLogo;
  final int xp;
  final int topPosition;
  final VoidCallback? onTap;

  const ClubTopItem({
    super.key,
    required this.id,
    required this.clubName,
    required this.clubLogo,
    required this.xp,
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
                    image: NetworkImage('https://sskef.site/$clubLogo'),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Club "$clubName"', textScaler: const TextScaler.linear(1.3)),
                  Text('Average xp: $xp XP', textScaler: const TextScaler.linear(1.3)),
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