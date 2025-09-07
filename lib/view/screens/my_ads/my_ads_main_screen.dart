import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/view/screens/my_ads/gallery_management.dart';
import 'package:qarsspin/view/screens/my_ads/specs_management.dart';

import '../../../controller/const/base_url.dart';
import '../../widgets/my_ads/dialog.dart';
import '../../widgets/my_ads/yellow_buttons.dart';
import '../auth/my_account.dart';
import '../general/main_menu.dart';
import 'modify_car_ad.dart';


class MyAdsMainScreen extends StatefulWidget {
  const MyAdsMainScreen({super.key});

  @override
  State<MyAdsMainScreen> createState() => _MyAdsMainScreenState();
}

class _MyAdsMainScreenState extends State<MyAdsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 106.h,
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
            //alignment: Alignment.center,
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
                105.horizontalSpace,
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "My Advertisements",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Active Ads 0 Of 1",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          25.verticalSpace,
      Container(
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        padding: EdgeInsets.only(bottom: 12.h),
        //height: 455.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2), // optional rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22), // shadow color
              blurRadius: 8, // how soft the shadow is
              spreadRadius: 2, // how wide it spreads
              offset: Offset(0, 0), // no offset = shadow all around
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width:double.infinity,
              height: 260.h,
              child: Image.asset("assets/images/car2-removebg-preview.png",
              fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.w),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cars For Sale",
                      style: TextStyle(
                        color: AppColors.black,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5.sp,


                      ),

                      ),
                      Text("No Contact Number",
                        style: TextStyle(
                          color: AppColors.black,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w200,
                          fontSize: 12.sp,


                        ),

                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: AppColors.extraLightGray.withOpacity(.6), // grey background
                      borderRadius: BorderRadius.circular(3), // optional rounded corners
                    ),
                    child: Text(
                      "Rejected",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )


                ],
              ),
            ),
            6.verticalSpace,
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    yellowButtons(title: "Request 360 Service",onTap: (){
                      SuccessDialog.show(
                        context: context,
                        title: "Ready to showCase your vehicle like a pro?",
                        message: "Our 360 photo session will beautifully highlight your post \nclick Confirm, and we'll handle the rest! \n   Additional charges may apply.",
                        onClose: () {
                          // Do something after closing dialog
                          print("Dialog closed");
                        },
                      );
                    },w: 185.w,),
                    yellowButtons(title: "Feature Your Ad",onTap: (){
                      SuccessDialog.show(
                        context: context,
                        title: "Let's make your post the center \n of orientation",
                        message: "Featuring your post ensures it stands out at the top for everyone to see.\n Additional charges may apply.\n Click confirm to proceed!",
                        onClose: () {
                          // Do something after closing dialog
                          print("Dialog closed");
                        },
                      );
                    },w: 185.w,),


                  ]
              ),
            ),
            6.verticalSpace,
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    yellowButtons(title: "Modify",onTap: (){
                      Get.to(ModifyCarAd());
                    },w: 90.w),
                    yellowButtons(title: "Spaces",onTap: (){
                      Get.to(SpecsManagemnt());
                    },w: 90.w),
                    yellowButtons(title: "Gallery",onTap: (){
                      Get.to(GalleryManagement());
                    },w: 90.w,),
                    yellowButtons(title: "Publish",onTap: (){},w: 90.w,green: true),


                  ]
              ),
            ),
            6.verticalSpace,
            Text("Creation Date: 2025-08-05-Expiry Date: 2025-09-04",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.5.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w400
            ),

            )





          ],
        ),
      )

      ],
      ),


    );
  }

}
