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

          SizedBox(height: 16),

          // ===== 4. Tabs =====
          DealerTabs(),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * .01,
                vertical: height * .006,
              ),
              height: height * .08,
              width: width * .46,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.directions_car, color: Colors.black),
                label: Text(
                  "Showroom Cars",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
