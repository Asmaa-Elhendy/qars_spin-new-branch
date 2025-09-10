import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';

import '../../../controller/const/colors.dart';
import '../showrooms_widgets/rating_tab_show_room_detail.dart';
import '../showrooms_widgets/showroom_details_tab_widget.dart';

class CarCareTapBar extends StatefulWidget {
  const CarCareTapBar({super.key});

  @override
  State<CarCareTapBar> createState() => _CarCareTapBarState();
}

class _CarCareTapBarState extends State<CarCareTapBar> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          // --- Tab Bar ---
          Container(
            margin: EdgeInsets.all(16),
            height: 45.h,
            decoration: BoxDecoration(
              color: AppColors.extraLightGray,
              //borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.star,
                borderRadius: BorderRadius.circular(8),


              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp
              ),
              tabs: [
                Tab(text: "Gallery"),
                Tab(text: "Rating"),
              ],
            ),
          ),

          // --- Tab Views ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                gallery(),
                rating()
              ],
            ),
          ),
        ]);
  }
  Widget gallery(){
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 👈 3 عربيات في الصف
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 9, // عدد العربيات
      itemBuilder: (_, i) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/car1.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );

    // return GridView.count(
    //   crossAxisCount: 3, // 3 items in each row
    //   crossAxisSpacing: 10.w,
    //   mainAxisSpacing: 18.h,
    //   childAspectRatio: 1,
    //   padding: EdgeInsets.all(10),
    //   children: List.generate(9, (index) {
    //     return ShowroomDetailsTabWidget();
    // return Container(
    //   padding: EdgeInsets.all(6).r,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8).r,
    //     color: AppColors.extraLightGray
    //
    //   ),
    //   child: Container(
    //
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8).r,
    //       image: DecorationImage(image: AssetImage("assets/images/car1.png"))
    //
    //
    //     ),
    //
    //          //   child: Image.asset("assets/images/car1.png",
    //    // fit: BoxFit.cover,
    //    // )
    //   ),
    // );
    //   }),
    // ) ;
  }

  Widget rating(){
    return RatingTabShowRoomDetail();

  }
}
