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
    elevation: .4,
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
            child: Image.asset(
              'assets/images/logo_the_q.png',
              width: 20,
              height: 20,
            ),
          ),
          if (notificationCount > 0)
            Positioned(
              right: 7,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                constraints:
                const BoxConstraints(minWidth: 14, minHeight: 14),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
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
                    fontWeight: FontWeight.bold,
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