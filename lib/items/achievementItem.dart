import 'package:flutter/material.dart';

class AchievementItem extends StatefulWidget {
  final String logo;
  final int id;
  final String title;
  final String description;
  final int xp;
  final int completionRatio;
  final bool isSelected;
  final VoidCallback? onTap;

  const AchievementItem({
    Key? key,
    required this.logo,
    required this.id,
    required this.title,
    required this.description,
    required this.xp,
    required this.completionRatio,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _AchievementItemState createState() => _AchievementItemState();
}

class _AchievementItemState extends State<AchievementItem> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant AchievementItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue : null,
      child: ListTile(
        onTap: widget.onTap,
        leading: Image.network(widget.logo),
        title: Text(widget.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description),
            const SizedBox(height: 4.0),
            Text('XP: ${widget.xp}'),
            const SizedBox(height: 4.0),
            Text('Процент выполнения: ${widget.completionRatio}%'),
          ],
        ),
      ),
    );
  }
}