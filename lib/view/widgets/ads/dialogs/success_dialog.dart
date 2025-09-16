import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessDialog {
  static void show(BuildContext context, String postId, VoidCallback? onOkPressed, {bool isModifyMode = false}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: Text(isModifyMode ? 'Ad updated successfully!' : 'Ad created successfully!'),
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
