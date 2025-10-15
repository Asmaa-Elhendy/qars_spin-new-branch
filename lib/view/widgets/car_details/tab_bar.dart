import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qarsspin/model/offer.dart';
import 'package:qarsspin/model/specification.dart';

import '../../../controller/const/base_url.dart';
import '../../../controller/const/colors.dart';
import 'offer_part.dart';

class CustomTabExample extends StatefulWidget {
  List<Specifications> spec;
  List<Offer> offers;
  CustomTabExample({required this.spec,required this.offers});
  @override
  _CustomTabExampleState createState() => _CustomTabExampleState();
}

class _CustomTabExampleState extends State<CustomTabExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisSize: MainAxisSize.min, // shrink-wrap instead of expanding
        children: [
          // --- Tab Bar ---
          Container(
            margin: EdgeInsets.all(16),
            height: 38.h,
            decoration: BoxDecoration(
              color: AppColors.tabBarColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(

              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),

              ),
              labelColor: AppColors.blackColor(context),
              unselectedLabelColor: AppColors.blackColor(context),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "Specifications"),
                Tab(text: "Offers"),

              ],
            ),
          ),

          // --- Tab Views ---
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                specifications(),
                offers(),

              ],
            ),
          ),
        ],
      );
  }
  Widget specifications(){
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
         children: [
           for(int i =0; i < widget.spec.length;i++)

           specificationsRow(widget.spec[i].key,widget.spec[i].value),
           // specificationsRow("Seats Type","5"),
           // specificationsRow("Slide Roof","Yes"),
           // specificationsRow("Park sensors","yes"),
           // specificationsRow("Camera","yes"),
           // specificationsRow("Bluetooth","Yes"),
           // specificationsRow("Gps","yes"),
           // specificationsRow("Engine Power","2.0"),
           // specificationsRow("Interior Color","Red"),
           // specificationsRow("Fuel Type","Hybrid"),
           // specificationsRow("Transmission","automatic"),
           // specificationsRow("Upholstery Material","Leather And Chamois"),
           // specificationsRow("Steering Wheel features","All Options"),
           // specificationsRow("Wheels","19"),
           // specificationsRow("Headlights","Yes"),
           // specificationsRow("Tail Lights","yes"),
           // specificationsRow("Fog Lamps","Yes"),
           // specificationsRow("Body Type","sedan"),
           //
           // specificationsRow("ABS","Yes"),
           // specificationsRow("Lane Assist","Yes"),
           // specificationsRow("Adaptive Cruise Control","Yes"),
           // specificationsRow("Automatic Emergency","Yes"),
           // specificationsRow("Wireless Charging","Yes"),
           // specificationsRow("Apple Carplay/Android","CarPlay"),
           //
           // specificationsRow("USB Parts","Yes"),
           // specificationsRow("Voice Commands","Yes"),
           // specificationsRow("Exterior Colors","Gray"),
           // specificationsRow("Warranty Period","6 Years"),
           // specificationsRow("Roof Rails","Chamois"),
           //
         ],
      ),
    ) ;
  }
  Widget specificationsRow(String title ,String value){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: .8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            height: 55.h,
            width: 175.w,
            decoration: BoxDecoration(
              color:AppColors.background(context),
              border: Border.all(
                color: AppColors.extraLightGray,
                width: 1,
              ),
             // borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp, color: AppColors.blackColor(context)),

              ),
            ),
          ),
          2.5.horizontalSpace,
          Container(
            height: 55.h,
            width: 175.w,
            decoration: BoxDecoration(
              color: AppColors.background(context),
              border: Border.all(
                color: AppColors.extraLightGray,
                width: 1,
              ),
             // borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w300,
                    fontSize: 14.sp, color: AppColors.blackColor(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget offers(){
    return OfferPart(offers: widget.offers,);

  }
}
