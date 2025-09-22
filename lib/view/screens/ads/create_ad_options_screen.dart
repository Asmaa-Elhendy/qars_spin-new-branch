import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/const/colors.dart';
import '../../widgets/ads/adv_model.dart';
import '../../widgets/main_card.dart';
import '../auth/my_account.dart';
import '../general/main_menu.dart';
import 'create_new_ad.dart';

class CreateNewAdOptions extends StatefulWidget {
  @override
  State<CreateNewAdOptions> createState() => _CreateNewAdOptionsState();
}

class _CreateNewAdOptionsState extends State<CreateNewAdOptions> {
  bool show = false;
  int notificationCount = 3;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // يخلي العنوان في نص العرض
        elevation: 0, // نشيل الشادو الافتراضي
        title: Text(
          "Create New Ad",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5.h,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 14.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(height: 200),
              GridView.count(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 3,
                crossAxisSpacing: 5,
                childAspectRatio: 1.2,
                children: [
                  HomeServiceCard(
                    onTap: () {
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Car Ads',fromHome: 'true',
                    imageAsset:
                    'assets/images/new_svg/home1.svg',
                    large: false,//f
                  ),
                  HomeServiceCard(
                    onTap: () {
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Bike Ads',fromHome: 'true',
                    imageAsset:
                    'assets/images/new_svg/bikes.svg',
                    large: false,
                  ),
                  HomeServiceCard(
                    onTap: (){
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Caravan Ads',
                    imageAsset: 'assets/images/new_svg/caravans.svg',
                    large: false,fromHome: 'true',
                  ),
                  HomeServiceCard(
                    onTap: (){
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Plate Ads',
                      imageAsset: 'assets/images/new_svg/plates.svg',
                      fromHome: 'true',
                    large: false,
                  ),
                ],
              ),
              24.verticalSpace,
              show
                  ? AdvertisementOptionsModal(
                onShowroomAdPressed: () {},
                onPersonalAdPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellCarScreen(),
                    ),
                  );
                },
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}