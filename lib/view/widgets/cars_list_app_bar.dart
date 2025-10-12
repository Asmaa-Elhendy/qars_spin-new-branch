import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/const/colors.dart';


 carListAppBar({required int notificationCount,required BuildContext context}){

  return AppBar(
    centerTitle: true,
    backgroundColor:AppColors.background(context),
    toolbarHeight: 60.h,
    elevation: 0,
    //shadowColor: AppColors.shadowColor(context),
    shadowColor: Colors.grey.shade300,
    // elevation: 3,

    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: AppColors.background(context),
        boxShadow: [
          BoxShadow( //update asmaa
            color: AppColors.blackColor(context).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5.h,
            offset: Offset(0, 2),
          ),
        ],
      ),
    ),
    leading: GestureDetector(
      onTap: () => Get.back(),
      child: Icon(Icons.arrow_back,
          color: Theme.of(context).iconTheme.color),
    ),
    title: SizedBox(
      height: 140,
      width: 140,
      child: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'assets/images/balckIconDarkMode.png'
            : 'assets/images/black_logo.png',
        fit: BoxFit.cover,
      ),
    ),
    actions: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Image.asset(
                'assets/images/logo_the_q.png',
                width: 40.w,
                height: 35.h,
              ),
            ),
          ),
          if (notificationCount > 0)
            Positioned(
              right: 40.w,
              top: 10.h,
              child: Container(
                height: 18.h,
                constraints: const BoxConstraints(minWidth: 14, minHeight: 8),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 3,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  notificationCount > 99
                      ? '99+'
                      : notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  );

 }