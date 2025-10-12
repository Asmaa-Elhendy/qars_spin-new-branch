import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/view/screens/cars_for_rent/rental_car_details.dart';
import '../../controller/const/colors.dart';
import '../../model/rental_car_model.dart';


class RentalCarCard extends StatelessWidget {
  RentalCar car;

   RentalCarCard({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: (){
          Get.find<RentalCarsController>().getCarSpec(car.postId);
          Get.to(RentalCarDetails(rentalCar: car,));
        },
        child: Container(
         //   height: 70.h,
         // width: 50.w,

        child: Card(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12).r,
            side: BorderSide(color: AppColors.success)
          ),
          elevation: 4,
         // margin:  EdgeInsets.all(8).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      car.rectangleImageUrl!,
                      height: 140.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 160.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    ),
                  ),
                  if (true)
                    Positioned(
                      top: 0,
                      left: 53.w,
                      child: Container(
                        width: 60.w,

                        decoration: BoxDecoration(
                          color: AppColors.success,

                        ),
                        child:  Center(
                          child: Text(
                            "New",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.all(4).r,
                child: Text(
                  car.carNamePL,
                  style:  TextStyle(
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),

             30.verticalSpace,
              Container(
                padding:  EdgeInsets.symmetric(vertical: 8.h),
                decoration: const BoxDecoration(
                //  border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _priceColumn("Daily", car.rentPerDay),
                    _divider(),
                    _priceColumn("Weekly", car.rentPerWeek),
                    _divider(),
                    _priceColumn("Monthly", car.rentPerMonth, highlight: true),
                  ],
                ),
              ),
             8.verticalSpace,
               Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Center(
                  child: Text(
                    "All prices are in Qatari Riyals",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 9.sp, color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        ),
            ),
      );
  }

  Widget _priceColumn(String label, String value, {bool highlight = false}) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(

        children: [
          Text(label, style:  TextStyle(
              fontFamily: fontFamily,
              fontWeight: FontWeight.w700,
              color: AppColors.mutedGray, fontSize: 10.sp)),
          const SizedBox(height: 4),
          Text(
            double.parse(value)==0?"-":value,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: fontFamily,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.normal,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: .75.w,
      color: AppColors.mutedGray,
    );
  }
}