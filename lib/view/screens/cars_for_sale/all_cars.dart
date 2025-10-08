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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          adContainer(),
          8.verticalSpace,
          carListGreyBar(onSearchResult:(_){},title: "All Makes",context: context,makes: true),
          8.verticalSpace,
          GetBuilder<BrandController>(
            init: BrandController(),
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: GridView.builder(
                  shrinkWrap: true, // مهم جدا داخل ListView
                  physics: NeverScrollableScrollPhysics(), // تمرير ListView
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                  ),
                  itemCount: controller.carBrands.length,
                  itemBuilder: (context, index) {
                    return HomeServiceCard(
                      onTap: () {
                        controller.switchLoading();
                        controller.getCars(  // in case care for sale list
                          make_id: controller.carBrands[index].id,
                          makeName: controller.carBrands[index].name,
                        );
                        Get.to(CarsBrandList(
                            postKind: "CarForSale", //makes only in car for sale
                            brandName: controller.carBrands[index].name));
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
            },
          ),
        ],
      ),
    );
  }
}
