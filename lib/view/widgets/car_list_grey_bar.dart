import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/controller/search_controller.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import 'package:qarsspin/view/widgets/search/search_slide.dart';
import 'package:qarsspin/view/widgets/showrooms_widgets/sort_by_widgets.dart';
import '../../controller/const/colors.dart';

Widget carListGreyBar(
    {required Function(dynamic)? onSearchResult,
      required context,
      required String title,
      bool squareIcon = false,
      VoidCallback? onSwap,
      bool showroom = false,
      bool listCars = false,
      bool rental = false,
      bool makes = false,
      bool carCare = false,
      String partnerKind = "Rent a Car"}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 13.h),
    color: AppColors.divider,
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: fontFamily,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp),
        ),
        Spacer(),
        squareIcon
            ? InkWell(
          onTap: () async {


            final result = await showCustomBottomSheet(context);
            if (onSearchResult != null) {
              //
              onSearchResult(result); // 👈 ابعت النتيجة للشاشة المستدعية
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 10.w,
            ),
            height: 40.h,
            width: 115.w,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppColors.primary, // Yellow color
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/new_svg/search.svg",
                  height: 25.h,
                ),
                6.horizontalSpace,
                Text(
                  "Search",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        )
            : SizedBox(),
        GestureDetector(
            onTap: () {
              if (showroom) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => SortBySheet(
                    showroom: true,
                    onConfirm: (selectedSort) {
                      print("User selected: $selectedSort");
                      if (showroom) {
                        // "lb_Sort_By_Active_Posts_Desc" - Sort by number of active posts (highest first)
                        // "lb_Sort_By_Avg_Rating_Desc" - Sort by average rating (highest first)
                        // "lb_Sort_By_Visits_Count_Desc" - Sort by number of visits (most visited first)
                        // "lb_Sort_By_Joining_Date_Asc" - Sort by joining date (oldest first)

                        Get.find<ShowRoomsController>().fetchShowrooms(
                            partnerKind: partnerKind,
                            sort: selectedSort == "Sort By Posts Count"
                                ? "lb_Sort_By_Active_Posts_Desc"
                                : selectedSort == "Sort By Rating"
                                ? "lb_Sort_By_Avg_Rating_Desc"
                                : selectedSort == "Sort By Visits"
                                ? "lb_Sort_By_Visits_Count_Desc"
                                : "lb_Sort_By_Joining_Date_Asc");
                      }
                      // update your screen logic here
                    },
                  ),
                );
              } else if (rental) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => SortBySheet(
                        rentalCar: true,
                        onConfirm: (selectedSort) {
                          print("User selected: $selectedSort");

                          // "lb_Sort_By_Post_Date_Desc" - Sort by post date (newest first)
                          // "lb_Sort_By_Post_Date_Asc" - Sort by post date (oldest first)
                          // "lb_Sort_By_Price_Desc" - Sort by price (highest first)
                          // "lb_Sort_By_Price_Asc" - Sort by price (lowest first)
                          // "lb_Sort_By_Year_Desc" - Sort by year (newest first)
                          // "lb_Sort_By_Year_Asc" - Sort by year (oldest first)
                          Get.find<RentalCarsController>().fetchRentalCars(

                              sort: selectedSort ==
                                  "Sort By Post Date(Newest First)"
                                  ? "lb_Sort_By_Post_Date_Desc"
                                  : selectedSort ==
                                  "Sort By Post Date (Oldest First)"
                                  ? "lb_Sort_By_Post_Date_Asc"
                                  : selectedSort ==
                                  "Sort By Price(From High To Low)"
                                  ? "lb_Sort_By_Price_Desc"
                                  : selectedSort ==
                                  "Sort By Price (From Low To High)"
                                  ? "lb_Sort_By_Price_Asc"
                                  : selectedSort ==
                                  "Sort By Manufacture Year (Newest First)"
                                  ? "lb_Sort_By_Year_Desc"
                                  : "lb_Sort_By_Year_Asc");
                        }));
              }else if(makes){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => SortBySheet(
                        make: true,
                        onConfirm: (selectedSort) {
                          print("User selected: $selectedSort");

                          // "lb_Sort_By_Post_Date_Desc" - Sort by post date (newest first)
                          // "lb_Sort_By_Post_Date_Asc" - Sort by post date (oldest first)
                          // "lb_Sort_By_Price_Desc" - Sort by price (highest first)
                          // "lb_Sort_By_Price_Asc" - Sort by price (lowest first)
                          // "lb_Sort_By_Year_Desc" - Sort by year (newest first)
                          // "lb_Sort_By_Year_Asc" - Sort by year (oldest first)
                          Get.find<BrandController>().fetchCarMakes(
                              sort: selectedSort =="MakeName"?"MakeName":"Make_Count"
                          );
                        }));
              }
              else if(carCare){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => SortBySheet(
                    showroom: true,
                    onConfirm: (selectedSort) {
                      print("User selected: $selectedSort");
                      if (carCare) {
                        // "lb_Sort_By_Active_Posts_Desc" - Sort by number of active posts (highest first)
                        // "lb_Sort_By_Avg_Rating_Desc" - Sort by average rating (highest first)
                        // "lb_Sort_By_Visits_Count_Desc" - Sort by number of visits (most visited first)
                        // "lb_Sort_By_Joining_Date_Asc" - Sort by joining date (oldest first)

                        Get.find<ShowRoomsController>().fetchShowrooms(
                            partnerKind: partnerKind,// car Care
                            sort: selectedSort == "Sort By Posts Count"
                                ? "lb_Sort_By_Active_Posts_Desc"
                                : selectedSort == "Sort By Rating"
                                ? "lb_Sort_By_Avg_Rating_Desc"
                                : selectedSort == "Sort By Visits"
                                ? "lb_Sort_By_Visits_Count_Desc"
                                : "lb_Sort_By_Joining_Date_Asc");
                      }
                      // update your screen logic here
                    },
                  ),
                );

              }else if(listCars){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => SortBySheet(
                      carList: true,
                      onConfirm: (selectedSort) {
                        print("User selected: $selectedSort");

                        String currentSourceKind =  Get.find<BrandController>().currentSourceKind;
                        int currentMakeId = Get.find<BrandController>().currentMakeId;
                        String currentMakeName = Get.find<BrandController>().currentMakeName;

                        // switch(currentSourceKind){
                        //   case "All":
                        Get.find<BrandController>().getCars(
                            make_id: currentMakeId, makeName: currentMakeName,
                            sort: selectedSort ==
                                "Sort By Post Date(Newest First)"
                                ? "lb_Sort_By_Post_Date_Desc"
                                : selectedSort ==
                                "Sort By Post Date (Oldest First)"
                                ? "lb_Sort_By_Post_Date_Asc"
                                : selectedSort ==
                                "Sort By Price(From High To Low)"
                                ? "lb_Sort_By_Price_Desc"
                                : selectedSort ==
                                "Sort By Price (From Low To High)"
                                ? "lb_Sort_By_Price_Asc"
                                : selectedSort ==
                                "Sort By Manufacture Year (Newest First)"
                                ? "lb_Sort_By_Year_Desc"
                                : "lb_Sort_By_Year_Asc",
                            sourceKind: currentSourceKind

                        );

                      }

                    // Get.find<ShowRoomsController>().fetchShowrooms(
                    //     partnerKind: partnerKind,// car Care
                    //     sort: selectedSort == "Sort By Posts Count"
                    //         ? "lb_Sort_By_Active_Posts_Desc"
                    //         : selectedSort == "Sort By Rating"
                    //         ? "lb_Sort_By_Avg_Rating_Desc"
                    //         : selectedSort == "Sort By Visits"
                    //         ? "lb_Sort_By_Visits_Count_Desc"
                    //         : "lb_Sort_By_Joining_Date_Asc");

                    // update your screen logic here
                    //  },
                  ),
                );

                // qar spin show room
                // Get.find<BrandController>().getCars(make_id: 0, makeName: "Qars Spin Showrooms",sourceKind: "Qars spin");
                // personal cars
                // Get.find<BrandController>().getCars(make_id: 0, makeName: "Personal Cars",sourceKind: "Individual");
                //  controller.getCars(  // in case care for sale list
                //    make_id: controller.carBrands[index].id,
                //    makeName: controller.carBrands[index].name,
                //  );

              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: 13.w, left: 3.w), //update icon filter   asmaa
              child: SvgPicture.asset(
                "assets/images/new_svg/swap.svg",
                height: 25.h,
              ),
            )),
        squareIcon
            ? GestureDetector(
          //update square asmaa
            onTap: onSwap,
            child: SvgPicture.asset(
              "assets/images/new_svg/square.svg",
              height: 25.h,
              color: AppColors.white,
            )

          //      Icon(Icons.grid_view,color: AppColors.white,size: 35.h,),

        )
            : SizedBox()
      ],
    ),
  );
}

Future<dynamic> showCustomBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) =>  CustomFormSheet(myCase: "sale",),
  );
}
