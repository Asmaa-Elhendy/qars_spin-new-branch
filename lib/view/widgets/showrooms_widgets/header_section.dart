import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
class HeaderSection extends StatefulWidget {
  String realImage;
   HeaderSection({this.realImage="",super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition for Android

    if (Platform.isAndroid) {
      WebViewPlatform.instance = AndroidWebViewPlatform();
    } else if (Platform.isIOS) {
      WebViewPlatform.instance = WebKitWebViewPlatform();
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // allow JS (required for 360 player)
      ..loadRequest(Uri.parse(
          widget.realImage));

  }
  @override

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return widget.realImage!=""?
    
    Container(
        width: double.infinity,
        height: 250.h,

        
        child: WebViewWidget(controller: _controller,


        )
    )
        :Stack(
      children: [
        // 👇 هنا الصورة تتحول لعرض 360 بدل ما تبقى خلفية ثابتة
        ClipRRect(
          borderRadius: BorderRadius.circular(12), // لو عايز كورنر راوند
          child: SizedBox(
            height: 200.h,
            width: double.infinity,
            child: PanoramaViewer(
              zoom: 1,
              animSpeed: 0.0,
              sensorControl: SensorControl.none,
              child:Image.asset(
                "assets/images/Rectangle.png",
                fit: BoxFit.cover, // مهم عشان يملأ البوكس
              ),
            ),
          ),
        ),

        // أيقونة 360 فوق الصورة
        Positioned(
          top: height * .1,
          left: 0,
          right: 0,
          child: Center(
            child: SvgPicture.asset(
              "assets/images/360.svg",
              width: width * .25,
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
        //       height: 35.h,
        //      // width: double.infinity,
        //       decoration: BoxDecoration(
        //         color: Colors.black.withOpacity(.4),
        //       ),
        //       child: Row(
        //          children: [
        //            icon(Row(
        //              spacing: 1.w,
        //              children: [
        //                Icon(Icons.remove_red_eye_outlined,color: Colors.white.withOpacity(1),size: 16.w,),
        //                2.horizontalSpace,
        //                Text(
        //                  "Interior view",
        //                  style: TextStyle(
        //                  color: Colors.white.withOpacity(1),
        //                      fontSize: 12.sp
        //                  ),
        //                ),
        //
        //
        //              ],
        //            ), (){}),
        //           // 30.horizontalSpace,
        // //            icon(
        // //                Icon(Icons.text_rotation_angleup_rounded,color: Colors.white.withOpacity(1),size: 16.w,),(){}),
        // //    16.horizontalSpace,
        // //    icon( Icon(Icons.image_outlined,color: Colors.white.withOpacity(1),size: 16.w,),(){}),
        // // 88.horizontalSpace,
        // //           // icon( Icon(Icons.filter_center_focus,color: AppColors.primaryDark.withOpacity(1),size: 16.w,),(){}),
        // //            14.horizontalSpace,
        // //            icon( Icon(Icons.add,color: Colors.white.withOpacity(.7),size: 16.w,),(){}),
        // //            14.horizontalSpace,
        // //            icon( Icon(Icons.remove,color: Colors.white.withOpacity(.4),size: 16.w,),(){}),
        // //            14.horizontalSpace,
        // //            icon( Icon(Icons.zoom_in_map_sharp,color: Colors.white.withOpacity(.4),size: 16.w,),(){}),
        // //            14.horizontalSpace,
        // //            icon( Icon(Icons.zoom_out_map,color: Colors.white.withOpacity(1),size: 16.w,),(){}),
        // //            SizedBox(width: 20.w,)
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //            // icon(Row(
        //            //   children: [
        //            //     //  Icon(Icons.remove_red_eye_outlined,color: Colors.white.withOpacity(1),size: 10.w,),
        //            //     Text(
        //            //       "Interiror view",
        //            //       style: TextStyle(
        //            //           color: Colors.red.withOpacity(1),
        //            //           fontSize: 16.sp
        //            //       ),
        //            //     )
        //            //
        //            //   ],
        //            // ), (){}),
        //            // icon(Row(
        //            //   children: [
        //            //     //  Icon(Icons.remove_red_eye_outlined,color: Colors.white.withOpacity(1),size: 10.w,),
        //            //     Text(
        //            //       "Interiror view",
        //            //       style: TextStyle(
        //            //           color: Colors.red.withOpacity(1),
        //            //           fontSize: 16.sp
        //            //       ),
        //            //     )
        //            //
        //            //   ],
        //            // ), (){})
        //          ],
        //       ),
        //     ))
      ],
    );
  }

  Widget icon(icon,ontap){
    return InkWell(
      onTap: ontap,
      child: icon,
    );
  }
}
