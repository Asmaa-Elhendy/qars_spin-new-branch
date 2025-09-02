import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controller/const/colors.dart';

Widget carListGreyBar({required String title,bool squareIcon=false, VoidCallback? onSwap}){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 13.h),
    color: AppColors.divider,
    child: Row(
      children: [
        Text(title,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18.sp
        ),
        ),
        
        Spacer(),
        squareIcon?Container(
          height: 40.h,
          width: 115.w,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.primary, // Yellow color
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: TextField(
           // controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              label: Row(
                children: [
                  SvgPicture.asset("assets/images/new_svg/search.svg",height: 25.h,),
                  6.horizontalSpace,
                  Text("Search",

                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textPrimary,
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
          child:
          Padding(
            padding:  EdgeInsets.only(right: 13.w,left: 3.w), //update icon filter   asmaa
            child: SvgPicture.asset("assets/images/new_svg/swap.svg",height: 25.h,),
          )
          // Icon(Icons.swap_vert_rounded,color: AppColors.white,size: 35.h,),
          // child: Row(
          //   children: [
          //     I
          //     Icon(Icons.arrow_upward_outlined,color: AppColors.white,),
          //   ],
          // ),
        ),

        squareIcon?GestureDetector( //update square asmaa
          onTap: onSwap,
          child:
          SvgPicture.asset("assets/images/new_svg/square.svg",height: 25.h,color: AppColors.white,)

    //      Icon(Icons.grid_view,color: AppColors.white,size: 35.h,),

        ):SizedBox()
        
      ],
      
    ),
  ); 
  
  
}