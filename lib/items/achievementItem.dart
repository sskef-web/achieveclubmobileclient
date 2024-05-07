import 'package:flutter/material.dart';

class AchievementItem extends StatelessWidget {
  final String logo;
  final int id;
  final String title;
  final String description;
  final int xp;
  final int completionPercentage;
  final VoidCallback? onTap;

  const AchievementItem({
    super.key,
    required this.logo,
    required this.id,
    required this.title,
    required this.description,
    required this.xp,
    required this.completionPercentage,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Image.network(logo),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            //Text('$id'),
            const SizedBox(height: 4.0),
            Text('XP: $xp'),
            const SizedBox(height: 4.0),
            Text('Процент выполнения: $completionPercentage%'),
          ],
        ),
      ),
    );
  }
}