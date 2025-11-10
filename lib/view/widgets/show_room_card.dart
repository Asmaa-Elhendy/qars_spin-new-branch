import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/ads/data_layer.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import 'package:qarsspin/view/screens/cars_for_sale/cars_brand_list.dart';

import '../../controller/notifications_controller.dart';
import '../../l10n/app_localization.dart';
import '../../model/showroom_model.dart';
import '../screens/cars_for_rent/all_rental_cars.dart';
import '../screens/showrooms/car_care/car_care_details.dart';
import '../screens/showrooms/showrooms_details.dart';
import 'my_ads/yellow_buttons.dart';

class ShowroomCard extends StatelessWidget {
  NotificationsController notificationsController;
  final Showroom showroom;
  bool carCare;
  bool rental;
  ShowroomCard(this.notificationsController,{super.key,required this.rental,required this.carCare, required this.showroom});

  @override
  Widget build(BuildContext context) {
    var lc = AppLocalizations.of(context)!;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showroom.pinToTop)
          Stack(
            children: [
              Image.asset(Get.locale?.languageCode=='ar'?"assets/images/featured_ar.png":"assets/images/featured.png"),
              Positioned(
                left: Get.locale?.languageCode=='ar'?0:3,
                right: Get.locale?.languageCode=='ar'?3:0,
                child:  Text(
                  lc.tag_Featured,

                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
        Container(
          height: 235.h,
          margin: EdgeInsets.only(bottom: 24.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background(context),

            border: Border.all(
              width: 1.w,
              color:
              showroom.pinToTop
                  ? AppColors.danger
                  : Colors.grey,
            ),
          ),

          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Image.network(
                showroom.logoUrl,
                fit: BoxFit.fill,
                height: 160.h,
                scale: 6,

                width: double.infinity,


                //height: 60,

              ),
              Container(
                height: 65.h,
                color: AppColors.background(context),
                padding:  EdgeInsets.symmetric( vertical: 8.h,horizontal: 8.w),
                child: carCare?
                Row(
                  children: [
                    // Buttons

                    40.horizontalSpace,
                    yellowButtons(context:context,title: lc.details,w: 100.w,onTap: (){
                      Get.find<ShowRoomsController>().getShowRoomRating(showroom.partnerId);
                      Get.find<ShowRoomsController>().getPartnerGallery(showroom.partnerId);
                      Get.find<ShowRoomsController>().checkFollowing(showroom.partnerId);
                      Get.to(CarCareDetails(notificationsController,carCare: showroom,isCarCare: carCare,));}),


                    35.horizontalSpace,
                    Container(
                      height: 40.h,
                      width: 2.w,
                      color: Colors.grey,
                    ),
                    25.horizontalSpace,


                    //Spacer(),
                    // 10.horizontalSpace,
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye, size: 18, color: Colors.blue),
                        SizedBox(width: 2),
                        Text("${showroom.visitsCount}"),
                      ],
                    ),
                    25.horizontalSpace,
                    Container(
                      // margin:EdgeInsets.symmetric(horizontal: 3.w),
                      height: 40.h,
                      width: 2.w,
                      color: Colors.grey,
                    ),
                    25.horizontalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, size: 25.w, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text("${showroom.avgRating}"),
                        10.horizontalSpace,

                      ],
                    ),
                  ],
                ):
                Row(
                  children: [
                    // Buttons

                    yellowButtons(title: lc.details,w: 100.w,onTap: (){
                      Get.find<ShowRoomsController>().getShowRoomRating(showroom.partnerId);
                      Get.find<ShowRoomsController>().getPartnerGallery(showroom.partnerId);
                      Get.find<ShowRoomsController>().checkFollowing(showroom.partnerId);
                      Get.to(CarCareDetails(notificationsController,carCare: showroom,isCarCare: carCare,));},context: context),


                    10.horizontalSpace,
                    Container(
                      height: 40.h,
                      width: 2.5.w,
                      color: Colors.grey,
                    ),
                    10.horizontalSpace,

                    yellowButtons(context:context,title: "${lc.cars} (${showroom.carsCount})",w: 100.w,onTap: (){
                      Get.find<ShowRoomsController>().fetchCarsOfShowRooms(context:context,showroomName:showroom.partnerNamePl,forSale: rental?false:true, postId: "0", sourceKind: "Partner", partnerid: showroom.partnerId.toString(), userName: userName);

                      if(rental){

                        // Get.find<RentalCarsController>().setRentalCars(showroom.rentalCars!);
                        Get.to(AllRentalCars(notificationsController));
                      }else{

                        Get.find<ShowRoomsController>().fetchCarsOfShowRooms(context:context,showroomName:showroom.partnerNamePl,forSale: rental?false:true, postId: "0", sourceKind: "Partner", partnerid: showroom.partnerId.toString(), userName: userName);
                        Get.find<BrandController>().switchLoading();
                        // Get.find<BrandController>().setCars(showroom.carsForSale!,showroom.partnerNamePl);
                        //
                        Get.to(CarsBrandList(notificationsController,brandName: showroom.partnerNamePl,postKind: "CarForSale",));
                      }
                    }),
                    10.horizontalSpace,
                    Container(
                      height: 40.h,
                      width: 2.5.w,
                      color: Colors.grey,
                    ),


                    //Spacer(),
                    25.horizontalSpace,
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye, size: 18, color: Colors.blue),
                        const SizedBox(width: 2),
                        Text("${showroom.visitsCount}"),
                      ],
                    ),
                    10.horizontalSpace,
                    Container(
                      // margin:EdgeInsets.symmetric(horizontal: 3.w),
                      height: 40.h,
                      width: 2.5.w,
                      color: Colors.grey,
                    ),
                    10.horizontalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, size: 25.w, color: Colors.amber),
                        8.horizontalSpace,
                        Text("${showroom.avgRating}"),
                        10.horizontalSpace,

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
