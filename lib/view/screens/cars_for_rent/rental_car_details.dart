import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/model/car_model.dart';

import '../../../model/rental_car_model.dart';
import '../../widgets/rental_cars/info.dart';
import '../../widgets/rental_cars/price_table.dart';
import '../../widgets/rental_cars/rental_bottom_bar.dart';
import '../../widgets/showrooms_widgets/dealer_info_section.dart';
import '../../widgets/showrooms_widgets/dealer_tabs.dart';
import '../../widgets/showrooms_widgets/header_section.dart';
import '../../widgets/texts/texts.dart';

class RentalCarDetails extends StatefulWidget {
  RentalCar rentalCar;
  RentalCarDetails({required this.rentalCar, super.key});

  @override
  State<RentalCarDetails> createState() => _RentalCarDetailsState();
}

class _RentalCarDetailsState extends State<RentalCarDetails> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: RentalBottomNaviagtion(phone: widget.rentalCar.ownerMobile),
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 88.h, // same as your AppBar height
              padding: EdgeInsets.only(top: 13.h, left: 14.w, right: 14.w),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  // 105.horizontalSpace,
                  Center(
                    child: SizedBox(
                        width: 147.w,
                        child: Image.asset(
                          "assets/images/black_logo.png",
                          fit: BoxFit.cover,
                        )),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                        width: 25.w,
                        child: Image.asset(
                          "assets/images/share.png",
                          fit: BoxFit.cover,
                        )),
                  )
                ],
              ),
            ),
            // ===== 1. Header with 360 preview =====
            HeaderSection(realImage: widget.rentalCar.spin360Url??"",),
            SingleChildScrollView(
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RentalCarInfo(
                        car: widget.rentalCar,
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * .03),
                        child: Divider(
                          thickness: .7.h,
                          color: AppColors.black,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * .03),
                        child: Text(
                          "Rental Prices",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14.sp,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * .03),
                        child: Divider(
                          thickness: .7.h,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: height * .02),
                      PriceTable(car: widget.rentalCar),
                      //24.verticalSpace,
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * .03),
                        child: Divider(
                          thickness: .7.h,
                          color: AppColors.black,
                        ),
                      ),
                      4.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 55.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                column("Chassis Number",
                                    widget.rentalCar.chassisNumber),
                                Spacer(),
                                column(
                                    "Year",
                                    widget.rentalCar.manufactureYear
                                        .toString())
                              ],
                            ),
                            30.verticalSpace,
                            Row(
                              children: [
                                column("Mileage",
                                    widget.rentalCar.mileage.toString()),
                                Spacer(),
                                column(
                                    "For Leasing",
                                    widget.rentalCar.availableForLease == 0
                                        ? "No"
                                        : "Yes")
                              ],
                            ),
                            30.verticalSpace,
                            Row(
                              children: [
                                column("Exterior",
                                    widget.rentalCar.mileage.toString(),
                                    color: true),
                                Spacer(),
                                column("Interior",
                                    widget.rentalCar.mileage.toString(),
                                    color: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      headerText("Specifications"),
                      8.verticalSpace,

                      GetBuilder<RentalCarsController>(
                          builder: (controller) {
                            return specifications(controller.spec);
                          }
                      )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  column(key, value, {bool color = false}) {
    return Column(
      children: [
        SizedBox(
          width: 140.w,
          child: Center(
            child: boldGrey(key),
          ),
        ),
        4.verticalSpace,
        SizedBox(
          width: 88.w,
          child: Center(
            child: color
                ? Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: key == "Exterior"
                      ? widget.rentalCar.colorExterior
                      : widget.rentalCar.colorInterior,
                  border: Border.all(color: AppColors.darkGray)),
            )
                : headerText(value),
          ),
        ),
      ],
    );
  }

  Widget specifications(List spec){
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          for(int i =0; i < spec.length;i++)

            specificationsRow(spec[i].key,spec[i].value),

        ],
      ),
    ) ;
  }
  Widget specificationsRow(String title ,String value){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: .8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            height: 55.h,
            width: 175.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.extraLightGray,
                width: 1,
              ),
              // borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
          ),
          2.5.horizontalSpace,
          Container(
            height: 55.h,
            width: 175.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.extraLightGray,
                width: 1,
              ),
              // borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
