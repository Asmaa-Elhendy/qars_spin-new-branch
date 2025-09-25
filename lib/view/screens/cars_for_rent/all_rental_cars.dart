import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/rental_cars_controller.dart';
import '../../widgets/ad_container.dart';
import '../../widgets/car_list_grey_bar.dart';
import '../../widgets/cars_list_app_bar.dart';
import '../../widgets/rental_car_card.dart';

class AllRentalCars extends StatefulWidget {
  const AllRentalCars({super.key});

  @override
  State<AllRentalCars> createState() => _AllRentalCarsState();
}

class _AllRentalCarsState extends State<AllRentalCars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: carListAppBar(notificationCount: 3),
      body: Column(
        children: [
          adContainer(),
          8.verticalSpace,
          carListGreyBar(onSearchResult:(_){},title: "All Rental Cars",context: context,squareIcon: true,rental: true),
          8.verticalSpace,
          GetBuilder<RentalCarsController>(
              init:  RentalCarsController(),
              builder: (controller) {
                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.h,
                    crossAxisSpacing: 18.w,
                    childAspectRatio: .62,
                  ),
                  itemCount: controller.rentalCars.length,
                  itemBuilder: (context, index) {


                    return  RentalCarCard(
                      car: controller.rentalCars[index],
                    );
                  },
                );
              }
          ),

        ],
      ),
    );
  }
}
