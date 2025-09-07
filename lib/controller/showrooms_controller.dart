

import 'dart:convert';

import 'package:get/get.dart';
import 'package:qarsspin/model/showroom_model.dart';
import 'package:http/http.dart' as http;

import 'const/base_url.dart';


class ShowRoomsController extends GetxController{

  List<Showroom> showRoomForSale =[
    // Showroom(
    //   name: "Car Dealer",
    //   logoUrl: "assets/images/showroom1.png",
    //   carsCount: 1232,
    //   views: 120,
    //   rating: 4.5,
    //   isFeatured: true,
    // ),
    // Showroom(
    //   name: "Luxury Motors",
    //   logoUrl: "assets/images/showroom2.png",
    //   carsCount: 842,
    //   views: 89,
    //   rating: 4.2,
    // ),
  ];

  fetchShowrooms({String partnerKind = "Car Showroom" }) async {
    showRoomForSale = [];
    final url = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetListOfApprovedPartners?Partner_Kind=$partnerKind&Sort_By=lb_Sort_By_Avg_Rating_Desc",
    );

      final response = await http.get(url);
      print("ress${response.statusCode}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (true) {
          for(int i =0;i <body["Data"].length;i++){
            showRoomForSale.add(
                Showroom(
                  id: body["Data"][i]["Partner_ID"] ,
                  name: body["Data"][i]["Partner_Name_PL"],
                    logoUrl: body["Data"][i]["Logo_URL"],
                    carsCount: 00,//for now
                    views: body["Data"][i]["Visits_Count"],
                     rating: body["Data"][i]["Avg_Rating"],
                  isFeatured: body["Data"][i]["Pin_To_Top"]==1?true:false,
                ));
            print("imaaaaaaaaaaaaaaage${body["Data"][i]["Banner_URL_SL"]}");

          }
          update();


        } else {
          throw Exception("Invalid API response format");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }

  }

}