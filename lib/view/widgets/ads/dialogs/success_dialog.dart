import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessDialog {
  static void show(BuildContext context, String postId, VoidCallback? onOkPressed, 
      {bool isModifyMode = false, bool isPublished = false}) {
    
    final String message = isPublished 
        ? 'Your ad is under reviewing \n Thanks for Trusting Qars Spin'
        : isModifyMode 
            ? 'Ad updated successfully!'
            : 'Ad created successfully!';
    
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(isPublished ? '' : 'Success'),
        content: Text(message, textAlign: TextAlign.center),
        actions: isPublished?[]:<CupertinoDialogAction>[//isPublished?
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              FocusScope.of(context).unfocus(); // Unfocus all fields to prevent auto-focus
              Navigator.pop(context);
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
            child: Text(
                'OK',
              style: const TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
      ),
    );
  }
}
