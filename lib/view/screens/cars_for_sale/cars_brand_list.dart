import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../controller/brand_controller.dart';
import '../../widgets/ad_container.dart';
import '../../widgets/car_card.dart';
import '../../widgets/car_list_grey_bar.dart';
import '../../widgets/cars_list_app_bar.dart';

class CarsBrandList extends StatefulWidget {
  String brandName;
   CarsBrandList({required this.brandName,super.key});

  @override
  State<CarsBrandList> createState() => _CarsBrandListState();
}

class _CarsBrandListState extends State<CarsBrandList> {
  bool isGrid = true; // controls which view to show
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: carListAppBar(notificationCount: 3),
      body:  GetBuilder<BrandController>(

          builder: (controller) {
          return Column(
            children: [
              adContainer(),
              8.verticalSpace,
              carListGreyBar(title: widget.brandName,squareIcon: true,onSwap: (){
                setState(() {
                  isGrid = !isGrid; // toggle view
                });
              }),
              8.verticalSpace,
           Expanded(child:isGrid?listAsAGread(controller.carsList):listAsAList(controller.carsList)
            )
            ],
          );
        }
      ),

    );
  }
  Widget listAsAGread(cars){

    return Padding(
        padding:  EdgeInsets.symmetric(horizontal: 13.w,vertical: 8), //update asmaa
    child: GridView.builder(
    itemCount: cars.length,
    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // 2 columns
    mainAxisSpacing: 28.h,
    crossAxisSpacing: 10.w,  //update asmaa
    childAspectRatio: .81, //.877 adjust for card height .6  update grid cars asmaa
    ),
    itemBuilder: (context, index) {
    return carCard(w: 192.w,h: 235.h,car: cars[index],large: false);


    }));
  }
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
              h: 100.h,
              car: cars[index],
              large: true, // you can use this flag if your card has different styles for list
            ),
            8.verticalSpace
          ],
        );
      },
    ),
  );
}