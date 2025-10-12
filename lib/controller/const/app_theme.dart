import 'package:flutter/material.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    //scaffoldBackgroundColor: AppColors.background(null), // optional
    fontFamily: fontFamily, // مثلًا
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    fontFamily: fontFamily,
  );
}


//
// import 'package:flutter/material.dart';
// import 'colors.dart';
//
// class AppTheme {
//   // 🌞 Light Theme
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: AppColors.primary,
//     scaffoldBackgroundColor: AppColors.background,
//     cardColor: AppColors.cardBackground,
//     dividerColor: AppColors.divider,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.background,
//       iconTheme: IconThemeData(color: AppColors.textPrimary),
//       titleTextStyle: TextStyle(
//         color: AppColors.textPrimary,
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: AppColors.textPrimary),
//       bodyMedium: TextStyle(color: AppColors.textSecondary),
//       labelLarge: TextStyle(color: AppColors.textMuted),
//     ),
//     iconTheme: const IconThemeData(color: AppColors.textPrimary),
//     colorScheme: const ColorScheme.light(
//       primary: AppColors.primary,
//       secondary: AppColors.accent,
//       surface: AppColors.cardBackground,
//       onSurface: AppColors.textPrimary,
//       onSecondary: AppColors.textSecondary,
//       error: AppColors.danger,
//     ),
//   );
//
//   // 🌙 Dark Theme
//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: AppColors.primaryDark,
//     scaffoldBackgroundColor: AppColors.darkBackground,
//     cardColor: AppColors.darkCardBackground,
//     dividerColor: AppColors.darkDivider,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.darkBackground,
//       iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
//       titleTextStyle: TextStyle(
//         color: AppColors.darkTextPrimary,
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
//       bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
//       labelLarge: TextStyle(color: AppColors.darkTextSecondary),
//     ),
//     iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
//     colorScheme: const ColorScheme.dark(
//       primary: AppColors.primaryDark,
//       secondary: AppColors.accent,
//       surface: AppColors.darkCardBackground,
//       onSurface: AppColors.darkTextPrimary,
//       onSecondary: AppColors.darkTextSecondary,
//       error: AppColors.danger,
//     ),
//   );
// }
