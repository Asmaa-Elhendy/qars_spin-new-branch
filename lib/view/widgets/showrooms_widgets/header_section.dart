import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // 👇 هنا الصورة تتحول لعرض 360 بدل ما تبقى خلفية ثابتة
        ClipRRect(
          borderRadius: BorderRadius.circular(12), // لو عايز كورنر راوند
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: PanoramaViewer(
              zoom: 1,
              animSpeed: 0.0,
              sensorControl: SensorControl.none,
              child: Image.asset(
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
      ],
    );
  }
}
