import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/model/showroom_model.dart';

import '../../../widgets/car_care/car_info.dart';
import '../../../widgets/car_care/tab_Bar.dart';
import '../../../widgets/showrooms_widgets/header_section.dart';

class CarCareDetails extends StatefulWidget {
  Showroom carCare;
  CarCareDetails({required this.carCare,super.key});

  @override
  State<CarCareDetails> createState() => _CarCareDetailsState();
}

class _CarCareDetailsState extends State<CarCareDetails> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 88.h, // same as your AppBar height
            padding: EdgeInsets.only(top: 13.h,left: 14.w,right: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // shadow color
                  blurRadius: 6, // softens the shadow
                  offset: Offset(0, 2), // moves shadow downward
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // go back
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 30.w,
                  ),
                ),
                // 105.horizontalSpace,
                Center(
                  child:
                  SizedBox(
                      width: 147.w,

                      child: Image.asset("assets/images/black_logo.png",
                        fit: BoxFit.cover,
                      )),

                ),
                InkWell(
                  onTap: (){},
                  child:
                  SizedBox(
                      width: 25.w,
                      child: Image.asset("assets/images/share.png",
                        fit: BoxFit.cover,
                      )),
                )
              ],
            ),
          ),
          HeaderSection(),
          20.verticalSpace,
          CareInfo(show: widget.carCare,),
          18.verticalSpace,
          Expanded(child: CarCareTapBar())




        ],
      ),
    );
  }
}
