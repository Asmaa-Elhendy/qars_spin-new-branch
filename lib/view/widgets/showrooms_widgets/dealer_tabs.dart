import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/view/widgets/showrooms_widgets/rating_tab_show_room_detail.dart';
import 'package:qarsspin/view/widgets/showrooms_widgets/showroom_details_tab_widget.dart';

import '../../../controller/const/colors.dart';


class DealerTabs extends StatelessWidget {
  const DealerTabs({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height:height*.045,
                decoration: BoxDecoration(
                  color: AppColors.extraLightGray,

                  borderRadius: BorderRadius.circular(6),
                ),


                child: TabBar(
                  labelStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w700
                  ),
                  unselectedLabelStyle: TextStyle(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w700
                  ),

                  indicator:  BoxDecoration(
                    color: AppColors.star,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.black,
                  dividerColor: Colors.transparent,
                  // النص جوه الأبيض
                  tabs: const [
                    Tab(text: "Gallery"),
                    // Tab(text: "Details"),
                    Tab(text: "Rating"),
                  ],
                ),
              ),



              Expanded(
                child: TabBarView(
                  children: [
                    // ✅ Gallery tab (3 عربيات جنب بعض)
                    GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 30.h),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 👈 3 عربيات في الصف
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                      ),
                      itemCount: 9, // عدد العربيات
                      itemBuilder: (_, i) {
                        return Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6).r,
                              color: AppColors.extraLightGray
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/car1.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(6).r,
                            ),
                          ),
                        );
                      },
                    ),

                    // Details tab
                    //  ShowroomDetailsTabWidget(),


                    // Rating tab
                    //    RatingTabShowRoomDetail(avgRating: "ma",myRate: null,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Expanded(
// child: TabBarView(
// children: [
// // ✅ Gallery tab (3 عربيات جنب بعض)
// GridView.builder(
// padding: EdgeInsets.all(8),
// gridDelegate:
// SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 3, // 👈 3 عربيات في الصف
// crossAxisSpacing: 8,
// mainAxisSpacing: 8,
// ),
// itemCount: 9, // عدد العربيات
// itemBuilder: (_, i) {
// return Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage("assets/images/car1.png"),
// fit: BoxFit.cover,
// ),
// borderRadius: BorderRadius.circular(8),
// ),
// );
// },
// ),
//
// // Details tab
// //  ShowroomDetailsTabWidget(),
//
//
// // Rating tab
// RatingTabShowRoomDetail()
// ],
// ),
// ),
