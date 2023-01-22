import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showWarningDialog(BuildContext context,
    {Widget content = const Text('')}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('แจ้งเตือน!'),
        content: content,
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK')),
        ],
      );
    },
  );
}
