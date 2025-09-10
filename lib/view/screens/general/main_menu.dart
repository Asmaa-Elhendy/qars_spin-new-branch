import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/const/colors.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.background,
          toolbarHeight: 60.h,
          shadowColor: Colors.grey.shade300,

          elevation: .4,

          title: Text(
            "Main Menu",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp
            ),
          )
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 20.w),
        children: [
          // Dark Mode Switch
          SwitchListTile(
            title: const Text("Dark Mode",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            secondary: const Icon(Icons.dark_mode, color: Colors.black),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
              });
            },
          ),
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

            leading: Icon(icon, color: Colors.black),
            title: Text(title, style:  TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400)),
            trailing: Image.asset("assets/images/arrow.png",scale: 1.8,),
            onTap: onTap,
          ),
        ),
        Container(height: .8.h, color: AppColors.darkGray),
      ],
    );
  }
}
