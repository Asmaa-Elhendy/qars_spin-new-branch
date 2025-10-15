import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:qarsspin/services/fcm_service.dart';
import 'package:qarsspin/view/screens/home_screen.dart';

import 'controller/Theme_controller.dart';
import 'controller/auth/secret.dart';
import 'controller/binding.dart';
import 'controller/const/app_theme.dart';
import 'controller/notifications_controller.dart';
import 'controller/payments/payment_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ضروري قبل استخدام التخزين
  Get.put(ThemeController());
  // ✅ Initialize MyFatoorah SDK
  // PaymentService.initialize();
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize MyFatoorah SDK
  PaymentService.initialize();
  settings();

  // Initialize FCM Service and register with GetX
  final fcmService = FCMService();
  await fcmService.initialize();
  Get.put(fcmService);  // Register the instance with GetX

  // Initialize Notifications Controller
  Get.put(NotificationsController());
  settings();



  runApp( MyApp());
}

class MyApp extends StatelessWidget {MyApp({super.key});


// This widget is the root of your application.
//ThemeMode _themeMode = ThemeMode.light;
final ThemeController themeController = Get.find();  @override
Widget build(BuildContext context) {
  double width=MediaQuery.of(context).size.width;
  double height=MediaQuery.of(context).size.height;

  return ScreenUtilInit(
      designSize: const Size(440,956),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Obx(() =>GetMaterialApp(
        debugShowCheckedModeBanner: false,

        initialBinding: MyBinding(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode.value,// يتحكم في الوضع الحالي
        title: 'Flutter Demo',

        home:  HomeScreen(),
      ))
  );
}
}
