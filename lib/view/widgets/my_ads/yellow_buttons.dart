import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';

Widget yellowButtons({required BuildContext context,required String title,required var onTap,required double w,bool green = false,bool grey = false}){

  return InkWell(
    onTap: onTap,
    child: Container(
      width: w,
      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 10.h),
      decoration: BoxDecoration(
        color: grey?AppColors.textSecondary(context):green?AppColors.publish:AppColors.primary,
        borderRadius: BorderRadius.circular(4), // optional rounded corners

      ),
      child: Center(
        child: Text(title,

        style: TextStyle(
          color: AppColors.black,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
        ),
        ),
      ),
    ),

  );

}