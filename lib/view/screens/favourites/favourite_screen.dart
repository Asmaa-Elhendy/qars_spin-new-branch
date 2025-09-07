import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/favourites/favourite_car_card.dart';
import '../../widgets/navigation_bar.dart';
import '../ads/create_new_ad.dart';
import '../general/contact_us.dart';
import '../home_screen.dart';


class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true, // يخلي العنوان في نص العرض
        elevation: 0, // نشيل الشادو الافتراضي
        title: Text(
          "My Favourite Cars",
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


      body: ListView(
        children: [
          SizedBox(height: 20.h,),
          FavouriteCarCard(
            title: "Toyota Corolla 2021",
            price: "15,000 QAR",
            location: "Riyadh, Saudi Arabia",
            imageUrl: "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          ),
          FavouriteCarCard(
            title: "Toyota Corolla 2021",
            price: "15,000 QAR",
            location: "Riyadh, Saudi Arabia",
            imageUrl: "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          ),
          FavouriteCarCard(
            title: "Toyota Corolla 2021",
            price: "15,000 QAR",
            location: "Riyadh, Saudi Arabia",
            imageUrl: "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          ),

        ],
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
              Get.offAll(SellCarScreen());

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
