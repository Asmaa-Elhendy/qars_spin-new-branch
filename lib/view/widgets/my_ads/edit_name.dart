import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/specs/specs_controller.dart';
import 'package:qarsspin/view/widgets/my_ads/yellow_buttons.dart';

import '../../../model/specs.dart';

class EditSpecsName extends StatefulWidget {
  final Specs spec;
  const EditSpecsName({required this.spec, super.key});

  @override
  State<EditSpecsName> createState() => _EditSpecsNameState();
}

class _EditSpecsNameState extends State<EditSpecsName> {
  final TextEditingController _headerPlController = TextEditingController();
  final TextEditingController _valuePlController = TextEditingController();
  final TextEditingController _headerSlController = TextEditingController();
  final TextEditingController _valueSlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current spec values
    _headerPlController.text = widget.spec.specHeaderPl;
    _valuePlController.text = widget.spec.specValuePl;
    _headerSlController.text = widget.spec.specHeaderSl;
    _valueSlController.text = widget.spec.specValueSl;
  }

  @override
  void dispose() {
    _headerPlController.dispose();
    _valuePlController.dispose();
    _headerSlController.dispose();
    _valueSlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 280.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black, width: 2.3.h),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Title
              Center(
                child: Text(
                  'Edit Spec',
                  style: TextStyle(
                    fontSize: 14.sp, 
                    fontFamily: fontFamily, 
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),
              10.verticalSpace,

              /// English Header
              Container(
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _headerPlController,
                  decoration: InputDecoration(
                    hintText: "Header (English)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              8.verticalSpace,

              /// English Value
              Container(
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _valuePlController,
                  decoration: InputDecoration(
                    hintText: "Value (English)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              8.verticalSpace,

              /// Arabic Header
              Container(
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _headerSlController,
                  decoration: InputDecoration(
                    hintText: "Header (Arabic)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              8.verticalSpace,

              /// Arabic Value
              Container(
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _valueSlController,
                  decoration: InputDecoration(
                    hintText: "Value (Arabic)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              12.verticalSpace,

              /// Buttons Row
              Row(
                children: [
                  Expanded(
                    child: yellowButtons(
                      title: "Cancel", 
                      onTap: () {
                        Navigator.pop(context);
                      }, 
                      w: 150.w, 
                      grey: true
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: yellowButtons(
                      title: "Confirm", 
                      onTap: () {
                    //    Get.find<SpecsController>().editName(widget.spec.id, _headerPlController.text, _valuePlController.text, _headerSlController.text, _valueSlController.text);
                        Navigator.pop(context);
                      }, 
                      w: 150.w
                    ),
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
