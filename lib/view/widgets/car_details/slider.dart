import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/controller/const/base_url.dart';

import '../../../controller/const/colors.dart';

class LoanInstallmentsSlider extends StatefulWidget {
  final ValueNotifier<int> monthsNotifier;
  LoanInstallmentsSlider({required this.monthsNotifier});



  @override
  _LoanInstallmentsSliderState createState() => _LoanInstallmentsSliderState();
}

class _LoanInstallmentsSliderState extends State<LoanInstallmentsSlider> {
  double _months = 7; // initial value

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Slider + Number
        Row(
          children: [
            // Slider
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.star,
                  inactiveTrackColor: AppColors.extraLightGray,
                  thumbColor: AppColors.star,

                  thumbShape:  RoundSliderThumbShape(enabledThumbRadius: 16.r),
                  overlayShape:  RoundSliderOverlayShape(overlayRadius: 8.r),
                ),
                child: Slider(
                  value:  widget.monthsNotifier.value.toDouble(),
                  min: 1,
                  max: 48,
                  onChanged: (value) {
                    setState(() {
                      // _months = value;

                      widget.monthsNotifier.value = value.toInt();
                    });
                    //  print(widget.monthsNotifier.value .toInt());
                  },
                ),
              ),
            ),

            8.horizontalSpace,

            // Box showing the value
            Container(
              height: 40.h,
              width: 65.w,
              padding:  EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.inputBorder,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  widget.monthsNotifier.value.toInt().toString(),
                  style:  TextStyle(
                    fontSize: 16.sp,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
