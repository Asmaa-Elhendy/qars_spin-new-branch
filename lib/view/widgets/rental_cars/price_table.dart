import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/model/rental_car_model.dart';

class PriceTable extends StatelessWidget {
  RentalCar car;
  PriceTable({required this.car,super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(

          children: [
            dataRow("Daily", double.parse(car.rentPerDay)==0?"-":car.rentPerDay, true),
            4.verticalSpace,
            dataRow("Weekly", double.parse(car.rentPerWeek)==0?"-":car.rentPerWeek, false),
            4.verticalSpace,
            dataRow("Monthly", double.parse(car.rentPerMonth)==0?"-":car.rentPerMonth, true),


          ],
        ),
      ),
    );
  }

  dataRow(String key, value,bool grey){
    return Row(
      children: [
        Container(
          width: 170.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: grey?AppColors.extraLightGray:AppColors.white,

          ),

          child: Center(
            child: Text(key,
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
        Container(
          width: .3.w,
          height: 50.h,
          decoration: BoxDecoration(
              color: AppColors.black
          ),
        ),
        Container(
          width: 170.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: grey?AppColors.extraLightGray:AppColors.white,

          ),

          child: Center(
            child: Text(value=="-"?value:"$value QAR",
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),

      ],
    );
  }
}
