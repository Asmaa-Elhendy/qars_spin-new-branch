import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFF6C42D); // QS_Logo_Orange
  static const Color primaryDark = Color(0xFFF6A931); // Darker shade of primary
  
  // Brand Colors
  static const Color brandOrange = Color(0xFFF36A22); // FadelsGadgets_Orange
  static const Color brandBlue = Color(0xFF53CBFF); // FadelsGadgets_Blue, QS_Visits_Blue
  
  // Grayscale
  static const Color black = Color(0xFF000000); // FadelsGadgets_Black, QS_Stays_Black
  static const Color darkGray1 = Color(0xFF212529); // QS_Black
  static const Color darkGray2 = Color(0xFF474747); // DrStore_Gray_Shade_1
  static const Color darkGray3 = Color(0xFF7C7C7C); // QS_Dark_Gray
  static const Color gray1 = Color(0xFFA3A3A3); // DrStore_Gray_Shade_3
  static const Color gray2 = Color(0xFFB5B5B5); // QS_Logo_Gray
  static const Color lightGray1 = Color(0xFFC7C6D3); // Buttons_Gray
  static const Color lightGray2 = Color(0xFFEAEAEA); // DrStore_Gray_Shade_4
  static const Color lightGray3 = Color(0xFFF3F3F3); // QS_LightGray
  static const Color white = Color(0xFFFFFFFF); // DrStore_White, QS_Stays_White
  
  // Status Colors
  static const Color success = Color(0xFF3AD690); // QS_Success
  static const Color error = Color(0xFFEC6D64); // QS_Danger
  static const Color warning = Color(0xFFF6C42D); // QS_Warning
  static const Color info = Color(0xFF53CBFF); // Same as brandBlue
  
  // Text Colors
  static const Color textPrimary = Color(0xFF000000); // QS_Text_Main
  static const Color textSecondary = Color(0xFF7C7C7C); // QS_Text_Lines
  static const Color textTertiary = Color(0xFFA3A3A3); // DrStore_Gray_Shade_3
  static const Color textInverse = Color(0xFFFFFFFF); // White text on dark backgrounds
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // QS_Box_Background
  static const Color surface = Color(0xFFF3F3F3); // QS_LightGray
  
  // UI Elements
  static const Color divider = Color(0xFF7C7C7C); // QS_Devider
  static const Color border = Color(0xFFB5B5B5); // QS_Logo_Gray
  static const Color disabled = Color(0xFFC7C6D3); // Buttons_Gray
  
  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFFE0E0E0);
  static const Color buttonTextPrimary = Colors.white;
  static const Color buttonTextSecondary = Color(0xFF212121);
  
  // Input Fields
  static const Color inputBackground = Colors.white;
  static const Color inputBorder = Color(0xFFB5B5B5);
  static const Color inputFocusedBorder = primary;
  static const Color inputErrorBorder = error;
  static const Color inputText = textPrimary;
  static const Color inputHint = textSecondary; // Replaced textHint with textSecondary
  static const Color inputLabel = textSecondary;
  
  // Card Colors
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x1F000000);
  
  // Social Colors
  static const Color facebook = Color(0xFF3B5998);
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Status Bar Colors
  static const Color statusBarLight = Colors.white;
  static const Color statusBarDark = Color(0xFF212121);
  
  // Bottom Navigation Colors
  static const Color bottomNavBackground = Colors.white;
  static const Color bottomNavSelected = primary;
  static const Color bottomNavUnselected = Color(0xFF7C7C7C); // QS_Dark_Gray
  
  // Tag Colors
  static const Color tagNew = Color(0xFFFF6B00);
  static const Color tagInspected = Color(0xFF4CAF50);
  static const Color tagSold = Color(0xFFE53935);
  static const Color tagFeatured = Color(0xFFFFA000);
  
  // Country Flags
  static const Color qatar = Color(0xFF8A1538);
  static const Color saudiArabia = Color(0xFF245C36);
  static const Color uae = Color(0xFFEF3340);
  static const Color bahrain = Color(0xFFCE1126);
  static const Color oman = Color(0xFFDB1F35);
  static const Color kuwait = Color(0xFFF31830);
}
