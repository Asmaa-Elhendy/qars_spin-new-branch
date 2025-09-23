import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/specs/specs_controller.dart';
import 'package:qarsspin/controller/specs/specs_data_layer.dart';
import 'package:qarsspin/view/widgets/ads/dialogs/loading_dialog.dart';

import '../../../model/specs.dart';
import '../../widgets/my_ads/edit_name.dart';

class SpecsManagemnt extends StatefulWidget {
  final String postId;
  const SpecsManagemnt({required this.postId});

  @override
  State<SpecsManagemnt> createState() => _SpecsManagemntState();
}

class _SpecsManagemntState extends State<SpecsManagemnt> {
  late SpecsController specsController;

  bool _isGlobalLoading = false;

  void _showGlobalLoader() {
    if (mounted) {
      setState(() => _isGlobalLoading = true);
    }
  }

  void _hideGlobalLoader() {
    if (mounted) {
      setState(() => _isGlobalLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    specsController = Get.put(
      SpecsController(SpecsDataLayer()),
      tag: 'specs_${widget.postId}',
    );

    // اربط حالة التحميل باللودر
    ever(specsController.isLoadingSpecs, (isLoading) {
      if (isLoading == true) {
        _showGlobalLoader();
      } else {
        _hideGlobalLoader();
      }
    });

    // check أول مرة
    if (specsController.isLoadingSpecs.value == true) {
      _showGlobalLoader();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      specsController.fetchSpecsForPost(postId: widget.postId);
    });
  }

  @override
  void dispose() {
    Get.delete<SpecsController>(tag: 'specs_${widget.postId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [

              /// AppBar
              Container(
                height: 88.h,
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
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black,
                        size: 30.w,
                      ),
                    ),
                    105.horizontalSpace,
                    Center(
                      child: Text(
                        "Specs Management",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              22.verticalSpace,

              /// Specs list
              Expanded(
                child: Obx(() {
                  if (specsController.specsError.value != null) {
                    return _buildErrorState(specsController);
                  }

                  if (specsController.specs.isEmpty &&
                      !specsController.isLoadingSpecs.value) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: specsController.specs.length,
                    itemBuilder: (context, index) {
                      return specsContainer(specsController.specs[index],context,specsController,_showGlobalLoader,_hideGlobalLoader,false);
                    },
                  );
                }),
              ),
            ],
          ),

          /// Loader يغطي الشاشة بالكامل
          if (_isGlobalLoading)
            Positioned.fill(
              child: Container(
                width: double.infinity,
                height: double.infinity,
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
  Widget _buildErrorState(specsController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.danger, size: 48.w),
          16.verticalSpace,
          Text('Error loading specs',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600)),
          8.verticalSpace,
          Text(
            specsController.specsError.value!,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          ElevatedButton(
            onPressed: () => specsController.refreshSpecs(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey, size: 48.w),
          16.verticalSpace,
          Text('No specs found',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600)),
          8.verticalSpace,
          Text(
            'This post has no specifications',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget specsContainer(Specs spec,BuildContext context,specsController,_showGlobalLoader,_hideGlobalLoader,bool fromCreateAd) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGray, width: 1.h),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(spec.specHeaderPl,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Gilroy',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800)),
          5.verticalSpace,
          Text(
            spec.specValuePl.isEmpty || spec.specValuePl == " "
                ? '(Hidden)'
                : spec.specValuePl,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => EditSpecsName(spec: spec,fromCreateAd:fromCreateAd),
                      );
                    },
                    child: SizedBox(
                      width: 23.w,
                      height: 28.h,
                      child: Image.asset(
                        "assets/images/edit3.png",
                        color: Colors.black,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  8.horizontalSpace,

                ],
              ),
              InkWell(
                onTap: () async {
                  _showGlobalLoader();
                  if (fromCreateAd) {
                    specsController.clearLocal(
                      specId: spec.specId,
                    );
                  } else {
                    // Use API update for specs management flow
                    await specsController.updateSpecValue(
                      postId: spec.postId,
                      specId: spec.specId,
                      specValue: " ",
                    );
                  }
                  _hideGlobalLoader();
                },
                child: Icon(Icons.delete_outlined,
                    color: Color(0xffEC6D64), size: 24.w),
              ),
            ],
          )
        ],
      ),
    );
  }

