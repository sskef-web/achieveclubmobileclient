import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubTopItem extends StatelessWidget {
  final int id;
  final String clubName;
  final String clubLogo;
  final int xp;
  final VoidCallback? onTap;
  final String position;

  const ClubTopItem({
    super.key,
    required this.id,
    required this.clubName,
    required this.clubLogo,
    required this.xp,
    required this.onTap,
    required this.position
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('# $position', textAlign: TextAlign.center, textScaler: const TextScaler.linear(1.5)),
              const SizedBox(width: 8.0),
              Container(
                width: 40.0,
                height: 40.0,
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
                  Text('${AppLocalizations.of(context)!.club} "$clubName"', textScaler: const TextScaler.linear(1.3)),
                  Text('${AppLocalizations.of(context)!.avgXP}: $xp XP', textScaler: const TextScaler.linear(1.3)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}