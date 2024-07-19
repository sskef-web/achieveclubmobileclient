import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    super.key,
    required this.logo,
    required this.id,
    required this.title,
    required this.description,
    required this.xp,
    required this.completionRatio,
    required this.isSelected,
    required this.onTap,
  });

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
        leading: CachedNetworkImage(
          imageUrl: widget.logo,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        title: Text(widget.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description),
            const SizedBox(height: 4.0),
            Text('XP: ${widget.xp}'),
            const SizedBox(height: 4.0),
            Text('${AppLocalizations.of(context)!.completePercent}: ${widget.completionRatio}%'),
          ],
        ),
      ),
    );
  }
}