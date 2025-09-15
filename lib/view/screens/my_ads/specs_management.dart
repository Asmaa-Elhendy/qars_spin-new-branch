import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/colors.dart';
import 'package:qarsspin/controller/specs/specs_controller.dart';
import 'package:qarsspin/controller/specs/specs_data_layer.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize controller with repository
    specsController = Get.put(
      SpecsController(SpecsDataLayer()),
      tag: 'specs_${widget.postId}',
    );
    
    // Fetch specs for the post
    WidgetsBinding.instance.addPostFrameCallback((_) {
      specsController.fetchSpecsForPost(postId: widget.postId);
    });
  }

  @override
  void dispose() {
    // Clean up controller
    Get.delete<SpecsController>(tag: 'specs_${widget.postId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 88.h, // same as your AppBar height
              padding: EdgeInsets.only(top: 13.h, left: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25), // shadow color
                    blurRadius: 6, // softens the shadow
                    offset: Offset(0, 2), // moves shadow downward
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // go back
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
                          "Specs Management",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        //
                      ],
                    ),
                  ),
                ],
              ),
            ),
            22.verticalSpace,
            
            // Specs list with loading and error states
            Obx(() {
              final controller = Get.find<SpecsController>(tag: 'specs_${widget.postId}');
              
              if (controller.isLoadingSpecs.value) {
                return Container(
                  height: 400.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary,),
                        16.verticalSpace,
                        Text(
                          'Loading specs...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.specsError.value != null) {
                return Container(
                  height: 400.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.danger,
                          size: 48.w,
                        ),
                        16.verticalSpace,
                        Text(
                          'Error loading specs',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          controller.specsError.value!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,
                        ElevatedButton(
                          onPressed: () {
                            controller.refreshSpecs();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.specs.isEmpty) {
                return Container(
                  height: 400.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 48.w,
                        ),
                        16.verticalSpace,
                        Text(
                          'No specs found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                  ),
                );
              }

              return Container(
                height: 800.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.specs.length,
                  itemBuilder: (context, index) {
                    return specsContainer(controller.specs[index]);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget specsContainer(Specs spec){
    return Container(
      width: double.infinity,
      // height: 106.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
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
              fontWeight: FontWeight.w800,
            ),
          ),
           5.verticalSpace,
          Text(spec.specValuePl.isEmpty?'(Hidden)':spec.specValuePl,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ) ,
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()async{
                  await showDialog(
                    context: context,

                    builder: (_) =>  EditSpecsName(spec: spec),
                  );

                },
                child: Container(
                  width: 23.w,
                  height: 28.h,
                  child: Image.asset("assets/images/edit3.png",
                    color: Colors.black,
                    fit: BoxFit.fill,
                    scale: 1,

                  ),
                ),
              ),
              InkWell(
                onTap: (){
               //   Get.find<SpecsController>().deleteSpecs(spec.id);
                },
                child: Icon(Icons.delete_outlined,
                  color: AppColors.danger,
                  size: 24.w,

                ),
              )

            ],
          )
        ],

      ),
    );


  }
}
