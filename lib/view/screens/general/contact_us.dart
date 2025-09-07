import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/const/colors.dart';
import '../../widgets/navigation_bar.dart';
import '../ads/create_ad_options_screen.dart';
import '../home_screen.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background,
        toolbarHeight: 60.h,
        shadowColor: Colors.grey.shade300,

        elevation: .4,

        title: Text(
          "My Account",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp
          ),
        )
    ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        //padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 8.w),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Logo
            SizedBox(
             height: 70,
              width: 190,
              child: Image.asset(
                'assets/images/ic_top_logo_colored.png',
                fit: BoxFit.cover,
              ),
            ),
          // 8.verticalSpace,
             Text(
              "Specialized in selling cars using 360° technology",
              style: TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),

              4.verticalSpace,
            // Live Chat
            const Text(
              "Live chat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            blackCircle("assets/images/liveChat.png"),

            const SizedBox(height: 30),

            // Contact Us Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Contact Us",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "To sell your car, buy a car, or any other questions",
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      blackCircle("assets/images/telephone-removebg-preview.png"),

                      106.horizontalSpace,
                      blackCircle("assets/images/whatsapp.png"),

                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // For Business Inquiries
            const Text(
              "For Business Inquiries",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            blackCircle("assets/images/message.png"),

            const SizedBox(height: 30),

            // Social Media Accounts
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Social Media Accounts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                   12.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      //Image.asset("assets/images/twitter.png"),
                      20.horizontalSpace,
                      SizedBox(
                          width: 47,
                          height: 47,
                          child: Image.asset("assets/images/face.png",

                            fit: BoxFit.contain,
                          )),
                      50.horizontalSpace,
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset("assets/images/twitter.png",

                            fit: BoxFit.contain,
                          )),
                      50.horizontalSpace,
                      SizedBox(
                          width: 35,
                          height: 35,
                          child: Image.asset("assets/images/instagram.png",


                            fit: BoxFit.contain,
                          )),
                      50.horizontalSpace,
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset("assets/images/tiktok.png",

                            fit: BoxFit.contain,
                          )),

                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),

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
            // Get.offAll(FavoriteScreen());
              break;
            case 4:
              Get.offAll(ContactUsScreen());
              break;
          }
        },
        onAddPressed: () {
          // TODO: Handle Add button tap
          Get.offAll(CreateNewAdOptions());
        },
      ),

    );
  }

  blackCircle(String assets){
    return CircleAvatar(
      radius: 17,
      backgroundColor: Colors.black,
      child: Center(child: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(assets,color: Colors.white,

          fit: BoxFit.contain,
          ))),
    );
  }
}
