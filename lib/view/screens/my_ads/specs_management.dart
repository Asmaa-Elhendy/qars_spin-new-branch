import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/specs_controller.dart';

import '../../../model/specs.dart';
import '../../widgets/my_ads/edit_name.dart';

class SpecsManagemnt extends StatefulWidget {
  const SpecsManagemnt({super.key});

  @override
  State<SpecsManagemnt> createState() => _SpecsManagemntState();
}

class _SpecsManagemntState extends State<SpecsManagemnt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                          "Specs Management",
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
            22.verticalSpace,
            GetBuilder<SpecsController>(
              init: SpecsController(),
              builder: (controller) {
                return Container(
                  height: 800.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.adSpecs.length, // number of items
                    itemBuilder: (context, index) {
                      return specsContainer(controller.adSpecs[index]);
                    },
                  ),
                );
              }
            ),



          ],
        ),
      ),
    );
  }
  Widget specsContainer(Specs spec){
    return Container(
      width: double.infinity,
     // height: 106.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGray, width: 1.h),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(spec.name,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Gilroy',
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
          ),
          spec.hidden?
          Text("(Hidden)",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ) :SizedBox(),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()async{
                  await showDialog(
                  context: context,

                  builder: (_) =>  EditSpecsName(spec: spec,),
                  );

                },
                child: Container(
                  width: 23.w,
                  height: 28.h,
                  child: Image.asset("assets/images/edit3.png",
                    color: Colors.black,
                    fit: BoxFit.fill,
                    scale: 1,

                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Get.find<SpecsController>().deleteSpecs(spec.id);
                },
                child: Icon(Icons.delete_outline,
                color: AppColors.danger,
                size: 22.w,

                ),
              )

            ],
          )
        ],
        
      ),
    );


  }
}
