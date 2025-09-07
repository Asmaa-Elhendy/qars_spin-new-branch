import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/const/colors.dart';

Widget featuredContainer(){

  return Container( //update asmaa
      width: 80.w,
    //  height: 20.h,
    padding: EdgeInsets.symmetric(horizontal: 10.w),

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