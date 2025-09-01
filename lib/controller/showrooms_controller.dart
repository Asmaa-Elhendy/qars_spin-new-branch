

import 'package:get/get.dart';

import '../model/showroom_model.dart';

class ShowRoomsController extends GetxController{

  List<Showroom> showRoomForSale =[
    Showroom(
      name: "Car Dealer",
      logoUrl: "assets/images/showroom1.png",
      carsCount: 1232,
      views: 120,
      rating: 4.5,
      isFeatured: true,
    ),
    Showroom(
      name: "Luxury Motors",
      logoUrl: "assets/images/showroom2.png",
      carsCount: 842,
      views: 89,
      rating: 4.2,
    ),
  ];

}