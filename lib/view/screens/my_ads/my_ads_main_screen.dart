import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';
import '../../../controller/my_ads/my_ad_getx_controller.dart';
import '../../../controller/my_ads/my_ad_data_layer.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
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

  bool _isGlobalLoading = false;

  void _showGlobalLoader() {
    if (mounted) {
      setState(() {
        _isGlobalLoading = true;
      });
    }
  }

  void _hideGlobalLoader() {
    if (mounted) {
      setState(() {
        _isGlobalLoading = false;
      });
    }
  }

  @override
  @override
  void initState() {
    super.initState();

    // راقب حالة التحميل
    ever(controller.isLoadingMyAds, (isLoading) {
      if (isLoading == true) {
        _showGlobalLoader();
      } else {
        _hideGlobalLoader();
      }
    });

    // ✨ مهم: اعمل check أول مرة
    if (controller.isLoadingMyAds.value == true) {
      _showGlobalLoader();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          Column(
            children: [
              /// AppBar
              Container(
                height: 106.h,
                padding: EdgeInsets.only(top: 13.h, left: 14.w),
                decoration: BoxDecoration(
                  color: AppColors.background(context),
                  boxShadow: [
                    BoxShadow( //update asmaa
                      color: AppColors.blackColor(context).withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5.h,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color:AppColors.blackColor(context),
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
                              color: AppColors.blackColor(context),
                              fontFamily: 'Gilroy',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Obx(() => Text(
                            "Active Ads ${controller.activeAdsCount} Of ${controller.myAds.length}",
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

              /// الـ List
              Expanded(
                child: Obx(() {
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

                  if (controller.myAds.isEmpty &&
                      !controller.isLoadingMyAds.value) {
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
                      padding: EdgeInsets.zero,
                      itemCount: controller.myAds.length,
                      itemBuilder: (context, index) {
                        final ad = controller.myAds[index];
                        return MyAdCard(
                          ad,
                          context,
                          onShowLoader: _showGlobalLoader,
                          onHideLoader: _hideGlobalLoader,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),

          /// Loader يغطي الشاشة كلها
          if (_isGlobalLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: AppLoadingWidget(
                    title: 'Loading...\nPlease Wait...',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}