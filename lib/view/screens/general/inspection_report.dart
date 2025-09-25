import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../controller/brand_controller.dart';
import '../../../controller/const/base_url.dart';
import '../../../controller/const/colors.dart';
import 'package:get/get_core/src/get_main.dart';


class InspectioDialog extends StatefulWidget {
  String id;
  InspectioDialog({required this.id,super.key});

  @override
  State<InspectioDialog> createState() => _InspectioDialogState();
}

class _InspectioDialogState extends State<InspectioDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade200, // grey background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding:  EdgeInsets.only(top: 22.h,left: 16.w,right: 16.w,bottom: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Title
            Center(
              child: Text(
                "Request Inspection Report",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800,fontFamily: fontFamily),
              ),
            ),
            14.verticalSpace,

            /// Label
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                textAlign: TextAlign.center,
                "Are you sure you want to request new car inspection for this car? (this is a prepaid service. Our tean will contact you soon to get more details.)",
                style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w300,fontFamily: fontFamily),
              ),
            ),
            14.verticalSpace,

            /// Offer Row (TextField + Currency)

            /// Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonsGray,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.find<BrandController>().inspectioReport(widget.id);

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Terms & Conditions
            Center(
              child: Text(
                "You agree to Qars Spin Terms & Conditions",
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
