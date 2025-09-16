import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context, {bool isModifyMode = false}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(isModifyMode ? 'Updating Ad' : 'Creating Ad'),
        content: Row(
          children: [
            CupertinoActivityIndicator(),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                isModifyMode 
                    ? 'Please wait while your ad is being updated...' 
                    : 'Please wait while your ad is being created...',
              ),
            ),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
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
