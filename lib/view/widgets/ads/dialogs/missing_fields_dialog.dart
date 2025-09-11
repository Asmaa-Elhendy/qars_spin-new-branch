import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MissingFieldsDialog {
  static void show(BuildContext context, List<String> missingFields) {
    String fieldsText = missingFields.join(', ');
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Missing Information'),
        content: Text('Please fill in the following required fields:\n$fieldsText'),
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
