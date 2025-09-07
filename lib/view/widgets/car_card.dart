import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/const/colors.dart';
import '../../model/car_model.dart';
import '../screens/cars_for_sale/car_details.dart';
import 'featured_widget.dart';
import 'package:intl/intl.dart';
Widget carCard({
  required CarModel car,
  bool large = false,
  required double w,
  required double h,
  bool tooSmall = false,
}) {
  double price = double.tryParse(car.askingPrice.toString()) ?? 0.0;

  String formattedPrice = NumberFormat.currency(//update currency asmaa
      locale: 'en_US',
      symbol: '',      // empty if you don't want $ sign
      decimalDigits: 0 // remove decimals
  ).format(price);

  return GestureDetector(
    onTap: () {
      Get.to(CarDetails(carModel: car));
    },
    child: Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: w,
      //height: h, // خلي height متاحة زي ما طلبت
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset.zero, // shadow حول كل الكارد
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الصورة
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(5)),

                  ),
                  child: CachedNetworkImage(

                    //edit placeholder for now asmaa
                    imageUrl: car.rectangleImageUrl.isNotEmpty
                        ? car.rectangleImageUrl
                        : "https://via.placeholder.com/150",

                    height: tooSmall
                        ? 120.h
                        : large
                        ? 260.h//edit
                        : 124.9.h,
                    //i update default height for all cars card car asmaa
                  // width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(color: AppColors.star),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
                if (car.pinToTop == 1)
                  Positioned(bottom: 3, left: 3, child: featuredContainer()),
              ],
            ),
            // محتوى الكارد
            Flexible(
              fit: FlexFit.loose,
              child: Padding( //update asmaa
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Padding(
                padding: EdgeInsets.only(top: 6.h, bottom: 3.h,left:
                5.w), // no horizontal padding
                child: Text(
                  car.carNamePl,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
            ),

                    SizedBox(height: tooSmall ? 8.h : 12.h),
                    Container(padding: EdgeInsets.only(left: 12.w),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          carStatus(
                            car.sourceKind == "Individual"
                                ? CarStatus.Personal
                                : car.sourceKind == "Qars Spin"
                                ? CarStatus.QarsSpin
                                : CarStatus.Showroom,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                formattedPrice  ,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                " QAR",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/new_svg/ic_calendar.svg',
                                width: 25.w,
                                height: 20.h,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                car.manufactureYear.toString(),
                                style: TextStyle(
                                  color: AppColors.mutedGray,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                width: 1.w,
                                height: 20.h,
                                color: AppColors.textSecondary,
                              )
                          ,
                              SvgPicture.asset(
                                'assets/images/new_svg/ic_mileage.svg',
                                width: 25.w,
                                height: 20.h,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                car.mileage.toString(),
                                style: TextStyle(
                                  color: AppColors.mutedGray,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget carStatus(CarStatus status) {
  return Container(
    width: 80.w,   //update asmaa
  //  height: 22.h,
    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 0.1.w),//update

    decoration: BoxDecoration(
      color: status == CarStatus.Personal
          ? AppColors.success
          : status == CarStatus.Showroom
          ? AppColors.accent
          : AppColors.darkGray,
    ),

    child: status == CarStatus.QarsSpin
        ? SizedBox(
            width: 30,
            height: 40,
            child: Image.asset(
              "assets/images/ic_top_logo_colored.png",
              fit: BoxFit.cover,
            ),
          )
        : Center(
            child: Text(
              status.name,

              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
  );
}
