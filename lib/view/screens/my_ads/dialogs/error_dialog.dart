import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog {
  static void show(BuildContext context, String errorMessage, VoidCallback? onOkPressed) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text('Failed to create ad: $errorMessage'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
            child: const Text(
              'OK',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
      ),
    );
  }
}
