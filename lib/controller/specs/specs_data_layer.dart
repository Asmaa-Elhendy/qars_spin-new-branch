import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../controller/const/base_url.dart';
import '../../model/specs.dart';
import '../ads/data_layer.dart';

class SpecsDataLayer {
  /// Get specs of a post for editing
  Future<Map<String, dynamic>> getSpecsOfPostForEditing({
    required String postId,
    required String showHidden,
  }) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetSpecsOfPostForEditing',
    );//

    log('Fetching specs for post ID: $postId, showHidden: $showHidden');
    log('API URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'Post_ID': postId,
          'Show_Hidden': showHidden,
        },
      );

      log('API Response status: ${response.statusCode}');
      log('API Response body: ${response.body}');

      if (response.statusCode == 200) {
        return _parseJsonResponse(response.body);
      } else {
        return {
          'Code': 'Error',
          'Desc': 'Failed to fetch specs. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      log('❌ Error fetching specs: $e');
      return {
        'Code': 'Error',
        'Desc': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Update spec value
  Future<Map<String, dynamic>> updateSpecValue({
    required String postId,
    required String selectedLanguage,
    required String specId,
    required String specValue,
  }) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/UpdateSpecValue',
    );

    log('Updating spec value - Post ID: $postId, Spec ID: $specId, Value: $specValue, Language: $selectedLanguage');
    log('API URL: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'Post_ID': postId,
          'Selected_Language': selectedLanguage,
          'Spec_ID': specId,
          'Spec_Value': specValue,
          'Our_Secret': ourSecret,
        },
      );

      log('API Response status: ${response.statusCode}');
      log('API Response body: ${response.body}');

      if (response.statusCode == 200) {
        return _parseJsonResponse(response.body);
      } else {
        return {
          'Code': 'Error',
          'Desc': 'Failed to update spec value. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      log('❌ Error updating spec value: $e');
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
      log('Parsed JSON: $parsedJson');

      return {
        'Code': parsedJson['Code'] ?? 'Error',
        'Desc': parsedJson['Desc'] ?? 'Unknown error',
        'Count': parsedJson['Count'] ?? 0,
        'Data': parsedJson['Data'] ?? <dynamic>[],
      };
    } catch (e) {
      log('❌ Error parsing response: $e');
      return {
        'Code': 'Error',
        'Desc': 'Failed to parse response: ${e.toString()}',
        'Data': <dynamic>[],
      };
    }
  }
}