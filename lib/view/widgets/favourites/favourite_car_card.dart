import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controller/const/colors.dart';

class FavouriteCarCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  final String manefactureYear;
  final String meilage;
  final VoidCallback onHeartTap;
  final VoidCallback? onDeleteTap;
  final String? myOffer;

  const FavouriteCarCard({
    super.key,
    required this.onHeartTap,
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.manefactureYear,
    required this.meilage,
    this.onDeleteTap,
    this.myOffer = null,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      // Margin خارجي
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.carCardBackground(context),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        padding: EdgeInsets.all(10.w), // Padding داخلي
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
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
                    title.trim(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      //  fontWeight: FontWeight.bold,
                      color: AppColors.blackColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),

                          // Price
                          myOffer != null
                              ? Text(
                                  'Asking Price:' + ' ' + price + ' ' + 'QAR',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.blackColor(context),
                                  ),
                                )
                              : Text(
                                  price + ' ' + 'QAR',
                                  style: TextStyle(
                                    fontSize: 14.sp,
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
                                width: 23.w,
                                height: 23.h,
                                color: AppColors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w, left: 2.w),
                                child: Text(
                                  manefactureYear,
                                  style: TextStyle(
                                    fontSize: 15.w,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                              ),
                              myOffer != null
                                  ? SizedBox()
                                  : SvgPicture.asset(
                                      'assets/images/new_svg/ic_mileage.svg',
                                      width: 24.w,
                                      height: 24.h,
                                      color: AppColors.black,
                                    ),
                              myOffer != null
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                      ),
                                      child: Text(
                                        meilage,
                                        style: TextStyle(
                                          fontSize: 15.w,

                                          color: AppColors.textSecondary(
                                            context,

                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      myOffer != null
                          ? InkWell(
                              onTap: () {
                                if (onDeleteTap != null) {
                                  onDeleteTap!();
                                }
                              },
                              child: Icon(
                                Icons.delete_outline,
                                color: const Color(0xffEC6D64),
                                size: 28.w,
                              ),
                            )
                          : InkWell(
                              onTap: onHeartTap,
                              child: Icon(
                                Icons.favorite, // Black border layer
                                size: 25.sp,
                                color: AppColors.primary,
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
