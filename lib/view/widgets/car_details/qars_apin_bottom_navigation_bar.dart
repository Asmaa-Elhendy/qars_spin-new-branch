import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/controller/const/colors.dart';

class QarsApinBottomNavigationBar extends StatefulWidget {
  final VoidCallback onRequestToBuy;
  final VoidCallback onMakeOffer;
  final VoidCallback onLoan;

  QarsApinBottomNavigationBar({required this.onLoan,required this.onMakeOffer,required this.onRequestToBuy,super.key});

  @override
  State<QarsApinBottomNavigationBar> createState() => _QarsApinBottomNavigationBarState();
}

class _QarsApinBottomNavigationBarState extends State<QarsApinBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,

      ),
      child: Row(spacing: 2.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button("Request\n To Buy", widget.onRequestToBuy, "assets/images/new_svg/requestBuy.svg"),
          button("Make\n Offer", widget.onMakeOffer, "assets/images/new_svg/makeOffer.svg"),
          button("Buy With\n Loan", widget.onLoan, "assets/images/new_svg/loan.svg"),

        ],
      ),
    );
  }
  button(title,onTap,image){
    return InkWell(
      onTap: onTap,
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 22.w,vertical: 8.h),
        color: AppColors.star,
        child: Row(
          children: [
            SvgPicture.asset(image),
            6.horizontalSpace,
            Text(title,style: TextStyle(
                color: AppColors.black,
                fontSize: 14.sp,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600
            ),)

          ],
        ),
      ),
    );
  }
}
