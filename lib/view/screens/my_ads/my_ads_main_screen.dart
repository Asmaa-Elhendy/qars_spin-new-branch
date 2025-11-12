import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';
import '../../../controller/ads/data_layer.dart';
import '../../../controller/auth/auth_controller.dart';
import '../../../controller/my_ads/my_ad_getx_controller.dart';
import '../../../controller/my_ads/my_ad_data_layer.dart';
import '../../../l10n/app_localization.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/my_ads/my_ad_card.dart';

class MyAdsMainScreen extends StatefulWidget {
  const MyAdsMainScreen({super.key});

  @override
  State<MyAdsMainScreen> createState() => _MyAdsMainScreenState();
}

class _MyAdsMainScreenState extends State<MyAdsMainScreen> {
  final authController = Get.find<AuthController>();
  late final MyAdCleanController controller;
  bool _isGlobalLoading = false;
  bool _isInitialized = false;



  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      controller = Get.put(MyAdCleanController(MyAdDataLayer()));

      if (authController.registered) {
        await _fetchMyAds();
      }

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      print('Error initializing controller: $e');
      if (mounted) {
        setState(() => _isGlobalLoading = false);
      }
    }
  }

  Future<void> _fetchMyAds() async {
    if (authController.userName != null && authController.userName!.isNotEmpty) {
      await controller.fetchMyAds(
        userName: authController.userName!,
        ourSecret: ourSecret,
      );
    }
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var lc = AppLocalizations.of(context)!;
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
                    BoxShadow(
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
                        color: AppColors.blackColor(context),
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
                            lc.adv_lbl,
                            style: TextStyle(
                              color: AppColors.blackColor(context),
                              fontFamily: fontFamily,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Obx(() => Text(
                                "${lc.active_ads} ${controller.activeAdsCount} ${lc.of_lbl} ${controller.myAds.length}",
                                style: TextStyle(
                                  color: AppColors.blackColor(context),
                                  fontFamily: fontFamily,
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
                            '${lc.error_lbl} ${controller.myAdsError.value}',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchMyAds,
                            child: Text(lc.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.myAds.isEmpty &&
                      !controller.isLoadingMyAds.value) {
                    return Center(
                      child: Text(
                        lc.no_ads,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _fetchMyAds,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.myAds.length,
                      itemBuilder: (context, index) {
                        final ad = controller.myAds[index];
                        return MyAdCard(
                          authController.userName!,
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
                    title:lc.loading,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}