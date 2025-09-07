import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class adContainer extends StatefulWidget {
 final bool bigAdHome;
 adContainer({this.bigAdHome=false});

  @override
  State<adContainer> createState() => _adContainerState();
}

class _adContainerState extends State<adContainer> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      height: widget.bigAdHome?170.h: 115.h, //update height ad   asmaa
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/new_svg/Big_ads.png',
              width: 408.w,
              height: 73.33.h,
              fit: BoxFit.cover,
            )
            // Ad placeholder - replace with actual ad widget
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         Icons.ads_click,
            //         size: 32.w,
            //         color: Colors.grey[400],
            //       ),
            //       SizedBox(height: 8.h),
            //       Text(
            //         'Advertisement',
            //         style: TextStyle(
            //           fontSize: 12.sp,
            //           color: Colors.grey[600],
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // // Ad close button
            // Positioned(
            //   top: 4,
            //   right: 4,
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.close,
            //       size: 18.w,
            //       color: Colors.grey[600],
            //     ),
            //     onPressed: () {
            //       // Handle close ad
            //       setState(() {
            //         // You can add logic to hide the ad if needed
            //       });
            //     },
            //     padding: EdgeInsets.zero,
            //     constraints: const BoxConstraints(),
            //     iconSize: 18.w,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}


