import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/colors.dart';

import '../../widgets/my_ads/modify_ad_form.dart';

class ModifyCarAd extends StatefulWidget {
  const ModifyCarAd({super.key});

  @override
  State<ModifyCarAd> createState() => _ModifyCarAdState();
}

class _ModifyCarAdState extends State<ModifyCarAd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 

      GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(

            children: [
              Container(
                height: 88.h, // same as your AppBar height
                padding: EdgeInsets.only(top: 13.h,left: 14.w),
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
                    105.horizontalSpace,
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Modify Car Ad",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gilroy',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          //
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              25.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child:Column(
                  children: [
                    header("Modify the information below and "),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.w),
                      child: header("press confirm"),
                    )
                  ],
                )
                ,
              ),
              16.verticalSpace,
              Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
              child:
              SizedBox(
                height: 800.h,
                child: Column(
                  children: [
                    Divider(
                      color: AppColors.black,
                      thickness: .85.h,
                    ),

                    Container(
                        width: double.infinity,
                        height: 250.h,
                        child: Image.asset("assets/images/car2-removebg-preview.png",
                        fit: BoxFit.fill,
                        )),
                    3.verticalSpace,
                    Divider(
                      color: AppColors.black,
                      thickness: .85.h,
                    ),
                  //  6.verticalSpace,


                    Flexible(
                        child: ModifyCarAdForm())


                  ],
                ),
              ),
              )



            ],
          ),
        ),
      ),
    );
  }
  Widget header(title) {
    return  Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Gilroy',
        fontSize: 15.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
