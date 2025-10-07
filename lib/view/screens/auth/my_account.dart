import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/view/screens/auth/registration_screen.dart';
import 'package:qarsspin/view/screens/my_ads/my_ads_main_screen.dart';

import '../../../controller/auth.dart';
import '../../../controller/const/colors.dart';
import '../notifications/notification.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body:

      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 88.h, // same as your AppBar height
              padding: EdgeInsets.only(top: 13.h,left: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25), // shadow color
                    blurRadius: 6, // softens the shadow
                    offset: Offset(0, 2), // moves shadow downward
                  ),
                ],
              ),
              child: Row(
        
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // go back
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.black,
                      size: 30.w,
                    ),
                  ),
                  125.horizontalSpace,
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "My Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gilroy',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            25.verticalSpace,
            SizedBox(
              height: 750.h,
              child: registered?bodyWithRegistered():bodyWithoutRegister(context),
            )
          ],
        ),
      ),
    );
  }
  Widget bodyWithoutRegister(BuildContext context){
  return  Padding(
    padding:  EdgeInsets.symmetric(horizontal: 80.w),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text(
              "Register Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
            onTap: () {
              Get.to(RegistrationScreen());
            },
          ),
        ),
        const SizedBox(height: 20),

        const SizedBox(height: 20),
        // Notifications
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),//l
          ),
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Colors.red),
            title: const Text(
              "Notifications",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
            onTap: () {
              Get.to(NotificationsPage());
            },
          ),
        ),
      ],
    ),
  );

  }
  Widget bodyWithRegistered(){
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
               Column(
                 children: [
                   CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.lightGray,
                    child: Icon(Icons.person, size: 80.w, color: Colors.black),
                                 ),
                   8.verticalSpace,
                   Text("Active Ads: 0",
                       style: TextStyle(
                           fontSize: 14.sp,
                           color: Colors.grey)),
                 ],
               ),
              16.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("sv4it",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("97433998885",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("01/01/1900"),

                  ],
                ),
              )
            ],
          ),
        ),
24.verticalSpace,
        // menu
        buildMenuItem(
          icon: Icons.notifications,
          title: "Notifications",
          iconColor: Colors.red,
          onTap: (){
            Get.to(NotificationsPage());
          }
        ),
        buildMenuItem(
          icon: Icons.local_offer,
          title: "My Offers",

        ),
        buildMenuItem(
          icon: Icons.campaign,
          title: "My Advertisements",
          onTap: (){
            Get.to(MyAdsMainScreen());
          }
        ),
        buildMenuItem(
          icon: Icons.favorite,
          title: "My Favorites",
        ),
        buildMenuItem(
          icon: Icons.notifications_active,
          title: "Personalized Notifications",
        ),
        const SizedBox(height: 20),
        buildMenuItem(
          icon: Icons.logout,
          title: "Sign Out",
        ),
        buildMenuItem(
          icon: Icons.delete_outline,
          title: "Delete My Account",
        ),
      ],
    );
  }
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.black),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Image.asset("assets/images/arrow.png",scale: 1.8,),
          onTap: onTap,
        ),
         title=="Sign Out" || title=="Delete My Account"?SizedBox(): Divider(height: 1, color: Colors.black26),
      ],
    );
  }
}
