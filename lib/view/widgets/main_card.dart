import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../controller/const/colors.dart';



class HomeServiceCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  bool large;
  bool brand;
  int  make_count;
  String fromHome;
  final VoidCallback? onTap;

   HomeServiceCard({
    Key? key,
     this.brand = false,
      this.make_count =0,
    required this.title,
     this.fromHome='',
    required this.imageAsset,
    required this.large,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final cardSize = (screenWidth - 48 - 16) / 2; // reduce card size: more horizontal padding and spacing
    // final iconSize = cardSize * 0.36;
    // final headerHeight = cardSize * 0.20;
    // final fontSize = cardSize * 0.088;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
    //    height: large?126.h :120.h, //update asmaa
        width: large? 53.w: 55.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // stronger shadow
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 35.h,
              decoration: const BoxDecoration(
                color: AppColors.topBoxBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                 // fontFamily: AppFonts.gilroy,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.w,
                  color: Colors.white,
                ),
              ),
            ),
           brand?
           Expanded(
             child: Padding(
               padding: EdgeInsets.all(8.w),
               child: title=='All Cars'
                   ? Image.asset(
                 imageAsset,
                 fit: BoxFit.contain,
               )
                   :

               CachedNetworkImage(
                 imageUrl: imageAsset,
                 fit: BoxFit.contain,
                 placeholder: (context, url) => Center(
                   child: CircularProgressIndicator(
                     color: AppColors.primary,
                     strokeWidth: 2,
                   ),
                 ),
                 errorWidget: (context, url, error) => Image.asset(
                   'assets/images/ic_all_cars.png',
                   fit: BoxFit.contain,
                 ),
               ),
             ),
           )





               :Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child:  fromHome=='true'?
                  SvgPicture.asset(
                    imageAsset,
                    width: 95.37.w,
                    height: 73.33.h,
                  ):  SvgPicture.asset(
                    imageAsset,
                    width: 58.w,
                    height: 40.h,
                  )
                ),
              ),
            ),
            brand? Center(child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("${make_count} Cars",style: TextStyle(color: AppColors.mutedGray,fontSize: 14.sp),),
            )):SizedBox()
          ],
        ),
      ),
    );
  }
}
