import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controller/const/colors.dart';



blueText(text){

  return Text(text,
  style: TextStyle(
    color: AppColors.accent,
    fontSize: 16.sp,

  ),

  );

}

headerText(text){

  return Text(text,
    style: TextStyle(
      color: AppColors.black,
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
    ),

  );


}
description(text) {
  return Text(text,
    style: TextStyle(
      color: AppColors.black,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),

  );
}
greyText(text) {
  return Text(text,
    style: TextStyle(
      color: AppColors.gray,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),

  );
}
price(text) {
  return Text(text,
    style: TextStyle(
      color: AppColors.star,
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
    ),

  );
}
boldGrey(text) {
  return Text(text,
    style: TextStyle(
      color: AppColors.gray,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
    ),

  );
}