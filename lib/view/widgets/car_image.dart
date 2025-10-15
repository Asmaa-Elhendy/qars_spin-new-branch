import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget carImage(path){
  return Container(
    width: double.infinity,
    height: 250.h,
    child: Image.network(path,
    fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 160,
          width: double.infinity,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },

    ),
  );


}