// repositories/car_repository.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../controller/const/base_url.dart';
import '../../model/car_brand.dart';
import '../../model/class_model.dart';
import '../../model/car_model_class.dart';
import '../../model/create_ad_model.dart';

String ourSecret='1244';
String userName= 'Asmaa2';
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
  }) async
  {
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
      'partnerID':''

    };
  log(requestBody.toString());
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
        'ID': parsedJson['Created_ID'],
      };
    } catch (e) {
      return {
        'Code': 'Error',
        'Desc': 'Failed to parse response: ${e.toString()}',
      };
    }
  }

  /// Upload cover photo for a post
  Future<Map<String, dynamic>> uploadCoverPhoto({
    required String postId,
    required String ourSecret,
    required String imagePath,
  }) async
  {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/UploadPostCoverPhoto',
    );

    try {
      // Read the image file
      final file = File(imagePath);
      if (!await file.exists()) {
        return {
          'Code': 'Error',
          'Desc': 'Image file not found',
        };
      }

      // Create multipart request
      final request = http.MultipartRequest('POST', url);
      
      // Add form fields
      request.fields['Post_ID'] = postId;
      request.fields['Our_Secret'] = ourSecret;
      
      // Add image file
      final imageFile = await http.MultipartFile.fromPath(
        'PhotoBytes',
        imagePath,
        filename: 'cover.jpg',
      );
      request.files.add(imageFile);

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Parse XML response
        return _parseUploadResponse(responseBody);
      } else {
        return {
          'Code': 'Error',
          'Desc': 'Failed to upload cover photo. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'Code': 'Error',
        'Desc': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Parse JSON response from upload endpoint
  Map<String, dynamic> _parseUploadResponse(String jsonString) {
    try {
      final parsedJson = jsonDecode(jsonString);
      
      return {
        'Code': parsedJson['Code'] ?? 'Error',
        'Desc': parsedJson['Desc'] ?? 'Upload failed',
      };
    } catch (e) {
      return {
        'Code': 'Error',
        'Desc': 'Failed to parse upload response: ${e.toString()}',
      };
    }
  }

}
