

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/car_model.dart';
import '../model/rental_car_model.dart';
import 'const/base_url.dart';

class RentalCarsController extends GetxController{
  
  List<RentalCar> rentalCars =[

  ];
  // استدعاء API
   fetchRentalCars() async {
    rentalCars = [];
    const String url =
        "https://qarsspintest.smartvillageqatar.com/QarsSpinAPI/BrowsingRelatedApi.asmx/GetListOfCarsForRent";

    // body مع الفلتر
     final filterDetails = {
    'Source_Kind': 'All',
    'Limit': '10',
    'Make_ID': '0',
    'Class_ID': '0',
    'Model_ID': '0',
    'Category_ID': '0',
    'Year_Min': '0',
    'Year_Max': '0',
    'Price_Min': '0',
    'Price_Max': '0',
    'Sort_By': 'lb_Sort_By_Post_Date_Desc'
  };

    final uri = Uri.parse(
      "$base_url/BrowsingRelatedApi.asmx/GetListOfCarsForRent?Filter_Details=${Uri.encodeComponent(jsonEncode(filterDetails))}",
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print("for${response.statusCode}");

      final body = jsonDecode(response.body);
      print(body);


       

        // data.map((e) => RentalCar.fromJson(e)).toList();
        for (int i = 0; i <  body["Data"].length; i++){

          rentalCars.add(
              RentalCar(
                  postId:   body["Data"][i]["Post_ID"],
                  countryCode:   body["Data"][i]["Country_Code"],
                  postCode:   body["Data"][i]["Post_Code"],
                  postKind:   body["Data"][i]["Post_Kind"],
                  postStatus:   body["Data"][i]["Post_Status"],
                  pinToTop:   body["Data"][i]["Pin_To_Top"],
                  tag:   body["Data"][i]["Tag"],
                  sourceKind:   body["Data"][i]["Source_Kind"],
                  partnerId:   body["Data"][i]["Partner_ID"],
                  userName:   body["Data"][i]["UserName"],
                  createdBy:   body["Data"][i]["Created_By"],
                  createdDateTime:   body["Data"][i]["Created_DateTime"],
                  expirationDate:   body["Data"][i]["Expiration_Date"],
                  approvedBy:   body["Data"][i]["Approved_By"],
                  approvedDateTime:   body["Data"][i]["Approved_DateTime"],
                  rejectedDateTime:   body["Data"][i]["Rejected_DateTime"],
                  suspendedDateTime:   body["Data"][i]["Suspended_DateTime"],
                  archivedDateTime:   body["Data"][i]["Archived_DateTime"],
                  visitsCount:   body["Data"][i]["Visits_Count"],
                  carId:   body["Data"][i]["Car_ID"],
                  categoryId:   body["Data"][i]["Category_ID"],
                  categoryNamePL:   body["Data"][i]["Category_Name_PL"],
                  categoryNameSL:   body["Data"][i]["Category_Name_SL"],
                  makeId:   body["Data"][i]["Make_ID"],
                  classId:   body["Data"][i]["Class_ID"],
                  modelId:   body["Data"][i]["Model_ID"],
                  carNamePL:   body["Data"][i]["Car_Name_PL"],
                  carNameSL:   body["Data"][i]["Car_Name_SL"],
                  carNameWithYearPL:   body["Data"][i]["Car_Name_With_Year_PL"],
                  carNameWithYearSL:   body["Data"][i]["Car_Name_With_Year_SL"],
                  manufactureYear:   body["Data"][i]["Manufacture_Year"],
                  plateNumber:   body["Data"][i]["Plate_Number"],
                  chassisNumber:   body["Data"][i]["Chassis_Number"],
                  technicalDescriptionPL:   body["Data"][i]["Technical_Description_PL"],
                  technicalDescriptionSL:   body["Data"][i]["Technical_Description_SL"],
                  mileage:   body["Data"][i]["Mileage"],
                  colorInterior:   body["Data"][i]["Color_Interior"],
                  interiorColorNamePL:   body["Data"][i]["Interior_Color_Name_PL"],
                  interiorColorNameSL:   body["Data"][i]["Interior_Color_Name_SL"],
                  colorExterior:   body["Data"][i]["Color_Exterior"],
                  exteriorColorNamePL:   body["Data"][i]["Exterior_Color_Name_PL"],
                  exteriorColorNameSL:   body["Data"][i]["Exterior_Color_Name_SL"],
                  isReadyForRent:   body["Data"][i]["isReady_For_Rent"],
                  internalRemarks:   body["Data"][i]["Internal_Remarks"],
                  availableForDailyRent:   body["Data"][i]["Available_For_Daily_Rent"],
                  rentPerDay:   body["Data"][i]["Rent_Per_Day"],
                  availableForWeeklyRent:   body["Data"][i]["Available_For_Weekly_Rent"],
                  rentPerWeek:   body["Data"][i]["Rent_Per_Week"],
                  availableForMonthlyRent:   body["Data"][i]["Available_For_Monthly_Rent"],
                  rentPerMonth:   body["Data"][i]["Rent_Per_Month"],
                  availableForLease:   body["Data"][i]["Available_For_Lease"],
                  ownerName:   body["Data"][i]["Owner_Name"],
                  rectangleImageUrl:   body["Data"][i]["Rectangle_Image_URL"],
                  ownerMobile:   body["Data"][i]["Owner_Mobile"]));
        }

        update();

    } else {
      print(response.statusCode);
      throw Exception("Failed to load cars: ${response.statusCode}");

    }


  }





}