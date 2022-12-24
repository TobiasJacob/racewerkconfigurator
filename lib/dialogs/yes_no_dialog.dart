import 'package:flutter/material.dart';

import '../i18n/languages.dart';

Future<bool?> showYesNoDialog(
    BuildContext context, String title, String content) async {
  final lang = Languages.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            return Navigator.of(context).pop(false);
          },
          //return false when click on "NO"
          child: Text(lang.no),
        ),
        ElevatedButton(
          onPressed: () {
            return Navigator.of(context).pop(true);
          },
          //return true when click on "Yes"
          child: Text(lang.yes),
        ),
      ],
    ),
  );
}
