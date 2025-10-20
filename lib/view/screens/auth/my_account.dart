import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/view/screens/auth/registration_screen.dart';
import 'package:qarsspin/view/screens/my_ads/my_ads_main_screen.dart';

import '../../../controller/auth/auth_controller.dart';
import '../../../controller/const/colors.dart';
import '../my_offers_screen.dart';
import '../notifications/notifications.dart';

class MyAccount extends StatefulWidget {

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final authController2 = Get.find<AuthController>();
  @override
  void initState() {
    print("auth statst${authController2.registered}");    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();


    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 88.h, // same as your AppBar height
              padding: EdgeInsets.only(top: 13.h,left: 14.w),
              decoration: BoxDecoration(
                color: AppColors.background(context),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor(context).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5.h,
                    offset: const Offset(0, 2),
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
                      color: AppColors.blackColor(context),
                      size: 30.w,
                    ),
                  ),
                  125.horizontalSpace,
                  Center(
                    child: Text(
                      "My Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor(context),
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
              child: authController.registered
                  ? bodyWithRegistered(context)
                  : bodyWithoutRegister(context),
            )
          ],
        ),
      )),
    );
  }

  Widget bodyWithoutRegister(context){
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.profile(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(

              leading: const Icon(Icons.person, color: Colors.black),
              title:  Text(
                "Register Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                    color: AppColors.blackColor(context)
                ),
              ),
              trailing:   Image.asset("assets/images/arrow.png",scale: 1.8,),
              // Icon(Icons.arrow_forward_ios,
              //     size: 16, color: AppColors.iconColor(context)),
              onTap: () {
                Get.to(RegistrationScreen());
              },
            ),
          ),
          const SizedBox(height: 20),

          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.red),
            title: const Text(
              "Notifications",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing:
            Image.asset("assets/images/arrow.png",scale: 1.8,),
            // Icon(Icons.arrow_forward_ios,
            //     size: 16, color: AppColors.iconColor(context)),
            onTap: () {
              Get.to(NotificationsPage());

            },
          ),
        ],
      ),
    );

  }

  Widget bodyWithRegistered(context){
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.profile(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.lightGrayColor(context),
                    child: Icon(Icons.person, size: 80.w, color: Colors.black),
                  ),
                  8.verticalSpace,
                  Text("Active Ads: 0",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.shadowColor(context))),
                ],
              ),
              16.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    Text( authController2.userFullName ?? "Guest",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text(  authController2.getCurrentUser()['mobileNumber'] ?? "",

                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.bold)),
                    //  Text("01/01/1900",


                    //),

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
            context: context,
            onTap: (){
              Get.to(NotificationsPage());
            }
        ),
        buildMenuItem(
            icon: Icons.local_offer,
            title: "My Offers",
            context: context,
            onTap: (){
              Get.to(OffersScreen());
            }

        ),
        buildMenuItem(
            icon: Icons.campaign,
            title: "My Advertisements",

            onTap: (){
              Get.to(MyAdsMainScreen());
            },
            context: context

        ),
        buildMenuItem(
            icon: Icons.favorite,
            title: "My Favorites",
            context: context

        ),
        buildMenuItem(
            icon: Icons.notifications_active,
            title: "Personalized Notifications",
            context: context

        ),
        const SizedBox(height: 20),
        buildMenuItem(
            icon: Icons.logout,
            title: "Sign Out",
            context: context,onTap: ()async{
          final authController = Get.find<AuthController>();
          await authController.clearUserData();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
        }

        ),
        buildMenuItem(
            icon: Icons.delete_outline,
            title: "Delete My Account",
            context: context

        ),
      ],
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    VoidCallback? onTap,
    context
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor ?? AppColors.blackColor(context)),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Image.asset("assets/images/arrow.png",scale: 1.8,),
          onTap: onTap,
        ),
        title=="Sign Out" || title=="Delete My Account"?SizedBox(): Divider(height: 1, color: AppColors.divider(context)),
      ],
    );
  }
}