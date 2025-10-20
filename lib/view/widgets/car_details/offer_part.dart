import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/model/offer.dart';


class OfferPart extends StatelessWidget {
  List<Offer> offers;
  // final List<Map<String, String>> offers = [
  //   {"name": "Jasem", "time": "1 hour ago", "price": "102,000 QAR"},
  //   {"name": "Mhmed", "time": "2 days ago", "price": "100,000 QAR"},
  //   {"name": "Karim", "time": "2 days ago", "price": "98,000 QAR"},
  //   {"name": "Walid", "time": "2 days ago", "price": "86,000 QAR"},
  //   {"name": "Nour", "time": "2 days ago", "price": "83,000 QAR"},
  //   {"name": "Nour", "time": "2 days ago", "price": "83,000 QAR"},
  //   {"name": "Nour", "time": "2 days ago", "price": "83,000 QAR"},
  // ];
  OfferPart({required this.offers});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: AppColors.background(context),
      child: Column(
        children: [
          /// Top Submit + Offer Row
          // Padding(
          //   padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.yellow[700],
          //             foregroundColor: Colors.black,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(5),
          //             ),
          //             padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 16.w),
          //           ),
          //           onPressed: () {},
          //           child: Text("SUBMIT",
          //               style: TextStyle(
          //                   fontSize: 16.sp, fontWeight: FontWeight.w500)),
          //         ),
          //       ),
          //       SizedBox(width: 10),
          //       Container(
          //         width: 230.w,
          //        height: 52.h,
          //        // padding: EdgeInsets.symmetric(vertical:  8.h),
          //         decoration: BoxDecoration(
          //           border: Border.all(color: Colors.grey.shade400),
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //
          //           children: [
          //             Container(
          //               height: 52.h,
          //              width: 35.w,
          //              // height: 8.h,
          //               decoration: BoxDecoration(
          //                 //border: Border.all(color: Colors.grey.shade400),
          //                // borderRadius: BorderRadius.circular(6),
          //                 color: AppColors.star
          //               ),
          //               child: InkWell(
          //                 child: Icon(Icons.remove, color: Colors.black),
          //                 onTap: () {},
          //               ),
          //             ),
          //           //  10.horizontalSpace,
          //             Text(
          //               "make offer +500 QAR minimum",
          //               style: TextStyle(fontSize: 10.sp, color: AppColors.lightGray),
          //             ),
          //           //  Spacer(),
          //             Container(
          //               height: 52.h,
          //               width: 35.w,
          //               // height: 8.h,
          //               decoration: BoxDecoration(
          //                 //border: Border.all(color: Colors.grey.shade400),
          //                 // borderRadius: BorderRadius.circular(6),
          //                   color: AppColors.star
          //               ),
          //               child: InkWell(
          //                 child: Icon(Icons.add, color: Colors.black),
          //                 onTap: () {},
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          //SizedBox(height: 12),

          /// List of Offers
          Expanded(
            child: ListView.builder(
              itemCount: offers.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    //  border: Border.(color: Colors.grey.shade300),
                    // border: Border(
                    // bottom: BorderSide(
                    // color: AppColors.white,  // اللون
                    //   width: .5
                    //
                    // ),),
                    color: AppColors.background(context),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.mutedGray,
                        radius: 30.r,
                        child: Icon(Icons.person, color: AppColors.blackColor(context),size: 45.w,),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 85.w,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                offer.fullName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            2.verticalSpace,
                            Text(
                              offer.dateTime,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 160.w,
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.extraLightGray),
                          borderRadius: BorderRadius.circular(6).r,
                          color: AppColors.background(context),
                        ),
                        child: Center(
                          child: Text(
                            "${offer.price} QAR",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w600, fontSize: 14.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /// See More Button
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          //   label: Text("See more",
          //       style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          // )
        ],
      ),
    );
  }
}
