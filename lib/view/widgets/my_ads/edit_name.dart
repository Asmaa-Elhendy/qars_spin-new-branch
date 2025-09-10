import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/specs_controller.dart';
import 'package:qarsspin/view/widgets/my_ads/yellow_buttons.dart';

import '../../../model/specs.dart';

class EditSpecsName extends StatefulWidget {
  Specs spec;
   EditSpecsName({required this.spec,super.key});

  @override
  State<EditSpecsName> createState() => _EditSpecsNameState();
}

class _EditSpecsNameState extends State<EditSpecsName> {
  final TextEditingController _newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade200, // grey background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: Container(
       // width: 800.w,
        height: 160.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black, width: 2.3.h),
          borderRadius: BorderRadius.circular(8),

        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 6.h,horizontal: 16.w),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Title
              Center(
                child: Text(
            widget.spec.name,
                  style: TextStyle(fontSize: 14.sp, fontFamily:fontFamily,fontWeight: FontWeight.w800),
                ),
              ),
              10.verticalSpace,

              Container(
                height: 40.h,
                decoration: BoxDecoration(

                  border: Border.all(color: AppColors.lightGray),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _newNameController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              12.verticalSpace,/// Buttons Row
              Row(
                children: [

                   Expanded(
                      child: yellowButtons(title: "Cancel", onTap: (){
                        Navigator.pop(context);

                      }, w: 150.w,grey: true),
                    ),

                   SizedBox(width: 12),
                  Expanded(
                      child: yellowButtons(title: "Confirm", onTap: (){
                        Get.find<SpecsController>().editName(widget.spec.id, _newNameController.text);
                        Navigator.pop(context);

                      }, w: 150.w),

                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
