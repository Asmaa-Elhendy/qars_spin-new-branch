import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/showroom.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: height*.1,
          left: 0,
          right: 0,
          child:  Center(
            child: SvgPicture.asset(
                "assets/images/360.svg",
                width: width * .25,

              ),
          )
        ),
      ],
    );
  }
}
