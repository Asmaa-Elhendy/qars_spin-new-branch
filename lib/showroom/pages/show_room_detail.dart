import 'package:flutter/material.dart';
import 'package:untitled2/showroom/widgets/dealer_tabs.dart';
import '../widgets/action_buttons.dart';
import '../widgets/dealer_info_section.dart';
import '../widgets/header_section.dart';

class CarDealerScreen extends StatelessWidget {
  const CarDealerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== 1. Header with 360 preview =====
          HeaderSection(),

          // ===== 2. Dealer Info Section =====
          DealerInfoSection(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .03),
            child: Divider(thickness: 2),
          ),
          // ===== 3. Action Buttons =====
          ActionButtons(),

          SizedBox(height: height*.01),

          // ===== 4. Tabs =====
          DealerTabs(),
          Center(
            child: InkWell(
              onTap: () {
                // 👈 هنا تحط الأكشن اللي عايزه
              },
              borderRadius: BorderRadius.circular(10), // عشان يعمل ripple بنفس الشكل
              child: Container(
                height: height * .06,
                width: width * .46,
                margin: EdgeInsets.symmetric(
                  vertical: height * .006,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * .01,
                  vertical: height * .006,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6C42D), // الخلفية الصفراء
                  borderRadius: BorderRadius.circular(10), // الزوايا
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_car, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      "Showroom Cars",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * .038,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
