

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:qarsspin/controller/rental_cars_controller.dart';
import 'package:qarsspin/controller/showrooms_controller.dart';
import 'package:qarsspin/controller/specs_controller.dart';

import 'brand_controller.dart';

class MyBinding implements  Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BrandController(),fenix: true);
    Get.lazyPut(() => ShowRoomsController(),fenix: true);
    Get.lazyPut(() => RentalCarsController(),fenix: true);
    Get.lazyPut(() => SpecsController(),fenix:true);
  }
}