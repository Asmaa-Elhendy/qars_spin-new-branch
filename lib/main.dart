import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:qarsspin/view/screens/home_screen.dart';

import 'controller/binding.dart';
import 'controller/payments/payment_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize MyFatoorah SDK
    MFSDK.init( //test token (api key)
      PaymentService. apiKey,
      MFCountry.QATAR, // Choose country
    MFEnvironment.TEST, // Change to LIVE later
  );



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    return ScreenUtilInit(
      designSize: const Size(440,956),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,

        initialBinding: MyBinding(),
        theme: ThemeData(
          primaryColor: Colors.white,  // اللون الأساسي أبيض
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, // الخلفية أبيض
            foregroundColor: Colors.black, // الأيقونات + النص أسود
            elevation: 4,                  // ظل بسيط
            iconTheme: IconThemeData(color: Colors.black), // أيقونات أسود
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: 'Flutter Demo',

        home:  HomeScreen(),
      ),
    );
  }
}

