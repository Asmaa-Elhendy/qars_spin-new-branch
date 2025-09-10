import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/model/showroom_model.dart';
import 'package:qarsspin/view/widgets/my_ads/yellow_buttons.dart';

class CareInfo extends StatelessWidget {
  Showroom show;
  CareInfo({required this.show,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 48.r,

                backgroundImage: NetworkImage(show.logoUrl),

              ),
              16.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(show.name,
                    style: TextStyle(
                        color: AppColors.black,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp
                    ),
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Text("join Date: 5 Minute ago",
                        style: TextStyle(
                            color: AppColors.inputBorder,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp
                        ),
                      ),
                      45.horizontalSpace,
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye,color: AppColors.accent,),
                          4.horizontalSpace,
                          Text("87",
                            style: TextStyle(
                                color: AppColors.mutedGray,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.sp
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      yellowButtons(title: "Follow", onTap: (){}, w: 110.w),
                      8.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Followers",
                            style: TextStyle(
                                color: AppColors.mutedGray,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp
                            ),
                          ),

                          2.verticalSpace,
                          Row(
                            children: [
                              Text("1",
                                style: TextStyle(
                                    color: AppColors.mutedGray,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13.sp
                                ),
                              ),
                              50.horizontalSpace,
                              for(int i =0;i<5;i++)
                                Icon(Icons.star,color: AppColors.mutedGray,size: 20.w,)
                            ],
                          ),

                        ],
                      )
                    ],
                  )
                ],
              )

            ],
          ),
          16.verticalSpace,
          Text("Protection - Widow Tending - Car Detailing",
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: fontFamily,
                color: AppColors.darkGray,
                fontWeight: FontWeight.w300
            ),
          ),
          18.verticalSpace,
          Divider(color: AppColors.black,thickness: .8.h,)
        ],
      ),

    );
  }
}
