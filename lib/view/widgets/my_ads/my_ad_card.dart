import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/ads/data_layer.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/view/screens/my_ads/gallery_management.dart';
import 'package:qarsspin/view/screens/my_ads/specs_management.dart';
import 'package:qarsspin/model/my_ad_model.dart';
import '../../../controller/my_ads/my_ad_getx_controller.dart';
import '../../../controller/payments/payment_service.dart';
import '../../screens/ads/create_new_ad.dart';
import '../../widgets/my_ads/dialog.dart';
import '../../widgets/my_ads/yellow_buttons.dart';
import 'package:qarsspin/view/widgets/payments/payment_methods_dialog.dart';

const String fontFamily = 'Gilroy';

Widget MyAdCard(
    MyAdModel ad,
    BuildContext context, {
      required VoidCallback onShowLoader,
      required VoidCallback onHideLoader,
    }) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
    padding: EdgeInsets.only(bottom: 12.h),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.background(context),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.white),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.22),
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 260.h,
          child: ad.rectangleImageUrl != null
              ? Image.network(
            ad.rectangleImageUrl!,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/car2-removebg-preview.png",
                fit: BoxFit.fill,
              );
            },
          )
              : Image.asset(
            "assets/images/logo_the_q.png",
            fit: BoxFit.fill,
          ),
        ),5.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ad.postKind,
                  style: TextStyle(
                    color: AppColors.blackColor(context),
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
                    color: AppColors.extraLightGray.withOpacity(.6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    ad.postStatus,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 14.sp,
                      color: AppColors.blackColor(context),
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        ad.postStatus == 'Rejected' ?  Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(ad.rejectedReason??'',

              //  'upload the car photos and publish the post then request for 360',

              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              softWrap: true,
            )):SizedBox(),5.verticalSpace
        ,
        6.verticalSpace,

        /// أزرار (360 و Feature)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              yellowButtons(
                context: context,
                title: "Request 360 Service",
                onTap: () {
                  SuccessDialog.show(
                    request: false,
                    context: context,
                    title: "Ready to showCase your vehicle like a pro?",
                    message:
                    "Our 360 photo session will beautifully highlight your post \nclick Confirm, and we'll handle the rest! \n   Additional charges 100 riyal can apply.",
                    onClose: () {},
                    onTappp: () async {
                      // // 1) Close confirmation dialog
                      // Navigator.pop(context);
                      //
                      // // 2) Take payment first
                      // final paid = await PaymentMethodDialog.show(
                      //   context: context,
                      //   amount: 10.0,
                      // );
                      //
                      // if (paid == true) {
                      //   final myAdController = Get.find<MyAdCleanController>();
                      //
                      //   // 3) After successful payment, send request to server
                      //   onShowLoader();
                      //   final ok = await myAdController.request360Session(
                      //     userName: userName,
                      //     postId: ad.postId.toString(),
                      //     ourSecret: ourSecret,
                      //   );
                      //   onHideLoader();
                      //
                      //   if (ok) {
                      //     SuccessDialog.show(
                      //       request: true,
                      //       context: context,
                      //       title: "Confirmation",
                      //       message: "We Have Received Your Request",
                      //       onClose: () {},
                      //       onTappp: () {},
                      //     );
                      //   } else {
                      //     SuccessDialog.show(
                      //       request: true,
                      //       context: context,
                      //       title: "Cancellation",
                      //       message: "Failed To Send A Request",
                      //       onClose: () {},
                      //       onTappp: () {},
                      //     );
                      //   }
                      // } else {
                      //
                      //   SuccessDialog.show(
                      //     request: true,
                      //     context: context,
                      //     title:    'Payment',
                      //     message:   'Payment was cancelled or failed',
                      //     onClose: () {},
                      //     onTappp: () {},
                      //   );
                      // }
                      Navigator.pop(context);//j
                      final paid = await PaymentMethodDialog.show(context: context,amount:  10.0);

                      if (paid == true) {
                        // 🟢 نجاح الدفع
                        final myAdController = Get.find<MyAdCleanController>();
                        onShowLoader();
                        final ok = await myAdController.request360Session(
                          userName: userName,
                          postId: ad.postId.toString(),
                          ourSecret: ourSecret,
                        );
                        onHideLoader();

                        if (ok) {
                          SuccessDialog.show(
                            request: true,
                            context: context,
                            title: "Confirmation",
                            message: "We Have Received Your Request",
                            onClose: () {},
                            onTappp: () {},
                          );
                        } else {
                          SuccessDialog.show(
                            request: true,
                            context: context,
                            title: "Cancellation",
                            message: "Failed To Send A Request",
                            onClose: () {},
                            onTappp: () {},
                          );
                        }
                      }
                      else {
                        SuccessDialog.show(
                          request: true,
                          context: context,
                          title: 'Payment Failed',
                          message: 'Payment failed or cancelled.',
                          onClose: () {},
                          onTappp: () {},
                        );
                      }



                    },
                  );
                },
                w: 185.w,
              ),
              yellowButtons(
                context: context,
                title: "Feature Your Ad",
                onTap: () {
                  SuccessDialog.show(
                    request: false,
                    context: context,//
                    title: "Let's make your post the center \n of orientation",
                    message:
                    "Featuring your post ensures it stands out at the top for everyone to see.\n Additional charges 150 QR can apply.\n Click confirm to proceed!",
                    onClose: () {},
                    onTappp: () async {
                      // 1) Close confirmation dialog
                      Navigator.pop(context);

                      // 2) Take payment first
                      final paid = await PaymentMethodDialog.show(context: context,amount:  150.0);

                      if (paid == true)
                      {
                        final myAdController = Get.find<MyAdCleanController>();

                        // 3) After successful payment, send request to server
                        onShowLoader();
                        final ok = await myAdController.requestFeatureAd(
                          userName: userName,
                          postId: ad.postId.toString(),
                          ourSecret: ourSecret,
                        );
                        onHideLoader();

                        if (ok) {
                          SuccessDialog.show(
                            request: true,
                            context: context,
                            title: "Confirmation",
                            message: "We Have Received Your Request",
                            onClose: () {},
                            onTappp: () {},
                          );
                        }
                        else {
                          SuccessDialog.show(
                            request: true,
                            context: context,
                            title: "Cancellation",
                            message: "Failed To Send A Request",
                            onClose: () {},
                            onTappp: () {},
                          );
                        }
                      } else {

                        SuccessDialog.show(
                          request: true,//
                          context: context,
                          title:    'Payment',
                          message:   'Payment was cancelled or failed',
                          onClose: () {},
                          onTappp: () {},
                        );
                      }
                    },
                  );
                },
                w: 185.w,
              ),
            ],
          ),
        ),
        6.verticalSpace,

        /// أزرار (Modify, Specs, Gallery, Publish)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: yellowButtons(
                        context: context,
                        title: "Modify",
                        onTap: () {
                          Get.to(
                            SellCarScreen(
                              postData: {
                                'postId': ad.postId.toString(),
                                'postKind': ad.postKind ?? 'CarForSale',
                                'isModifyMode': true,
                                'userName': ad.userName,
                                'PostStatus':ad.postStatus
                              },
                            ),
                          );

                        },
                        w: double.infinity,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: yellowButtons(
                        context: context,
                        title: "Specs",
                        onTap: () {
                          Get.to(SpecsManagemnt(postId: ad.postId.toString()));
                        },
                        w: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: yellowButtons(
                        context: context,
                        title: "Gallery",
                        onTap: () {
                          // Navigate to GalleryManagement and auto-refresh when returning
                          Get.to(
                            GalleryManagement(
                              postId: ad.postId,
                              postKind: ad.postKind,
                              userName: ad.userName,
                            ),
                          )?.then((_) {//j
                            // Auto-refresh MyAdsMainScreen when returning from GalleryManagement
                            log('✅ [DEBUG] Returned from GalleryManagement, silent refreshing MyAdsMainScreen');
                            final controller = Get.find<MyAdCleanController>();
                            controller.silentRefreshMyAds(); // Silent refresh without loader
                          });
                        },
                        w: double.infinity,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: yellowButtons(
                        context: context,
                        title: "Publish",
                        onTap: () async {
                          if(ad.postStatus!="Pending Approval"){
                            final myAdController = Get.find<MyAdCleanController>();

                            onShowLoader();
                            final ok = await myAdController.requestPublishAd(
                              userName: userName,
                              postId: ad.postId.toString(),
                              ourSecret: ourSecret,
                            );
                            onHideLoader();

                            if (ok) {
                              // Show success dialog and refresh ads when it's closed
                              SuccessDialog.show(
                                request: true,
                                context: context,
                                title: "Confirmation",
                                message:
                                "We Have Receive Your Request",
                                onClose: () {//l
                                  // Refresh the ads list when the dialog is closed
                                  print('🔄 [REFRESH] Closing dialog, refreshing ads...');
                                  final myAdController = Get.find<MyAdCleanController>();
                                  myAdController.fetchMyAds();
                                  print('🔄 [REFRESH] Ads refresh initiated');//k
                                },
                                onTappp: () {},
                              );
                            } else {
                              SuccessDialog.show(
                                request: true,
                                context: context,
                                title: "Cancellation",
                                message: "Failed To Send A Request",
                                onClose: () {},
                                onTappp: () {},
                              );
                            }
                          }else{
                            SuccessDialog.show(
                              request: true,
                              context: context,
                              title: "Information",
                              message:
                              "This ad is pending approval, Please wait \n while we review your ad",
                              onClose: () {//l
                                // Refresh the ads list when the dialog is closed
                                print('🔄 [REFRESH] Closing dialog, refreshing ads...');
                                // final myAdController = Get.find<MyAdCleanController>();
                                // myAdController.fetchMyAds();
                                print('🔄 [REFRESH] Ads refresh initiated');//k
                              },
                              onTappp: () {},
                            );
                          }

                        },
                        green: true,
                        w: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        6.verticalSpace,

        /// التاريخ
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            "Creation Date: ${ad.createdDateTime.split(' ')[0]} - Expiry Date: ${ad.expirationDate.split(' ')[0]}",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.5.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}