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
        centerTitle: true,
        backgroundColor: AppColors.background,
        toolbarHeight: 60.h,
        shadowColor: Colors.grey.shade300,

        // elevation: 3,
        elevation: .4,
        leading: // Menu Button
        GestureDetector(onTap: () {
          Get.to(MainMenu());
        }, child: Icon(Icons.menu)),
        actions: [
          // Account Button with Notification Counter (smaller)
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(MyAccount());
                },
                child: Image.asset(
                  'assets/images/ic_personal_account.png',
                  width: 20,
                  height: 20,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 7,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    constraints:
                    const BoxConstraints(minWidth: 14, minHeight: 14),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      notificationCount > 99
                          ? '99+'
                          : notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],

        title: SizedBox(
          height: 140,
          width: 140,
          child: Image.asset(
            'assets/images/ic_top_logo_colored.png',
            fit: BoxFit.cover,
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
                    title: 'Create Car Ads',
                    imageAsset:
                    'assets/images/ic_cars_for_sale.png',
                    large: true,
                  ),
                  HomeServiceCard(
                    onTap: () {
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Bike Ads',
                    imageAsset:
                    'assets/images/Vector.png',
                    large: true,
                  ),
                  HomeServiceCard(
                    onTap: (){
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Caravan Ads',
                    imageAsset: 'assets/images/ic_caravans.png',
                    large: true,
                  ),
                  HomeServiceCard(
                    onTap: (){
                      setState(() {
                        show = true;
                      });
                    },
                    title: 'Create Plate Ads',
                    imageAsset: 'assets/images/ic_plates.png',
                    large: true,
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