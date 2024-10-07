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
  final int completionCount;
  final bool isMultiple;

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
    required this.completionCount,
    required this.isMultiple
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
    return Stack(
      children: [
        Card(
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
                const SizedBox(height: 8.0),
                //Text('XP: ${widget.xp}'),
                Wrap(
                  spacing: 2.0,
                  runSpacing: 8.0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromRGBO(11, 106, 108, 1)
                            : const Color.fromRGBO(11, 106, 108, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 2.0, bottom: 2.0),
                      child: Text(
                        'Процент выполнений: ${widget.completionRatio} %',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    if (widget.isMultiple)
                      Container(
                        padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 2.0, bottom: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromRGBO(11, 106, 108, 1)
                              : const Color.fromRGBO(11, 106, 108, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.xp}XP ✕ ${widget.completionCount + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}