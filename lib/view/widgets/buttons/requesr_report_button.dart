import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controller/const/colors.dart';

Widget requestReportButton(){
  return GestureDetector(
    child: Container(
      width: 350.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration:BoxDecoration(
        color: AppColors.lightGray,

      ),
      child:Center(
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_frames_outlined,color: Colors.black,),
            4.horizontalSpace,
            Text("Request Inspection Report",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp
            ),
            )
          ],
        ),
      ),
    ),
  );



}