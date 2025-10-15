import 'package:flutter/material.dart';

class AppColors {
  // ثابتة (ما تتغيرش مع الثيم)
  static const Color primary = Color(0xFFF6C42D);
  static const Color accent = Color(0xFF53CBFF);
  static const Color danger = Color(0xFFEC6D64);
  static const Color success = Color(0xFF3AD690);
  static const Color extraLightGray = Color(0xFFEAEAEA);
  static const Color mutedGray = Color(0xFF878A99);
  static const Color inputBorder = Color(0xFFB5B5B5);
  static const Color buttonsGray = Color(0xFFC7C6D3);
  static const Color lightGray = Color(0xFFA3A3A3);
  static const Color brandBlue = Color(0xFF53CBFF);
  static const Color inputFocusedBorder = primary;
  static const Color toastBackground = Color(0xFF363636);
  static const Color logoGray = Color(0xFFB5B5B5);
  static const Color publish = Color(0xFF3AD690);
  static const Color gray = Color(0xFF7C7C7C);
  // Light Mode
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightTextPrimary = Color(0xFF000000);
  static const Color _lightTextSecondary = Color(0xFF7C7C7C);
  static const Color _lightDivider = Color(0xFF7C7C7C);
  static const Color _lightCardBackground = Color(0xFFF3F3F3);
  static const Color black = Color(0xFF000000); // QS_Stays_Black
  static const Color white = Color(0xFFFFFFFF); // QS_Stays_White
  static const Color darkGray = Color(0xFF474747);
  static const Color textMuted = Color(0xFF878A99);
  // Dark Mode
  static const Color _darkBackground = Color(0xFF1A1A1A);
  static const Color _darkTextPrimary = Color(0xFFFFFFFF);
  static const Color _darkTextSecondary = Color(0xFFC0C0C0);
  static const Color _darkDivider = Color(0xFFC0C0C0);
  static const Color _darkCardBackground = Color(0xFF363636);
  static const Color topBoxBackgroundDark = Color(0xFF626262);

  /// 🌗 Theme-aware getters
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _darkBackground
          : _lightBackground;
  static Color darkGreyColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? extraLightGray
          : darkGray;
  static Color tabBarColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkGray
          : extraLightGray;


  // static Color darkTextSecondary(BuildContext context)=>
  //     Theme.of(context).brightness == Brightness.dark?:
  static Color topBox(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? topBoxBackgroundDark
          : _lightDivider;
  static Color shadowColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? extraLightGray
          : mutedGray;
  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _darkCardBackground
          : _lightCardBackground;
  static Color carCardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _darkCardBackground
          : white;
  static Color blackColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? white
        : black;
  }
  static Color greyColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkGray
        : _lightDivider;
  }
  static Color notFavorite(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? lightGray
          : white;



  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _darkTextPrimary
          : _lightTextPrimary;

  static Color lightGrayColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkGray // رمادي غامق للـ Dark
        : lightGray; // رمادي فاتح للـ Light
  }
  static Color profile(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? lightGray // رمادي غامق للـ Dark
        : extraLightGray; // رمادي فاتح للـ Light
  }


  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _darkTextSecondary
          : _lightTextSecondary;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : _lightDivider;

  static Color iconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? lightGray
        : black;
  }
  static Color whiteColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? black
        : white;
  }


}




// import 'package:flutter/material.dart';
//
// class AppColors {
//   // Primary
//   static const Color primary = Color(0xFFF6C42D);
//   static const Color primaryDark = Color(0xFFF36A22);
//   static const Color accent = Color(0xFF53CBFF);
//
//   // Status
//   static const Color success = Color(0xFF3AD690);
//   static const Color warning = Color(0xFFF6C42D);
//   static const Color danger = Color(0xFFEC6D64);
//
//   // Grayscale
//   static const Color black = Color(0xFF000000);
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color darkGray = Color(0xFF474747);
//   static const Color gray = Color(0xFF7C7C7C);
//   static const Color lightGray = Color(0xFFA3A3A3);
//   static const Color mutedGray = Color(0xFF878A99);
//   static const Color extraLightGray = Color(0xFFEAEAEA);
//   static const Color inputBorder = Color(0xFFB5B5B5);
//
//   // Backgrounds
//   static const Color background = Color(0xFFFFFFFF);
//   static const Color cardBackground = Color(0xFFF3F3F3);
//   static const Color topBoxBackground = Color(0xFF7C7C7C);
//
//   // Text
//   static const Color textPrimary = Color(0xFF000000);
//   static const Color textSecondary = Color(0xFF7C7C7C);
//   static const Color textMuted = Color(0xFF878A99);
//   static const Color textLight = Color(0xFF212529);
//
//   // UI Elements
//   static const Color divider = Color(0xFF7C7C7C);
//   static const Color star = Color(0xFFF6C42D);
//   static const Color starInactive = Color(0xFF7C7C7C);
//   static const Color buttonBarNormal = Color(0xFFFFFFFF);
//   static const Color buttonBarSelected = Color(0xFF7C7C7C);
//   static const Color publish = Color(0xFF3AD690);
//
//   // Brand
//   static const Color brandOrange = Color(0xFFF6C42D);
//   static const Color inputFocusedBorder = primary;
//   static const Color brandBlue = Color(0xFF53CBFF);
//   static const Color brandLightOrange = Color(0xFFECBD8B);
//
//   // Toast
//   static const Color toastBackground = Color(0xFF363636);
//   static const Color toastTitle = Color(0xFFF6C42D);
//   static const Color toastMessage = Color(0xFFFFFFFF);
//
//   // Dark Mode
//   static const Color darkBackground = Color(0xFF1A1A1A);
//   static const Color darkCardBackground = Color(0xFF363636);
//   static const Color darkTextPrimary = Color(0xFFFFFFFF);
//   static const Color darkTextSecondary = Color(0xFFC0C0C0);
//   static const Color darkDivider = Color(0xFFC0C0C0);
//   static const Color darkStarInactive = Color(0xFFC0C0C0);
//
//   // Misc
//   static const Color floatyGray = Color(0xFF7C7C7C);
//   static const Color floatyBorderDark = Color(0xFF000000);
//   static const Color buttonsGray = Color(0xFFC7C6D3);
//   static const Color logoGray = Color(0xFFB5B5B5);
// }
//
// extension AppThemeExtension on ThemeData {
//   bool get isDarkMode => brightness == Brightness.dark;
//
//   // Backgrounds
//   Color get backgroundColor => isDarkMode ? AppColors.darkBackground : AppColors.background;
//   Color get cardColor => isDarkMode ? AppColors.darkCardBackground : AppColors.cardBackground;
//
//   // Text
//   Color get textPrimaryColor => isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;
//   Color get textSecondaryColor => isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;
//
//   // Divider
//   Color get dividerColor => isDarkMode ? AppColors.darkDivider : AppColors.divider;
//
//   // Stars
//   Color get starInactiveColor => isDarkMode ? AppColors.darkStarInactive : AppColors.starInactive;
// }
//
// // class AppColors {
// //   // Primary Colors
// //   static const Color primary = Color(0xFFF6C42D); // QS_Logo_Orange
// //   static const Color primaryDark = Color(0xFFF36A22); // FadelsGadgets_Orange
// //   static const Color accent = Color(0xFF53CBFF); // QS_Visits_Blue
// //
// //   // Status Colors
// //   static const Color success = Color(0xFF3AD690); // QS_Success
// //   static const Color warning = Color(0xFFF6C42D); // QS_Warning
// //   static const Color danger = Color(0xFFEC6D64); // QS_Danger
// //
// //   // Grayscale
// //   static const Color black = Color(0xFF000000); // QS_Stays_Black
// //   static const Color white = Color(0xFFFFFFFF); // QS_Stays_White
// //   static const Color darkGray = Color(0xFF474747); // DrStore_Gray_Shade_1
// //   static const Color gray = Color(0xFF7C7C7C); // QS_Dark_Gray
// //   static const Color lightGray = Color(0xFFA3A3A3); // DrStore_Gray_Shade_3
// //   static const Color mutedGray = Color(0xFF878A99); // QS_MutedGray
// //   static const Color extraLightGray = Color(0xFFEAEAEA); // DrStore_Gray_Shade_4
// //   static const Color inputBorder = Color(0xFFB5B5B5);
// //
// //
// //
// //
// //   // Backgrounds
// //   static const Color background = Color(0xFFFFFFFF); // QS_Box_Background (light)
// //   static const Color cardBackground = Color(0xFFF3F3F3); // QS_Cell_BG_Gray (light)
// //   static const Color topBoxBackground = Color(0xFF7C7C7C); // QS_Top_Box_Background (light)
// //
// //   // Text
// //   static const Color textPrimary = Color(0xFF000000); // QS_Text_Main (light)
// //   static const Color textSecondary = Color(0xFF7C7C7C); // QS_Text_Sub (light)
// //   static const Color textMuted = Color(0xFF878A99); // QS_MutedGray
// //   static const Color textLight =   Color(0xFF212529);
// //
// //
// //   // UI Elements
// //   static const Color divider = Color(0xFF7C7C7C); // QS_Devider
// //   static const Color star = Color(0xFFF6C42D); // QS_Star_Yellow
// //   static const Color starInactive = Color(0xFF7C7C7C); // QS_Star_Gray (light)
// //   static const Color buttonBarNormal = Color(0xFFFFFFFF); // QS_ButtonBar_Normal
// //   static const Color buttonBarSelected = Color(0xFF7C7C7C); // QS_ButtonBar_Selected
// //
// //   static const Color publish = Color(0xFF3AD690); // QS_ButtonBar_Selected
// //
// //
// //   // Brand Specific
// //   static const Color brandOrange = Color(0xFFF6C42D); // QS_Logo_Orange
// //   static const Color inputFocusedBorder = primary;
// //
// //   static const Color brandBlue = Color(0xFF53CBFF); // QS_Visits_Blue
// //   static const Color brandLightOrange = Color(0xFFECBD8B); // DrStore_Orange_Light
// //
// //   // Toast
// //   static const Color toastBackground = Color(0xFF363636); // toast_Background (light)
// //   static const Color toastTitle = Color(0xFFF6C42D); // toast_Title (light)
// //   static const Color toastMessage = Color(0xFFFFFFFF); // toast_Message (light)
// //
// //   // Dark Mode Colors
// //   static const Color darkBackground = Color(0xFF1A1A1A); // Activity_Gray_Background (dark)
// //   static const Color darkCardBackground = Color(0xFF363636); // QS_Box_Background (dark)
// //   static const Color darkTextPrimary = Color(0xFFFFFFFF); // QS_Text_Main (dark)
// //   static const Color darkTextSecondary = Color(0xFFC0C0C0); // QS_Text_Sub (dark)
// //   static const Color darkDivider = Color(0xFFC0C0C0); // QS_Text_Lines (dark)
// //   static const Color darkStarInactive = Color(0xFFC0C0C0); // QS_Star_Gray (dark)
// //
// //   // Material Design Colors (from the theme)
// //   static const Color materialPurple200 = Color(0xFFBB86FC);
// //   static const Color materialPurple500 = Color(0xFF6200EE);
// //   static const Color materialPurple700 = Color(0xFF3700B3);
// //   static const Color materialTeal200 = Color(0xFF03DAC5);
// //   static const Color materialTeal700 = Color(0xFF018786);
// //
// //   // Additional Colors
// //   static const Color floatyGray = Color(0xFF7C7C7C); // floaty_Gray
// //   static const Color floatyBorderDark = Color(0xFF000000); // floaty_border_dark_mode
// //   static const Color buttonsGray = Color(0xFFC7C6D3); // Buttons_Gray
// //   static const Color logoGray = Color(0xFFB5B5B5); // QS_Logo_Gray
// // }
// //
// // // Extension to handle theme modes
// // extension AppThemeExtension on ThemeData {
// //   bool get isDarkMode => brightness == Brightness.dark;
// //
// //   Color get surfaceColor => isDarkMode ? AppColors.darkBackground : AppColors.background;
// //   Color get onSurfaceColor => isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;
// //   Color get secondaryTextColor => isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;
// //   Color get dividerColor => isDarkMode ? AppColors.darkDivider : AppColors.divider;
// //   Color get cardColor => isDarkMode ? AppColors.darkCardBackground : AppColors.cardBackground;
// // }
