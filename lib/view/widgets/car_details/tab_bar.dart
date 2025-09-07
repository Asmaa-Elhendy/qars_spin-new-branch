import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/const/colors.dart';
import 'offer_part.dart';

class CustomTabExample extends StatefulWidget {
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
    return Scaffold(
      body:
      Column(
        children: [
          // --- Tab Bar ---
          Container(
            margin: EdgeInsets.all(16),
            height: 45.h,
            decoration: BoxDecoration(
              color: AppColors.extraLightGray,
              //borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.star,
                borderRadius: BorderRadius.circular(8),

              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "Offers"),
                Tab(text: "Specifications"),
              ],
            ),
          ),

          // --- Tab Views ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                offers(),
                specifications()
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget specifications(){
    return SingleChildScrollView(
      child: Column(
         children: [
           specificationsRow("Cylinders","4"),
           specificationsRow("Seats Type","5"),
           specificationsRow("Slide Roof","Yes"),
           specificationsRow("Park sensors","yes"),
           specificationsRow("Camera","yes"),
           specificationsRow("Bluetooth","Yes"),
           specificationsRow("Gps","yes"),
           specificationsRow("Engine Power","2.0"),
           specificationsRow("Interior Color","Red"),
           specificationsRow("Fuel Type","Hybrid"),
           specificationsRow("Transmission","automatic"),
           specificationsRow("Upholstery Material","Leather And Chamois"),
           specificationsRow("Steering Wheel features","All Options"),
           specificationsRow("Wheels","19"),
           specificationsRow("Headlights","Yes"),
           specificationsRow("Tail Lights","yes"),
           specificationsRow("Fog Lamps","Yes"),
           specificationsRow("Body Type","sedan"),
      
           specificationsRow("ABS","Yes"),
           specificationsRow("Lane Assist","Yes"),
           specificationsRow("Adaptive Cruise Control","Yes"),
           specificationsRow("Automatic Emergency","Yes"),
           specificationsRow("Wireless Charging","Yes"),
           specificationsRow("Apple Carplay/Android","CarPlay"),
      
           specificationsRow("USB Parts","Yes"),
           specificationsRow("Voice Commands","Yes"),
           specificationsRow("Exterior Colors","Gray"),
           specificationsRow("Warranty Period","6 Years"),
           specificationsRow("Roof Rails","Chamois"),
      
      
      
      
      
      
      
         ],
      ),
    ) ;
  }
  Widget specificationsRow(String title ,String value){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            height: 55.h,
            width: 170.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.extraLightGray,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
          ),
          8.horizontalSpace,
          Container(
            height: 55.h,
            width: 170.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.extraLightGray,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget offers(){
    return OfferPart();

  }
}
