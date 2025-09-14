import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../controller/my_ads/my_ad_getx_controller.dart';
import '../../../controller/my_ads/my_ad_data_layer.dart';
import '../../widgets/my_ads/my_ad_card.dart';


class MyAdsMainScreen extends StatefulWidget {
  const MyAdsMainScreen({super.key});

  @override
  State<MyAdsMainScreen> createState() => _MyAdsMainScreenState();
}

class _MyAdsMainScreenState extends State<MyAdsMainScreen> {
  final MyAdCleanController controller = Get.put(
    MyAdCleanController(MyAdDataLayer()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 106.h,
            padding: EdgeInsets.only(top: 13.h, left: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                    size: 30.w,
                  ),
                ),
                105.horizontalSpace,
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "My Advertisements",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Obx(() => Text(
                        "Active Ads ${controller.myAds.length} Of ${controller.myAds.length}",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          25.verticalSpace,
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMyAds.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (controller.myAdsError.value != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${controller.myAdsError.value}',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchMyAds(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.myAds.isEmpty) {
                return Center(
                  child: Text(
                    'No ads found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: controller.fetchMyAds,
                child: ListView.builder(
                  itemCount: controller.myAds.length,
                  itemBuilder: (context, index) {
                    final ad = controller.myAds[index];
                    return MyAdCard(
                      ad,
                      context,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

