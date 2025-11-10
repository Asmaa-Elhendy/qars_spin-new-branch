import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/controller/const/colors.dart';

import '../../../l10n/app_localization.dart';
import '../../widgets/ads/dialogs/loading_dialog.dart';
import '../../widgets/favourites/favourite_car_card.dart';
import '../../widgets/navigation_bar.dart';
import '../ads/create_ad_options_screen.dart';
import '../ads/create_new_ad.dart';
import '../cars_for_sale/car_details.dart';
import '../general/contact_us.dart';
import '../home_screen.dart';
import '../my_offers_screen.dart';


class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    var lc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        centerTitle: true, // يخلي العنوان في نص العرض
        elevation: 0, // نشيل الشادو الافتراضي
        title: Text(
          lc.my_fav,
          style: TextStyle(
            color: AppColors.blackColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
        backgroundColor: AppColors.background(context),
        toolbarHeight: 60.h,
        flexibleSpace: Container(
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
        ),
      ),


      body: GetBuilder<BrandController>(
          builder: (controller) {
            if(controller.loadingMode){
              return SizedBox(
                child: Center(
                  child:  Positioned.fill(

                    child: Container(
                      color: AppColors.black.withOpacity(0.5),
                      child: Center(
                        child: AppLoadingWidget(
                          title: lc.loading,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            else {
              if (controller.favoriteList.isEmpty) {
                return Center(
                  child: Text(
                    lc.empty_lbl,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return ListView(
                 padding: EdgeInsets.only(
                  top: 16.h,
                  bottom: kBottomNavigationBarHeight + 16.h, // مساحة زيادة فوق الـ nav bar
                ),
                children: [

                  for(int i =0; i<controller.favoriteList.length;i++)
                    GestureDetector(
                      onTap: (){
                        controller.getCarDetails(controller.favoriteList[i].postKind, controller.favoriteList[i].postId.toString(),context: context);
                        Get.to(CarDetails(sourcekind:controller.favoriteList[i].sourceKind,postKind: controller.favoriteList[i].postKind,id: controller.favoriteList[i].postId,));
                      },
                      child: FavouriteCarCard(
                        title: Get.locale?.languageCode=='ar'?controller.favoriteList[i].carNameSl:controller.favoriteList[i].carNamePl,

                        price: controller.favoriteList[i].askingPrice,
                        location: "controller.favoriteList[i].",
                        meilage: controller.favoriteList[i].mileage.toString(),
                        manefactureYear:controller.favoriteList[i].manufactureYear.toString(),
                        imageUrl:controller.favoriteList[i].rectangleImageUrl,
                        onHeartTap: (){
                          controller.removeFavItem(controller.favoriteList[i]);
                          controller.alterPostFavorite(add: false, postId: controller.favoriteList[i].postId);

                        },
                      ),
                    ),


                ],
              );
            }
          }
      )
      ,

      // Bottom Nav Bar
      bottomNavigationBar: CustomBottomNavBar(

        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {

            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Get.offAll(HomeScreen());
              break;
            case 1:
              Get.offAll(OffersScreen());

              break;
            case 2:
              Get.offAll(CreateNewAdOptions());

              break;

            case 3:
              Get.find<BrandController>().switchLoading();
              Get.find<BrandController>().getFavList();
              Get.offAll(FavouriteScreen());
              break;
            case 4:
              Get.offAll(ContactUsScreen());
              break;
          }
        },
        onAddPressed: () {
          // TODO: Handle Add button tap
          Get.to(CreateNewAdOptions());
        },
      ),
    );
  }
}