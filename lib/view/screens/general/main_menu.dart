import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/Theme_controller.dart';
import '../../../controller/const/colors.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.background(context),
          toolbarHeight: 60.h,
          shadowColor: Colors.grey.shade300,

          elevation: .4,

          title: Text(
            "Main Menu",
            style: TextStyle(
                color: AppColors.blackColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 18.sp
            ),
          )
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 20.w),
        children: [
          // Dark Mode Switch
          Obx(() =>  SwitchListTile(
            title:  Text("Dark Mode",
                style: TextStyle(
                    color: AppColors.blackColor(context),
                    fontSize: 16, fontWeight: FontWeight.w500)),
            secondary:  Icon(Icons.dark_mode, color: AppColors.blackColor(context)),
            value: themeController.themeMode.value == ThemeMode.dark,
            onChanged: (_) => themeController.toggleTheme(),
          )),
          20.verticalSpace,

          buildMenuItem(
            icon: Icons.language,
            title: "Change Language",
          ),
          buildMenuItem(
            icon: Icons.support_agent,
            title: "Support / Help Desk",
          ),
          buildMenuItem(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
          ),
          buildMenuItem(
            icon: Icons.description,
            title: "Terms and Conditions",
          ),
          buildMenuItem(
            icon: Icons.info,
            title: "About Qars Spin",
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(bottom: 10.h),
          child: ListTile(

            leading: Icon(icon, color: AppColors.blackColor(context)),
            title: Text(title, style:  TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: AppColors.blackColor(context))),
            trailing: Image.asset("assets/images/arrow.png",scale: 1.8,color: AppColors.iconColor(context),),
            onTap: onTap,
          ),
        ),
         Container(height: .8.h, color: AppColors.darkGray),
      ],
    );
  }
}
