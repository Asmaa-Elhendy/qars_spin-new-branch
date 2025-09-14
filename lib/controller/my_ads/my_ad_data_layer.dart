import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../controller/const/base_url.dart';

class MyAdDataLayer {
  /// Get list of posts by user name
  Future<Map<String, dynamic>> getListOfPostsByUserName({
    required String userName,
    required String ourSecret,
  }) async {
    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfPostsByUserName',
    );

    // Prepare the request body
    final requestBody = {
      'UserName': userName,
      'Our_Secret': ourSecret,
    };

    log('Getting posts for user: $userName');
    log('Request body: $requestBody');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse JSON response
        return _parseJsonResponse(response.body);
      } else {
        return {
          'Code': 'Error',
          'Desc': 'Failed to get posts. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      log('Error getting posts: $e');
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
        'Data': parsedJson['Data'] ?? [],
      };
    } catch (e) {
      log('Error parsing JSON response: $e');
      return {
        'Code': 'Error',
        'Desc': 'Failed to parse response: ${e.toString()}',
        'Data': [],
      };
    }
  }
}