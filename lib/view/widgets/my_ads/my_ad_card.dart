import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/view/screens/my_ads/gallery_management.dart';
import 'package:qarsspin/view/screens/my_ads/specs_management.dart';
import 'package:qarsspin/model/my_ad_model.dart';

import '../../screens/my_ads/modify_car_ad.dart';
import '../../widgets/my_ads/dialog.dart';
import '../../widgets/my_ads/yellow_buttons.dart';


const String fontFamily = 'Gilroy';

Widget MyAdCard(MyAdModel ad, BuildContext context){
  return  Container(
    margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 10.h),
    padding: EdgeInsets.only(bottom: 12.h),
    //height: 455.h,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4), // optional rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.22), // shadow color
          blurRadius: 8, // how soft the shadow is
          spreadRadius: 2, // how wide it spreads
          offset: Offset(0, 2), // no offset = shadow all around
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
              Expanded(
                child: Text(
                  ad.postKind,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: fontFamily,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: AppColors.extraLightGray.withOpacity(.6), // grey background
                    borderRadius: BorderRadius.circular(3), // optional rounded corners
                  ),
                  child: Text(
                    ad.postStatus ,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )


            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            ad.postStatus=='Rejected'?'upload the car photos and publish the post then request for 360':'',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            softWrap: true,
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
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w),
          child: Text("Creation Date: ${ad.createdDateTime.split(' ')[0]}-Expiry Date: ${ad.expirationDate.split(' ')[0]}",
            style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.5.sp,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400
            ),

          ),
        )





      ],
    ),
  );
}