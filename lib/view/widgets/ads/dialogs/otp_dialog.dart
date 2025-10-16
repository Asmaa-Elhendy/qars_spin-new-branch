import 'dart:developer' as l;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/const/base_url.dart';
import '../../../../controller/const/colors.dart';
import 'error_dialog.dart';

class OTPDialog extends StatelessWidget {
  final TextEditingController otpController;
  final String otpSecret;
  final int otpCount;
  final bool isLoading;
  final Function(bool) onLoadingChange;
  final VoidCallback onValidOTP;
  final VoidCallback onInvalidOTP;
  final VoidCallback onRegister;
  final bool request; // لتحديد هل هو alert خاص بطلب أو لا

  const OTPDialog({
    Key? key,
    required this.otpController,
    required this.otpSecret,
    required this.otpCount,
    required this.isLoading,
    required this.onLoadingChange,
    required this.onValidOTP,
    required this.onInvalidOTP,
    required this.onRegister,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.toastBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.h),
        height: request ? 270.h : 330.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 15.sp,
              ),
            ),
            8.verticalSpace,
            Text(
              'Please enter the OTP sent to your phone',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
            20.verticalSpace,
            Container(height: 40.h,
              child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            18.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cancelButton(() {
                  Navigator.pop(context);
                }, "Cancel", request),
                10.horizontalSpace,
                yellowButtons(
                  title: "Verify",
                  onTap: () async {
                    if (otpController.text.isEmpty) {
                      showErrorAlert('Please enter the OTP',context);
                      return;
                    }

                    Navigator.pop(context);
                    onLoadingChange(true);

                    try {
                      if (otpController.text == otpSecret) {
                        l.log('oto count**********$otpCount');
                        if (otpCount == 1) {
                          onValidOTP(); // Navigate to home
                        } else if (otpCount == 0) {
                          // For new registration (count = 0), proceed with registration
                          onRegister();
                        } else {
                          // For any other case, just navigate to home
                          onValidOTP();
                        }
                      } else {
                        showErrorAlert('Invalid OTP. Please try again.', context);
                        onInvalidOTP();
                      }
                    } catch (e) {
                      showErrorAlert('An error occurred. Please try again.', context);
                      l.log('OTP Verification Error: $e');
                    } finally {
                      onLoadingChange(false);
                    }
                  },
                  context: context,
                  w: 95.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show({
    required BuildContext context,
    required TextEditingController otpController,
    required String otpSecret,
    required int otpCount,
    required bool isLoading,
    required Function(bool) onLoadingChange,
    required VoidCallback onValidOTP,
    required VoidCallback onInvalidOTP,
    required VoidCallback onRegister,
    required bool request,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OTPDialog(
        otpController: otpController,
        otpSecret: otpSecret,
        otpCount: otpCount,
        isLoading: isLoading,
        onLoadingChange: onLoadingChange,
        onValidOTP: onValidOTP,
        onInvalidOTP: onInvalidOTP,
        onRegister: onRegister,
        request: request,
      ),
    );
  }
}

// ⬇️ نفس دوال الأزرار المستخدمة في SuccessDialog
Widget cancelButton(VoidCallback onTap, String title, bool request) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 95.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}

Widget yellowButtons({
  required String title,
  required VoidCallback onTap,
  required BuildContext context,
  required double w,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    ),
  );
}

void showErrorAlert(String message,BuildContext context) {
  ErrorDialog.show(

      context,
      message,
          () {
        // Navigator.pop(context);
      },
      isModifyMode: false,
       fromOtp:true);

      }
