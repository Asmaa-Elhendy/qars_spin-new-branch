import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/const/colors.dart';

Widget featuredContainer(){

  return Container(
      width: 95.w,
      height: 24.h,
     // padding:  EdgeInsets.symmetric(horizontal: 8, vertical: 4.h),
    decoration: BoxDecoration(
      color: AppColors.danger

    ),
    child: Center(
      child: Text("Featured",

      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500
      ),
      ),
    ),

  );
}