import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';

import '../../../controller/showrooms_controller.dart';
import '../../widgets/ad_container.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/car_list_grey_bar.dart';
import '../../widgets/cars_list_app_bar.dart';
import '../../widgets/show_room_card.dart';

class CarsShowRoom extends StatefulWidget {
  bool carCare;
  String title;
  bool rentRoom;
  CarsShowRoom({required this.rentRoom,required this.title,this.carCare = false,super.key});

  @override
  State<CarsShowRoom> createState() => _CarsShowRoomState();
}

class _CarsShowRoomState extends State<CarsShowRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: carListAppBar(notificationCount: 3,context: context),
      body: GetBuilder<ShowRoomsController>(
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    AdContainer(//update banner
                      bigAdHome: true,
                      targetPage: 'Partners - List Page',//not found name in db
                    ),                    8.verticalSpace,
                    carListGreyBar(onSearchResult:(_){},title: widget.title,context: context,showroom: !widget.carCare,carCare: widget.carCare,partnerKind: widget.carCare?"Car Care Shop":widget.rentRoom?"Rent a Car":"Car Showroom"),
                    8.verticalSpace,
                    Expanded(
                      child:  ListView.builder(

                          padding:  EdgeInsets.symmetric(horizontal: 18.w),
                          itemCount: controller.showRooms.length,
                          itemBuilder: (context, index) {
                            return ShowroomCard(showroom:  controller.showRooms[index],carCare: widget.carCare,
                              rental: widget.rentRoom,
                            );


                          }
                      ),
                    ),

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
          }
      ),

    );
  }
}