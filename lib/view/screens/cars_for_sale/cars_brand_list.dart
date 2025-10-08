import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/search_controller.dart';

import '../../../controller/brand_controller.dart';
import '../../widgets/ad_container.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/car_card.dart';
import '../../widgets/car_list_grey_bar.dart';
import '../../widgets/cars_list_app_bar.dart';
import '../general/find_my_car.dart';

class CarsBrandList extends StatefulWidget {
  String brandName;
  String postKind;
  CarsBrandList({required this.postKind, required this.brandName, super.key});

  @override
  State<CarsBrandList> createState() => _CarsBrandListState();
}

class _CarsBrandListState extends State<CarsBrandList> {
  bool isGrid = true; // controls which view to show
  String searchResult = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: carListAppBar(notificationCount: 3),
      body: GetBuilder<BrandController>(builder: (controller) {
        return Stack(
          children: [
            Column(
              children: [
                adContainer(),
                8.verticalSpace,
                carListGreyBar(
                    listCars: true,
                    onSearchResult: (result) {
                      //  Get.find<MySearchController>().fetchCarMakes();
                      setState(() {
                        searchResult = result ?? "";
                      });
                    },
                    context: context,
                    title: controller.currentMakeName==""?"All Cars":controller.currentMakeName,
                    squareIcon: true,
                    onSwap: () {
                      setState(() {
                        isGrid = !isGrid; // toggle view
                      });
                    }),
                8.verticalSpace,
                controller.loadingMode?SizedBox():
                controller.carsList.isNotEmpty
                    ? Expanded(
                    child: isGrid
                        ? listAsAGread(controller.carsList)
                        : listAsAList(controller.carsList))
                    : noResultFoud()
              ],
            ),
            if(controller.loadingMode)
              Positioned.fill(

                child: Container(
                  color: AppColors.black.withOpacity(0.5),
                  child: Center(
                    child: AppLoadingWidget(
                      title: 'Loading...\nPlease Wait...',
                    ),
                  ),
                ),
              )

          ],
        );
      }),
    );
  }

  Widget listAsAGread(cars) {
    return Padding(
        padding:
        EdgeInsets.symmetric(horizontal: 13.w, vertical: 8), //update asmaa
        child: GridView.builder(
            itemCount: cars.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              mainAxisSpacing: 28.h,
              crossAxisSpacing: 10.w, //update asmaa
              childAspectRatio: .785, //.877 adjust for card height .6  update grid cars asmaa
            ),
            itemBuilder: (context, index) {
              return carCard(
                  w: 192.w,
                  h: 235.h,
                  car: cars[index],
                  large: false,
                  postKind: widget.postKind);
            }));
  }

  Widget listAsAList(cars) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              carCard(
                w: double.infinity, // full width
                h: 300.h,
                car: cars[index],
                postKind: widget.postKind,
                large:
                true, // you can use this flag if your card has different styles for list
              ),
              8.verticalSpace
            ],
          );
        },
      ),
    );
  }

  Widget noResultFoud() {
    return Column(
      children: [
        55.verticalSpace,
        Center(
          child: Text(
            "No Result Found",
            style: TextStyle(
                color: AppColors.black,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp),
          ),
        ),
        24.verticalSpace,
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "Unfortunately what you are looking for is\ncurrently not available. Please activate a",
                style: TextStyle(
                    color: AppColors.black,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp),
              ),
            ),
            Text(
              "notification using\"Find me a car\"yp be updates",
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w300,
                  fontSize: 15.sp),
            ),
            33.verticalSpace,
            Center(
              child: InkWell(
                onTap: () {
                  Get.to(FindMeACar());
                },
                child: Container(
                  width: 150.w,
                  padding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.darkTextSecondary,
                    borderRadius:
                    BorderRadius.circular(4), // optional rounded corners
                  ),
                  child: Center(
                    child: Text(
                      "Find Me A Car",
                      style: TextStyle(
                        color: AppColors.black,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
// Obx(() {
// if (controller.isLoadingMedia.value) {
// return
// Positioned.fill(
// child: Container(
// color: Colors.black.withOpacity(0.5),
// child: Center(
// child: AppLoadingWidget(
// title: 'Loading...\nPlease Wait...',
// ),
// ),
// ),
// );
// }
// return SizedBox.shrink();
// }),
