import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/const/colors.dart';

Widget carListGreyBar({required String title,bool squareIcon=false, VoidCallback? onSwap}){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 20.h),
    color: AppColors.divider,
    child: Row(
      children: [
        Text(title,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 20.sp
        ),
        ),
        
        Spacer(),
        squareIcon?Container(
          height: 40.h,
          width: 115.w,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700), // Yellow color
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: TextField(
           // controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              label: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 22.w,
                    color: Colors.black,
                  ),
                  6.horizontalSpace,
                  Text("Search",

                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),

              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 10.w,
              ),
              isDense: true,
            ),
            onChanged: (_){},
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ):SizedBox(),

        GestureDetector(
          onTap: (){},
          child: Icon(Icons.swap_vert,color: AppColors.white,size: 35.h,),
          // child: Row(
          //   children: [
          //     I
          //     Icon(Icons.arrow_upward_outlined,color: AppColors.white,),
          //   ],
          // ),
        ),

        squareIcon?GestureDetector(
          onTap: onSwap,
          child: Icon(Icons.grid_view,color: AppColors.white,size: 35.h,),

        ):SizedBox()
        
      ],
      
    ),
  ); 
  
  
}