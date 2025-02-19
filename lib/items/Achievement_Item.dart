import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AchievementItem extends StatefulWidget {
  final String logo;
  final int id;
  final String title;
  final String description;
  final int xp;

  // final int completionRatio;
  final bool isSelected;
  final VoidCallback? onTap;
  final int completionCount;
  final bool isMultiple;
  final int? nextTryUnix;

  const AchievementItem(
      {super.key,
      required this.logo,
      required this.id,
      required this.title,
      required this.description,
      required this.xp,
      // required this.completionRatio,
      required this.isSelected,
      required this.onTap,
      required this.completionCount,
      required this.isMultiple,
      required this.nextTryUnix});

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
    String? nextTryDate;

    if (widget.nextTryUnix != null) {
      nextTryDate =
          "${DateTime.fromMillisecondsSinceEpoch(widget.nextTryUnix! * 1000).day.toString().padLeft(2, '0')}"
          ".${DateTime.fromMillisecondsSinceEpoch(widget.nextTryUnix! * 1000).month.toString().padLeft(2, '0')}"
          ".${DateTime.fromMillisecondsSinceEpoch(widget.nextTryUnix! * 1000).year}";
    }

    return Stack(
      children: [
        Card(
          color: isSelected
              ? Color(0xFF5B5B5B)
              : Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromRGBO(38, 38, 38, 1)
                  : const Color(0xFFDEDEDE),
          child: ListTile(
            contentPadding:
                EdgeInsets.only(top: 4.0, bottom: 8.0, right: 10, left: 10),
            onTap: widget.onTap,
            leading: Image.network(widget.logo),
            title: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.0,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : isSelected
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      right: 8.0, left: 8.0, top: 2.0, bottom: 2.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromRGBO(245, 110, 15, 1)
                        : const Color.fromRGBO(245, 110, 15, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.xp}XP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                // widget.isMultiple ? Container(
                //   padding: EdgeInsets.only(
                //       right: 8.0, left: 8.0, top: 2.0, bottom: 2.0),
                //   decoration: BoxDecoration(
                //     color: Theme
                //         .of(context)
                //         .brightness == Brightness.dark
                //         ? const Color.fromRGBO(245,110, 15, 1)
                //         : const Color.fromRGBO(245,110, 15, 1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     '${widget.completionCount}',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //     ),
                //   ),
                // ) : SizedBox(),
              ],
            ),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.description,
                        style: TextStyle(
                          height: 1,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : isSelected
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ])),
          ),
        ),
        if (nextTryDate != null) ...[
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.8),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(
                child: Text(
                  'Следующее выполнение: $nextTryDate',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
