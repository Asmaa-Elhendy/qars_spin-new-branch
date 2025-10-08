import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qarsspin/controller/brand_controller.dart';

import '../../widgets/favourites/favourite_car_card.dart';
import '../../widgets/navigation_bar.dart';
import '../ads/create_ad_options_screen.dart';
import '../ads/create_new_ad.dart';
import '../cars_for_sale/car_details.dart';
import '../general/contact_us.dart';
import '../home_screen.dart';


class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true, // يخلي العنوان في نص العرض
        elevation: 0, // نشيل الشادو الافتراضي
        title: Text(
          "My Favourites",
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


      body: GetBuilder<BrandController>(
          builder: (controller) {
            return ListView(
              children: [
                SizedBox(height: 20.h,),
                for(int i =0; i<controller.favoriteList.length;i++)
                  GestureDetector(
                    onTap: (){
                      controller.getCarDetails(controller.favoriteList[i].postKind, controller.favoriteList[i].postId.toString());
                      Get.to(CarDetails(postKind: controller.favoriteList[i].postKind,id: controller.favoriteList[i].postId,));
                    },
                    child: FavouriteCarCard(
                      title: controller.favoriteList[i].carNamePl,
                      price: controller.favoriteList[i].askingPrice,
                      location: "controller.favoriteList[i].",
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
            //Get.offAll(OffersScreen());
              print("object");
              break;
            case 2:
              Get.offAll(CreateNewAdOptions());

              break;

            case 3:
              Get.offAll(FavouriteScreen());
              break;
            case 4:
              Get.offAll(ContactUsScreen());
              break;
          }
        },
        onAddPressed: () {
          // TODO: Handle Add button tap
          Get.offAll(SellCarScreen());
        },
      ),
    );
  }
}
