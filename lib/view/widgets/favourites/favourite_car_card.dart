import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controller/const/colors.dart';

class FavouriteCarCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  final VoidCallback onHeartTap;


  const FavouriteCarCard({
    super.key,
    required this.onHeartTap,
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h), // Margin خارجي
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.inputBorder,
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(10.w), // Padding داخلي
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imageUrl,
                width: 130.w,
                height: 100.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    imageUrl,
                    width: 130.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),

                          // Price
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/images/new_svg/ic_calendar.svg',
                                width: 26.w,
                                height: 26.h,
                                color:  AppColors.black,

                              ),
                              Padding(
                                padding:  EdgeInsets.only(right: 6.w,left: 2.w),
                                child: Text('2021',style: TextStyle(color: AppColors.textSecondary),),
                              ),
                              SvgPicture.asset(
                                'assets/images/new_svg/ic_mileage.svg',
                                width: 28.w,
                                height: 28.h,
                                color:  AppColors.black,

                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 2.w),
                                child: Text('36,566',style: TextStyle(color: AppColors.textSecondary),),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: onHeartTap,
                        child: Icon(
                          Icons.favorite, // Black border layer
                          size: 30.sp,
                          color: AppColors.star,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
