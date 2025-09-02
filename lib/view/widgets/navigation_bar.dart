import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/const/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onAddPressed;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double barHeight = 60.0;
    final double addButtonSize = 60.0;
    final double iconSize = 24.0;
    final double labelFontSize = 10.0;

    return Container(
     // height: barHeight + MediaQuery.of(context).padding.bottom,
     // height: 100.h, //update asmaa
     // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Stack(
        clipBehavior: Clip.none, // Allow the add button to overflow
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: AppColors.star,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                ),

                _buildNavItem(
                  index: 1,
                  label: 'Offers',
                  isSelected: selectedIndex == 1,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                ),

                // Invisible placeholder for the add button
                Opacity(
                  opacity: 0,
                  child: _buildNavItem(
                    index: 2,
                    label: 'Add',
                    isSelected: false,
                    iconSize: iconSize,
                    labelFontSize: labelFontSize,

                  ),
                ),

                _buildNavItem(
                  index: 3,
                  label: 'Favorite',
                  isSelected: selectedIndex == 3,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                ),

                _buildNavItem(
                  index: 4,
                  label: 'Contact',
                  isSelected: selectedIndex == 4,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                ),
              ],
            ),
          ),


          Positioned(
            bottom: 25.h,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: addButtonSize,
                height: addButtonSize,
                decoration: BoxDecoration(
                  color: AppColors.starInactive, // Using navBarGray color
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 4), // Using navBarWhite constant
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white, // White icon
                        size: 28, // Slightly smaller icon
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white, // White text
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required bool isSelected,
    required double iconSize,
    required double labelFontSize,
  }) {
    final iconColor = isSelected ? AppColors.starInactive : AppColors.white;

    Widget iconWidget;

    if (index == 0) {
      // Home - Flutter Icon
      iconWidget = Icon(
        isSelected ? Icons.home : Icons.home_outlined,
        color: iconColor,
        size: iconSize,
      );
     // Get.offAll(HomeScreen());
    } else if (index == 3) {
      // Favorite - Flutter Icon
      iconWidget = Icon(
        isSelected ? Icons.favorite : Icons.favorite_border,
        color: iconColor,
        size: iconSize,
      );
    } else {
      // Offers and Contact - Image Assets
      final imagePath = switch (index) {
        1 => 'assets/images/ic_offers.png',    // Offers
        4 => 'assets/images/ic_contact.png',   // Contact
        _ => 'assets/images/ic_offers.png',    // Default (shouldn't happen)
      };

      iconWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          imagePath,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(

        padding:  EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.starInactive : AppColors.white,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: labelFontSize,
                fontFamily: 'Gilroy',
                letterSpacing: -0.2,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
