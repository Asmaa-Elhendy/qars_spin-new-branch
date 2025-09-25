import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import '../../../controller/const/colors.dart';



blueText(text){

  return Text(text,
    style: TextStyle(
      fontFamily: fontFamily,
      color: AppColors.accent,
      fontSize: 12.sp,

    ),

  );

}

headerText(text){

  return Text(text,
    style: TextStyle(
      color: AppColors.black,
      fontSize: 16.sp,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
    ),

  );


}
description(text, {bool small = false}) {
  return Text(text,
    style: TextStyle(
      color: AppColors.black,
      fontSize: small?12.sp:14.sp,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
    ),

  );
}
greyText(text) {
  return Text(text,
    style: TextStyle(
      color: AppColors.gray,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),

  );
}
price(text,{bool small =false}) {
  return Text(text,
    style: TextStyle(
      color: AppColors.star,
      fontFamily: fontFamily,
      fontSize: small?16.sp:18.sp,
      fontWeight: FontWeight.w700,
    ),

  );
}
boldGrey(text) {
  return Text(text,
    style: TextStyle(
      color: AppColors.gray,
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w800,
    ),

  );
}
hintText(text){
  return Text(text,
    style: TextStyle(
      color: AppColors.darkGray,
      fontFamily: fontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    ),

  );


}