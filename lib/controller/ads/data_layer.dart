// repositories/car_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../controller/const/base_url.dart';
import '../../model/car_brand.dart';
import '../../model/class_model.dart';
import '../../model/car_model_class.dart';
import '../../model/create_ad_model.dart';


class AdRepository {
  Future<List<CarBrand>> fetchCarMakes() async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarMakes?Order_By=MakeName',
    );

    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final List<dynamic> data = parsedJson['Data'];
      return data.map((item) {
        return CarBrand(
          id: item["Make_ID"],
          make_count: item["Make_Count"],
          name: item["Make_Name_PL"],
          imageUrl: item["Image_URL"] ?? "",
        );
      }).toList();
    } else {
      throw Exception("Failed to load car makes");
    }
  }

  /// جلب الكلاسات

  Future<List<CarClass>> fetchCarClasses(String makeId) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarClasses?Make_ID=$makeId',
    );

    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final List<dynamic> data = parsedJson['Data'];
      return data.map((item) {
        return CarClass(
          id: item["Class_ID"],
          name: item["Class_Name_PL"],
        );
      }).toList();
    } else {
      throw Exception("Failed to load car classes");
    }
  }

  /// جلب الموديلات
  Future<List<CarModelClass>> fetchCarModels(String classId) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarModels?Class_ID=$classId',
    );

    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final List<dynamic> data = parsedJson['Data'];
      return data.map((item) {
        return CarModelClass(
          id: item["Model_ID"],
          name: item["Model_Name_PL"],
        );
      }).toList();
    } else {
      throw Exception("Failed to load car models");
    }
  }

  /// إنشاء إعلان سيارة جديدة للبيع
  Future<Map<String, dynamic>> createCarAd({
    required CreateAdModel adModel,
  }) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/InsertCarForSalePost',
    );

    // Create JSON payload
    String postDetails = jsonEncode(adModel.toApiPayload());

    // Prepare the request body
    final requestBody = {
      'Post_Details': postDetails,
      'UserName': adModel.userName,
      'Our_Secret': adModel.ourSecret,
      'Selected_Language': adModel.selectedLanguage,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        return _parseJsonResponse(response.body);
      } else {
        return {
          'Code': 'Error',
          'Desc': 'Failed to create ad. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'Code': 'Error',
        'Desc': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Parse JSON response from API
  Map<String, dynamic> _parseJsonResponse(String jsonString) {
    try {
      final parsedJson = jsonDecode(jsonString);
      
      return {
        'Code': parsedJson['Code'] ?? 'Error',
        'Desc': parsedJson['Desc'] ?? 'Unknown error',
        'ID': parsedJson['ID'],
      };
    } catch (e) {
      return {
        'Code': 'Error',
        'Desc': 'Failed to parse response: ${e.toString()}',
      };
    }
  }
}
