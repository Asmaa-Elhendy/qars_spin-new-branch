import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../controller/const/base_url.dart';
import '../../model/specs.dart';

class SpecsDataLayer {
  /// Get specs of a post for editing
  Future<Map<String, dynamic>> getSpecsOfPostForEditing({
    required String postId,
    required String showHidden,
  }) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetSpecsOfPostForEditing',
    );

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

  /// Parse JSON response from API
  Map<String, dynamic> _parseJsonResponse(String jsonString) {
    try {
      final parsedJson = jsonDecode(jsonString);
      log('Parsed JSON: $parsedJson');

      return {
        'Code': parsedJson['Response']['Code'] ?? 'Error',
        'Desc': parsedJson['Response']['Desc'] ?? 'Unknown error',
        'Count': parsedJson['Response']['Count'] ?? 0,
        'Spec': parsedJson['Response']['Spec'] ?? [],
      };
    } catch (e) {
      log('❌ Error parsing response: $e');
      return {
        'Code': 'Error',
        'Desc': 'Failed to parse response: ${e.toString()}',
      };
    }
  }
}