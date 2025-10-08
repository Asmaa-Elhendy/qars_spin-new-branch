
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qarsspin/controller/ads/data_layer.dart';
import 'package:qarsspin/controller/const/base_url.dart';
import 'package:qarsspin/model/offer.dart';
import 'package:qarsspin/model/specification.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/car_brand.dart';
import '../model/car_model.dart';

class BrandController extends GetxController{
  bool loadingMode = true;
  List<CarModel> carsList = [];
  List<CarModel> similarCars = [];
  List<CarModel> ownersAds = [];
  List<CarModel> favoriteList = [];

  CarModel carDetails =
  CarModel(postId: 0, pinToTop: 0, postCode: "postCode", carNamePl: "carNamePl",
      postKind: "",
      carNameSl: "carNameSl", carNameWithYearPl: "carNameWithYearPl",
      carNameWithYearSl: "carNameWithYearSl", manufactureYear: 0, tag: "tag",
      sourceKind: "sourceKind", mileage: 0, askingPrice: "askingPrice",
      description: "",
      exteriorColor: Colors.white,
      interiorColor: Colors.white,
      isFavorite: false,

      offersCount: 0,
      visitsCount: 0,
      warrantyAvailable: "No",
      rectangleImageFileName: "rectangleImageFileName", rectangleImageUrl: "rectangleImageUrl");
  String currentModelPointer = "";
  List<Specifications> spec = [];
  List<CarBrand>  carBrands= [
    CarBrand(
      id: 0,
      make_count: 0,
      name: 'All Cars',
      imageUrl: 'assets/images/ic_all_cars.png',
      isAllCars: true,
    ),

  ];
  List<Offer> offers = [];
  String currentSourceKind = "All";
  int currentMakeId = 0;
  String currentMakeName ="";

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", ""); // remove the "#"
    if (hex.length == 6) {
      hex = "FF$hex"; // add alpha (opacity) if missing
    }
    return Color(int.parse(hex, radix: 16));
  }
  String convertToTimeAgo(String dateString) {
    // Parse the string into DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // Format with timeago
    return timeago.format(dateTime);
  }

  fetchCarMakes({String sort = "MakeName"}) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarMakes?Order_By=$sort',
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


      update();
    }

    return carBrands;


  }
  switchLoading(){
    loadingMode = true;
    update();
  }

  getCars({required int make_id, required String makeName,String sourceKind="All",sort = "lb_Sort_By_Post_Date_Desc",}) async {
    carsList=[];
    currentSourceKind = sourceKind;
    currentMakeId = make_id;
    currentMakeName = makeName;
    final filterDetails = {
      "Source_Kind":sourceKind,
      "Offset": "0",
      "Limit": "1000",
      "Make_ID": "$make_id",
      "Class_ID": "0",
      "Model_ID": "0",
      "Category_ID": "0",
      "Year_Min": "0",
      "Year_Max": "0",
      "Price_Min": "0",
      "Price_Max": "0",
      "Sort_By": sort,
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
                postKind: "",

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
      loadingMode = false;
      currentModelPointer = makeName;

      update();
      final data = jsonDecode(response.body);
      return data is List ? data : [];

    } else {
      throw Exception("Failed to load cars: ${response.statusCode}");
    }



  }

  getCarDetails(String postKind,String id) async{
    print("postttt$postKind");
    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetPostByID?Post_Kind=$postKind&Post_ID=$id&Logged_In_User=sv4it",
    );
    final response = await http.get(uri);
    getCarSpec(id);
    getOffers(id);
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      Color exterior = hexToColor(body["Data"][0]["Color_Exterior"]);
      Color interior = hexToColor(body["Data"][0]["Color_Interior"]);

      carDetails =
          CarModel(
              postId: body["Data"][0]["Post_ID"],
              pinToTop: body["Data"][0]["Pin_To_Top"],
              postCode: body["Data"][0]["Post_Code"],
              postKind: body["Data"][0]["Post_Kind"],
              carNamePl: body["Data"][0]["Car_Name_PL"],
              carNameSl: body["Data"][0]["Car_Name_SL"],
              carNameWithYearPl: body["Data"][0]["Car_Name_With_Year_PL"],
              carNameWithYearSl: body["Data"][0]["Car_Name_With_Year_SL"],
              manufactureYear: body["Data"][0]["Manufacture_Year"],
              tag: body["Data"][0]["Tag"],
              sourceKind: body["Data"][0]["Source_Kind"],
              mileage: body["Data"][0]["Mileage"],
              askingPrice: body["Data"][0]["Asking_Price"],
              rectangleImageFileName: body["Data"][0]["Rectangle_Image_FileName"],
              rectangleImageUrl: body["Data"][0]["Rectangle_Image_URL"],
              exteriorColor: exterior,
              interiorColor:interior,
              description: body["Data"][0]["Technical_Description_PL"],
              offersCount: body["Data"][0]["Offers_Count"],
              warrantyAvailable: body["Data"][0]["Warranty_isAvailable"] ==0?"No":"Yes",
              visitsCount: body["Data"][0]["Visits_Count"],
              isFavorite: body["Data"][0]["isFavorite"]==0?false:true

          );
      update();

    }




  }

  getCarSpec(id) async{
    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetSpecsOfPostByID?Post_ID=$id&Selected_Language=PL",
    );
    final response = await http.get(uri);
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      if(body["Data"]!=null) {
        for (int i = 0; i < body["Data"].length; i++) {
          spec.add(Specifications(value: body["Data"][i]["Spec_Value"],
              key: body["Data"][i]["Spec_Header"]));
        }
      }
      update();

    }


  }
  getOffers(id)async{
    offers =[];
    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetOffersOfPostByID?Post_ID=$id",
    );
    final response = await http.get(uri);
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      if(body["Data"]!=null){
        for(int i =0;i<body["Data"].length;i++){
          String time = convertToTimeAgo( body["Data"][i]["Offer_DateTime"]);
          offers.add(Offer(
              id: body["Data"][i]["Offer_ID"],
              price: body["Data"][i]["Offer_Price"],
              avatarUrl: body["Data"][i]["Avatar_URL"]??"",
              dateTime: time,
              fullName: body["Data"][i]["Full_Name"]??"",
              origin: body["Data"][i]["Offer_Origin"],
              postId: body["Data"][i]["Post_ID"],
              userName: body["Data"][i]["UserName"]));

        }}
      update();
    }

  }
  makeOffer({ required String offerPrice})async{
    try {
      final response = await http.post(
        Uri.parse('$base_url/BrowsingRelatedApi.asmx/RegisterOfferFromUser'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'UserName': "sv4it",
          'Post_ID': carDetails.postId.toString(),
          'Offer_Origin': "MobileApp",
          'Our_Secret': ourSecret,
          'Offer_Price': offerPrice,
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        getOffers(carDetails.postId);
        print("posr${carDetails.postId}");
        print(body);


      }
    }catch(e){
      return {
        'success': false,
        'message': 'Error: $e',
      };

    }
  }
  buyWithLoan({required String downPayment,required String installmentsCount,required String nationality})async{
    final response = await http.post(
      Uri.parse('$base_url/QarsSpinRelatedApi.asmx/RequestForLoan'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'UserName': "sv4it",
        'Post_ID': carDetails.postId.toString(),
        'Offer_Origin': "MobileApp",
        'Asking_Price':carDetails.askingPrice.toString(),
        'Down_Payment': downPayment,
        'Installments_Count': installmentsCount,
        'Nationality': nationality,
        'Our_Secret': ourSecret,

      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("bodyyyyyyloan$body");
      return body["Code"];

    }
  }

  inspectioReport(id)async{
    try {
      final response = await http.post(
        Uri.parse('$base_url/QarsSpinRelatedApi.asmx/RequestNewInspectionReport'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'UserName':"sv4it",
          'Post_ID': id.toString(),
          'Our_Secret': ourSecret
        },
      );
      print("code${response.statusCode}");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body);
      }

    }catch(e){

    }
  }
  searchCar({required int make_id,  String makeName="All Cars",String sourceKind="All",sort = "lb_Sort_By_Post_Date_Desc", required String classId, required String makeId,required String modelId,required String catId,required String yearMin, yearMax,required String priceMin,required String priceMax}) async {
    carsList=[];
    currentSourceKind = sourceKind;
    currentMakeId = make_id;
    currentMakeName = makeName;

    final filterDetails = {
      "Source_Kind":sourceKind,
      "Offset": "0",
      "Limit": "1000",
      "Make_ID": make_id,
      "Class_ID": classId,
      "Model_ID": modelId,
      "Category_ID": catId,
      "Year_Min": yearMin,
      "Year_Max": yearMax,
      "Price_Min": priceMin,
      "Price_Max": priceMax,
      "Sort_By": sort,
    };

    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetListOfCarsForSale?Filter_Details=${Uri.encodeComponent(jsonEncode(filterDetails))}",
    );

    final response = await http.get(uri);


    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);
      if(body["Data"]==null){
        carsList = [];

      }else{
        for(int i = 0; i<body["Data"].length;i++){
          carsList.add(
              CarModel(postId: body["Data"][i]["Post_ID"],
                  pinToTop: body["Data"][i]["Pin_To_Top"],
                  postCode:body["Data"][i]["Post_Code"],
                  carNamePl:body["Data"][i]["Car_Name_PL"],
                  postKind: "",

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
      }
      loadingMode = false;
      currentModelPointer = makeName;
      print("muybidyyy$body");

      update();
      final data = jsonDecode(response.body);
      return data is List ? data : [];

    } else {
      throw Exception("Failed to load cars: ${response.statusCode}");
    }



  }

  getSimilarCars()async{


  }

  getOwnersAds()async{}

  alterPostFavorite({required bool add,required int postId})async{
    try {
      final response = await http.post(
        Uri.parse('$base_url/GlobalApi.asmx/AlterPostFavorite'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'UserName': "sv4it",
          'Post_ID': postId.toString(),
          'Operation': add?"Add":"Remove",
          'Our_Secret': ourSecret,
        },
      );
      if(response.statusCode==200){
        final body = jsonDecode(response.body);
        if(body["Code"] == "OK"){
          carDetails.isFavorite = add?true:false;
          update();
        }



      }



    }catch (e){
      return "error";
    }
  }
  removeFavItem(CarModel car){
    favoriteList.remove(car);
    update();
  }
  getFavList()async{
    print("call");
    favoriteList=[];

    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetFavoritesByUser?UserName=sv4it&Our_Secret=$ourSecret",
    );

    final response = await http.get(uri);
    print("resss${response.statusCode}");


    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for(int i = 0; i<body["Data"].length;i++){
        favoriteList.add(
            CarModel(postId: body["Data"][i]["Post_ID"],
                pinToTop: body["Data"][i]["Pin_To_Top"],
                postKind: body["Data"][i]["Post_Kind"],
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


    }


  }

}
