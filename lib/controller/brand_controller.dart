
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qarsspin/controller/const/base_url.dart';

import '../model/car_brand.dart';
import '../model/car_model.dart';

class BrandController extends GetxController{
  List<CarModel> carsList = [
  ];
  String currentModelPointer = "";
  List<CarBrand>  carBrands= [
    CarBrand(
      id: 0,
      make_count: 0,
      name: 'All Cars',
      imageUrl: 'assets/images/ic_all_cars.png',
      isAllCars: true,
    ),

  ];

 fetchCarMakes() async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarMakes?Order_By=MakeName',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = response.body;
      final parsedJson = jsonDecode(body);
      final List<dynamic> data = parsedJson['Data'];
      int? allCarsCount = 0;
      for(int i =0; i<data.length;i++){
        allCarsCount = (allCarsCount! + data[i]["Make_Count"]) as int?;
        carBrands.add(CarBrand(
            id:data[i]["Make_ID"] ,
            make_count: data[i]["Make_Count"],
            name: data[i]["Make_Name_PL"], imageUrl: data[i]["Image_URL"]??""));
      }
      carBrands[0].make_count = allCarsCount!;


}




  }

  getCars({required int make_id, required String makeName,String sourceKind="All"}) async {
   carsList = [];
   print(make_id);
    final filterDetails = {
      "Source_Kind":sourceKind,
      "Offset": "0",
      "Limit": "10",
      "Make_ID": "$make_id",
      "Class_ID": "0",
      "Model_ID": "0",
      "Category_ID": "0",
      "Year_Min": "0",
      "Year_Max": "0",
      "Price_Min": "0",
      "Price_Max": "0",
      "Sort_By": "lb_Sort_By_Post_Date_Desc",
    };

    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetListOfCarsForSale?Filter_Details=${Uri.encodeComponent(jsonEncode(filterDetails))}",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);
      for(int i = 0; i<body["Data"].length;i++){
        carsList.add(
            CarModel(postId: body["Data"][i]["Post_ID"],
                pinToTop: body["Data"][i]["Pin_To_Top"],
                postCode:body["Data"][i]["Post_Code"],
                carNamePl:body["Data"][i]["Car_Name_PL"],
                carNameSl: body["Data"][i]["Car_Name_SL"],
                carNameWithYearPl: body["Data"][i]["Car_Name_With_Year_PL"],
                carNameWithYearSl: body["Data"][i]["Car_Name_With_Year_SL"],
                manufactureYear: body["Data"][i]["Manufacture_Year"],
                tag: body["Data"][i]["Tag"],
                sourceKind: body["Data"][i]["Source_Kind"],
                mileage: body["Data"][i]["Mileage"],
                askingPrice:  body["Data"][i]["Asking_Price"],
                rectangleImageFileName:  body["Data"][i]["Rectangle_Image_FileName"],
                rectangleImageUrl:  body["Data"][i]["Rectangle_Image_URL"]));
      }

      update();
      currentModelPointer = makeName;
      final data = jsonDecode(response.body);
      return data is List ? data : [];

    } else {
      throw Exception("Failed to load cars: ${response.statusCode}");
    }



  }









}