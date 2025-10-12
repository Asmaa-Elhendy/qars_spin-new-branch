import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import 'package:qarsspin/model/showroom_model.dart';

import '../../../widgets/car_care/care_info.dart';
import '../../../widgets/car_care/tab_Bar.dart';
import '../../../widgets/showrooms_widgets/action_buttons.dart';
import '../../../widgets/showrooms_widgets/bottom_bar.dart';
import '../../../widgets/showrooms_widgets/dealer_info_section.dart';
import '../../../widgets/showrooms_widgets/header_section.dart';

class CarCareDetails extends StatefulWidget {
  Showroom carCare;
   CarCareDetails({required this.carCare,super.key});

  @override
  State<CarCareDetails> createState() => _CarCareDetailsState();
}

class _CarCareDetailsState extends State<CarCareDetails> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      bottomNavigationBar: ShowRoomBottomBar(showRoom: widget.carCare,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 88.h, // same as your AppBar height
            padding: EdgeInsets.only(top: 13.h,left: 14.w,right: 14.w),
            decoration: BoxDecoration(
              color: AppColors.background(context),
              boxShadow: [
                BoxShadow( //update asmaa
                  color: AppColors.blackColor(context).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5.h,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

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
               // 105.horizontalSpace,
                Center(
                  child:
                  SizedBox(
                    width: 147.w,

                      child: Image.asset(Theme.of(context).brightness == Brightness.dark
                          ? 'assets/images/balckIconDarkMode.png'
                          : 'assets/images/black_logo.png',
                        fit: BoxFit.cover,
                      )),

                ),
                InkWell(
                  onTap: (){},
                  child:
                  SizedBox(
                      width: 25.w,
                      child: Image.asset("assets/images/share.png",
                      fit: BoxFit.cover,
                        color:   AppColors.blackColor(context)
                      )),
                )
              ],
            ),
          ),
          HeaderSection(realImage: widget.carCare.spin360Url,),
         // 15.verticalSpace,


          CareInfo(show: widget.carCare,),
          //14.verticalSpace,
          GetBuilder<ShowRoomsController>(
            init: ShowRoomsController(),
            builder: (controller) {
              return Expanded(child: SizedBox(
                  height: 600.h,
                  child: CarCareTapBar(
                    rate: controller.partnerRating,
                    showroom: widget.carCare,
                    gallery: controller.gallery,

                    cars: widget.carCare.rentalCars??[],avgRating: widget.carCare.avgRating.toString(),)));
            }
          )





        ],
      ),
    );
  }
}
