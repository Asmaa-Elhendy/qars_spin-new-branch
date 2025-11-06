import 'package:flutter/material.dart';
import 'package:qarsspin/controller/const/colors.dart';

void showSuccessSnackBar(BuildContext context,msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.blackColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      content: Row(
        children: [
           Icon(Icons.check_circle, color: AppColors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
            msg,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
