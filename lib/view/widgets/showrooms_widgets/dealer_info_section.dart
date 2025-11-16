import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/colors.dart';

import '../../../controller/const/base_url.dart';

class DealerInfoSection extends StatelessWidget {
  const DealerInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/logo.png"),
              ),
              const SizedBox(width: 10),

              // Dealer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Car Dealer",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w800, fontSize: 14.sp),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Join date: 01/11/2024",
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: AppColors.lightGray, fontSize: 14.sp,


                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "123456",
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  color: AppColors.darkGray,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Container(
                              margin: EdgeInsets.only(right: width * .02),
                              height: height * .04,
                              width: width * .25,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF6C42D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child:  Text(
                                    "Follow",
                                    style: TextStyle(color: AppColors.black,
                                      fontSize: 14.sp,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      color: AppColors.darkGray,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800
                                  ),
                                ),
                                Text(
                                  "123456",
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      color: AppColors.darkGray,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [1, 2, 3, 4, 5]
                              .map((e) => const Icon(Icons.star, size: 16, color: Color(0xFFF6C42D)))
                              .toList(),
                        )

                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
          18.verticalSpace,

          Text(
            "The Exclusive Dealer for DONGFENG Qatar",
            style: TextStyle(
                color: AppColors.black,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp
            ),
          )
        ],
      ),
    );
  }
}
