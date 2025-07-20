import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show DateFormat;

class Headerpage extends StatelessWidget {
  final String title;
  final bool showDate;

  const Headerpage({super.key, required this.title, this.showDate = true});

  String getFormattedDate() {
    final DateTime now = DateTime.now();
    final formatter = DateFormat("EEEE d MMM", "it_IT");
    final formatted = formatter.format(now);
    return formatted.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            showDate
                ? Text(
                    getFormattedDate(),
                    style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white)),
          ]),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: CupertinoColors.activeBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.settings,
              color: CupertinoColors.white,
            ),
          ),
        ]));

  }
}
