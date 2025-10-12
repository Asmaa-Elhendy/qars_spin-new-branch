import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import '../../controller/const/colors.dart';

class MakeOfferDialog extends StatefulWidget {
  bool offer;
  bool requestToBuy;
  String price;
   MakeOfferDialog({this.price = "0",this.requestToBuy = false,this.offer= true,super.key});

  @override
  State<MakeOfferDialog> createState() => _MakeOfferDialogState();
}

class _MakeOfferDialogState extends State<MakeOfferDialog> {
  final TextEditingController _offerController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offerController.text = widget.price;

  }

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
                widget.offer?"Make Offer":"Request To Buy",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp, fontWeight: FontWeight.w800,fontFamily: fontFamily),
              ),
            ),
            14.verticalSpace,

            /// Label
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                textAlign: TextAlign.center,
               widget.offer? "What is your offer?":"You are making an offer matching the request price",
                style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w300,fontFamily: fontFamily,color: AppColors.black),
              ),
            ),
            14.verticalSpace,

            /// Offer Row (TextField + Currency)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(

                      border: Border.all(color: AppColors.inputBorder),
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      controller: _offerController,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: AppColors.black
                      ),

                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        hintText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,

                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40.h,
                  padding:  EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.inputBorder,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child:  Text(
                      "QAR",
                      style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                    child:  Text("Cancel",style: TextStyle(color: AppColors.black),),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if(widget.offer){
                        Get.find<BrandController>().makeOffer(offerPrice: _offerController.text);
                      }else{
                        Get.find<BrandController>().makeOffer(offerPrice: widget.price);
                      }
                      Navigator.pop(context, _offerController.text);
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
