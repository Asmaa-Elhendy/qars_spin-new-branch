import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/const/colors.dart';


 carListAppBar({required int notificationCount}){

  return AppBar(
    centerTitle: true,
    backgroundColor: AppColors.background,
    toolbarHeight: 60.h,
    shadowColor: Colors.grey.shade300,
    // elevation: 3,
    elevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow( //update asmaa
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5.h,
            offset: Offset(0, 2),
          ),
        ],
      ),
    ),
    leading: // Menu Button
    GestureDetector(onTap: () {
      Get.back();
    }, child: Icon(Icons.arrow_back)),
    actions: [
      // Account Button with Notification Counter (smaller)
      Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding:  EdgeInsets.only(right: 15.w),
              child: Image.asset(
                'assets/images/logo_the_q.png',
                width: 40.w, //update asmaa
                height: 35.h,
              ),
            ),
          ),
          if (notificationCount > 0)  //update icon - asmaa
            Positioned(
              right: 40.w,//update asmaa
              top: 10.h,
              child: Container(height: 18.h,
                constraints:
                const BoxConstraints(minWidth: 14, minHeight: 8),
                decoration: BoxDecoration(
                  color: Color(0xffEC6D64),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 3,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    notificationCount > 99
                        ? '99+'
                        : notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      //    fontWeight: FontWeight.bold, //update asmaa
                    ),
                  ),
                ),
              ),
            ),
        ],
      )
    ],

    title: SizedBox(
      height: 140,
      width: 140,
      child: Image.asset(
        'assets/images/ic_top_logo_colored.png',
        fit: BoxFit.cover,
      ),
    ),
  );
}