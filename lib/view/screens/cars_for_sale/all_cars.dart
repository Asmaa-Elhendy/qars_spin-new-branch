import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/brand_controller.dart';
import '../../widgets/ad_container.dart';
import '../../widgets/car_list_grey_bar.dart';
import '../../widgets/cars_list_app_bar.dart';
import '../../widgets/main_card.dart';
import 'cars_brand_list.dart';

class AllCars extends StatefulWidget {
  const AllCars({super.key});

  @override
  State<AllCars> createState() => _AllCarsState();
}

class _AllCarsState extends State<AllCars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: carListAppBar(notificationCount: 3),
       body: Column(
         children: [
           adContainer(),
           8.verticalSpace,
           carListGreyBar(title: "All Makes"),
           8.verticalSpace,
           GetBuilder<BrandController>(
             init: BrandController(),
             builder: (controller) {
               return Container(
                 height: 600.h,
                 margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                 child: GridView.builder(
                   shrinkWrap: true,

                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3,
                     childAspectRatio: 0.9,
                     crossAxisSpacing: 8.w,
                     mainAxisSpacing: 8.w,
                    // mainAxisExtent: (constraints.maxWidth - 24.w) / itemsPerRow * 1.2,
                   ),
                   itemCount: controller.carBrands.length,
                   itemBuilder: (context, index) {


                     return  HomeServiceCard(
                       onTap: (){
                         controller.getCars(make_id:controller.carBrands[index].id,makeName: controller.carBrands[index].name );
                         Get.to(CarsBrandList(brandName: controller.carBrands[index].name));
                       },
                       brand: true,
                       title: controller.carBrands[index].name,
                       imageAsset: controller.carBrands[index].imageUrl,
                       large: false,
                       make_count: controller.carBrands[index].make_count,
                     );
                   },
                 ),
               );
             }
           )


         ],
       ),
    );
  }

}
