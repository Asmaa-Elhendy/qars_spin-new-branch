import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/const/colors.dart';
import '../../l10n/app_localization.dart';
import 'dart:io' show Platform;
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
     final double barHeight =Platform.isAndroid?60:65.0;//60

    final double addButtonSize = 60.0;
    final double iconSize = 24.0;
    final double labelFontSize = 10.0;
    var lc = AppLocalizations.of(context)!;


    return Container(

      child: Stack(
        clipBehavior: Clip.none, // Allow the add button to overflow
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: AppColors.primary,
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
                  label: lc.navigation_home,
                  isSelected: selectedIndex == 0,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                  context: context
                ),

                _buildNavItem(
                  index: 1,
                  label: lc.navigation_offers,
                  isSelected: selectedIndex == 1,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                  context: context
                ),

                // Invisible placeholder for the add button
                Opacity(
                  opacity: 0,
                  child: _buildNavItem(
                    index: 2,
                    label: lc.navigation_add,
                    isSelected: false,
                    iconSize: iconSize,
                    labelFontSize: labelFontSize,
                    context: context

                  ),
                ),

                _buildNavItem(
                  index: 3,
                  label: lc.navigation_favorites,
                  isSelected: selectedIndex == 3,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                  context: context
                ),

                _buildNavItem(
                  index: 4,
                  label: lc.navigation_call_us,
                  isSelected: selectedIndex == 4,
                  iconSize: iconSize,
                  labelFontSize: labelFontSize,
                  context: context
                ),
              ],
            ),
          ),


          Positioned(
                  bottom:Platform.isAndroid?22.h: 30.h,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: addButtonSize,
                height: addButtonSize,
                decoration: BoxDecoration(
                  color: AppColors.divider(context), // Using navBarGray color
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background(context), width: 4), // Using navBarWhite constant
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
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
                        size: 26.w, // Slightly smaller icon
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lc.navigation_add,
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
    required BuildContext context
  }) {
    final iconColor = isSelected ? AppColors.divider(context) : AppColors.white;

    Widget iconWidget;

    if (index == 0) {
      // Home - Flutter Icon
      iconWidget = Icon(
         Icons.home ,
        color:  isSelected ?AppColors.divider(context):AppColors.white,
        size: iconSize,
      );
     // Get.offAll(HomeScreen());
    } else if (index == 3) {
      // Favorite - Flutter Icon
      iconWidget = Icon(
         Icons.favorite,
        color:  isSelected ?AppColors.divider(context):AppColors.white,
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
                color: isSelected ? AppColors.divider(context) : AppColors.white,
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
