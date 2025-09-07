import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/colors.dart';


class OfferPart extends StatelessWidget {
  final List<Map<String, String>> offers = [
    {"name": "Jasem", "time": "1 hour ago", "price": "102,000 QAR"},
    {"name": "Mhmed", "time": "2 days ago", "price": "100,000 QAR"},
    {"name": "Karim", "time": "2 days ago", "price": "98,000 QAR"},
    {"name": "Walid", "time": "2 days ago", "price": "86,000 QAR"},
    {"name": "Nour", "time": "2 days ago", "price": "83,000 QAR"},
    {"name": "Nour", "time": "2 days ago", "price": "83,000 QAR"},
    {"name": "Nour", "time": "2 days ago", "price": "83,000 QAR"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Top Submit + Offer Row
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 16.w),
                    ),
                    onPressed: () {},
                    child: Text("SUBMIT",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 230.w,
                 height: 52.h,
                 // padding: EdgeInsets.symmetric(vertical:  8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        height: 52.h,
                       width: 35.w,
                       // height: 8.h,
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.grey.shade400),
                         // borderRadius: BorderRadius.circular(6),
                          color: AppColors.star
                        ),
                        child: InkWell(
                          child: Icon(Icons.remove, color: Colors.black),
                          onTap: () {},
                        ),
                      ),
                    //  10.horizontalSpace,
                      Text(
                        "make offer +500 QAR minimum",
                        style: TextStyle(fontSize: 10.sp, color: AppColors.lightGray),
                      ),
                    //  Spacer(),
                      Container(
                        height: 52.h,
                        width: 35.w,
                        // height: 8.h,
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.grey.shade400),
                          // borderRadius: BorderRadius.circular(6),
                            color: AppColors.star
                        ),
                        child: InkWell(
                          child: Icon(Icons.add, color: Colors.black),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          /// List of Offers
          Expanded(
            child: ListView.builder(
              itemCount: offers.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                  //  border: Border.(color: Colors.grey.shade300),
                border: Border(
                bottom: BorderSide(
                color: Colors.grey,  // اللون
                  width: .5

                ),),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 20,
                        child: Icon(Icons.person, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer["name"]!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            Text(
                              offer["time"]!,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 180.w,
                        padding: EdgeInsets.symmetric(
                             vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            offer["price"]!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
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
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            label: Text("See more",
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          )
        ],
      ),
    );
  }
}
