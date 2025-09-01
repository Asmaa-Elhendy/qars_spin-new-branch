import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/const/colors.dart';
import '../../model/car_model.dart';
import '../screens/cars_for_sale/car_details.dart';
import 'featured_widget.dart';


Widget carCard({required CarModel car, bool large = false,required double w,required double h,bool tooSmall = false}){
  return GestureDetector(
    onTap: (){
      Get.to(CarDetails(carModel:car));
    },
    child: Container(
      width:  w,
      //height: 10.h,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4), // shadow at bottom
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  car.rectangleImageUrl,
                  height: tooSmall ? 120.h : large ? 150.h : 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.star,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                ),
              ),
             car.pinToTop==1? Positioned(
                  bottom: 3,
                  left: 3,
                  child: featuredContainer()):SizedBox()
            ],
          ),
          2.verticalSpace,
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                car.carNamePl,
                  style:  TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               tooSmall?15.verticalSpace :25.verticalSpace,
                carStatus(car.sourceKind=="Individual"?CarStatus.Personal:car.sourceKind=="Qars Spin"?CarStatus.QarsSpin:CarStatus.Showroom),
                Row(
                  children: [
                    Text(car.askingPrice.toString(),
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(" QAR",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.calendar_month,color: AppColors.mutedGray,),
                    Text(car.manufactureYear.toString(),
                      style: TextStyle(
                        color:  AppColors.mutedGray,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,

                      ),

                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.speed,color: AppColors.mutedGray,),
                    Text(car.mileage.toString(),
                      style: TextStyle(
                        color:  AppColors.mutedGray,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,

                      ),

                    ),
                  ],
                )
              ],
            ),
          )


        ],
      ),
    ),
  );


}

Widget carStatus(CarStatus status){
  return Container(
    width: 95.w,
    height: 24.h,
   padding:  EdgeInsets.symmetric(horizontal: 8),

    decoration: BoxDecoration(
      color: status==CarStatus.Personal?AppColors.success:status==CarStatus.Showroom?AppColors.accent:AppColors.darkGray,

    ),
    
    child: status==CarStatus.QarsSpin?
    SizedBox(
        width: 30,
        height: 40,
        child: Image.asset(
            "assets/images/ic_top_logo_colored.png",
        fit: BoxFit.cover,
        ))

    :Center(
      child: Text(status.name,

      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,

      ),
      ),
    )
    ,

  );
}