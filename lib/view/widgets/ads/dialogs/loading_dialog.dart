import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controller/const/colors.dart';
import '../../../../l10n/app_localization.dart';

class AppLoadingWidget extends StatelessWidget {
  final String title;

  const AppLoadingWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lc = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3.w,
          ),
          16.verticalSpace,
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingDialog {
  static void show(BuildContext context, {bool isModifyMode = false,}) {
    var lc = AppLocalizations.of(context)!;
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(isModifyMode ? lc.update_ad : lc.creating_ad),
        content: Row(
          children: [
            CupertinoActivityIndicator(),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                isModifyMode
                    ? lc.please_wait_update
                    : lc.please_wait_create,
              ),
            ),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text(
              lc.ok_lbl,
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ],
      ),
    );
  }
}