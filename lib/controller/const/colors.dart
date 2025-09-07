import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFF6C42D); // QS_Logo_Orange
  static const Color primaryDark = Color(0xFFF36A22); // FadelsGadgets_Orange
  static const Color accent = Color(0xFF53CBFF); // QS_Visits_Blue

  // Status Colors
  static const Color success = Color(0xFF3AD690); // QS_Success
  static const Color warning = Color(0xFFF6C42D); // QS_Warning
  static const Color danger = Color(0xFFEC6D64); // QS_Danger

  // Grayscale
  static const Color black = Color(0xFF000000); // QS_Stays_Black
  static const Color white = Color(0xFFFFFFFF); // QS_Stays_White
  static const Color darkGray = Color(0xFF474747); // DrStore_Gray_Shade_1
  static const Color gray = Color(0xFF7C7C7C); // QS_Dark_Gray
  static const Color lightGray = Color(0xFFA3A3A3); // DrStore_Gray_Shade_3
  static const Color mutedGray = Color(0xFF878A99); // QS_MutedGray
  static const Color extraLightGray = Color(0xFFEAEAEA); // DrStore_Gray_Shade_4
  static const Color inputBorder = Color(0xFFB5B5B5);




  // Backgrounds
  static const Color background = Color(0xFFFFFFFF); // QS_Box_Background (light)
  static const Color cardBackground = Color(0xFFF3F3F3); // QS_Cell_BG_Gray (light)
  static const Color topBoxBackground = Color(0xFF7C7C7C); // QS_Top_Box_Background (light)

  // Text
  static const Color textPrimary = Color(0xFF000000); // QS_Text_Main (light)
  static const Color textSecondary = Color(0xFF7C7C7C); // QS_Text_Sub (light)
  static const Color textMuted = Color(0xFF878A99); // QS_MutedGray
  static const Color textLight =   Color(0xFF212529);


  // UI Elements
  static const Color divider = Color(0xFF7C7C7C); // QS_Devider
  static const Color star = Color(0xFFF6C42D); // QS_Star_Yellow
  static const Color starInactive = Color(0xFF7C7C7C); // QS_Star_Gray (light)
  static const Color buttonBarNormal = Color(0xFFFFFFFF); // QS_ButtonBar_Normal
  static const Color buttonBarSelected = Color(0xFF7C7C7C); // QS_ButtonBar_Selected

  static const Color publish = Color(0xFF3AD690); // QS_ButtonBar_Selected


  // Brand Specific
  static const Color brandOrange = Color(0xFFF6C42D); // QS_Logo_Orange
  static const Color inputFocusedBorder = primary;

  static const Color brandBlue = Color(0xFF53CBFF); // QS_Visits_Blue
  static const Color brandLightOrange = Color(0xFFECBD8B); // DrStore_Orange_Light

  // Toast
  static const Color toastBackground = Color(0xFF363636); // toast_Background (light)
  static const Color toastTitle = Color(0xFFF6C42D); // toast_Title (light)
  static const Color toastMessage = Color(0xFFFFFFFF); // toast_Message (light)

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF1A1A1A); // Activity_Gray_Background (dark)
  static const Color darkCardBackground = Color(0xFF363636); // QS_Box_Background (dark)
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // QS_Text_Main (dark)
  static const Color darkTextSecondary = Color(0xFFC0C0C0); // QS_Text_Sub (dark)
  static const Color darkDivider = Color(0xFFC0C0C0); // QS_Text_Lines (dark)
  static const Color darkStarInactive = Color(0xFFC0C0C0); // QS_Star_Gray (dark)

  // Material Design Colors (from the theme)
  static const Color materialPurple200 = Color(0xFFBB86FC);
  static const Color materialPurple500 = Color(0xFF6200EE);
  static const Color materialPurple700 = Color(0xFF3700B3);
  static const Color materialTeal200 = Color(0xFF03DAC5);
  static const Color materialTeal700 = Color(0xFF018786);

  // Additional Colors
  static const Color floatyGray = Color(0xFF7C7C7C); // floaty_Gray
  static const Color floatyBorderDark = Color(0xFF000000); // floaty_border_dark_mode
  static const Color buttonsGray = Color(0xFFC7C6D3); // Buttons_Gray
  static const Color logoGray = Color(0xFFB5B5B5); // QS_Logo_Gray
}

// Extension to handle theme modes
extension AppThemeExtension on ThemeData {
  bool get isDarkMode => brightness == Brightness.dark;

  Color get surfaceColor => isDarkMode ? AppColors.darkBackground : AppColors.background;
  Color get onSurfaceColor => isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get secondaryTextColor => isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get dividerColor => isDarkMode ? AppColors.darkDivider : AppColors.divider;
  Color get cardColor => isDarkMode ? AppColors.darkCardBackground : AppColors.cardBackground;
}
