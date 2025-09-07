import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/showrooms_controller.dart';
import '../../widgets/ad_container.dart';
import '../../widgets/car_list_grey_bar.dart';
import '../../widgets/cars_list_app_bar.dart';
import '../../widgets/show_room_card.dart';

class CarsShowRoom extends StatefulWidget {
  bool carCare;
  String title;
   CarsShowRoom({required this.title,this.carCare = false,super.key});

  @override
  State<CarsShowRoom> createState() => _CarsShowRoomState();
}

class _CarsShowRoomState extends State<CarsShowRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: carListAppBar(notificationCount: 3),
      body: Column(
        children: [
          adContainer(),
          8.verticalSpace,
          carListGreyBar(title: widget.title),
          8.verticalSpace,
          Expanded(
            child: GetBuilder<ShowRoomsController>(
              builder: (controller) {
                return ListView.builder(

                  padding: const EdgeInsets.all(8),
                  itemCount: controller.showRoomForSale.length,
                  itemBuilder: (context, index) {
                    return ShowroomCard(showroom:  controller.showRoomForSale[index],carCare: widget.carCare,);
                  },
                );
              }
            ),
          ),

        ],
      ),

    );
  }
}
