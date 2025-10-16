// lib/controller/auth/auth_data_layer.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:qarsspin/controller/const/base_url.dart';

class AuthDataLayer {
  static const String _requestOtpEndpoint = '/UserRelatedApi.asmx/RequestOTP';

  Future<Map<String, dynamic>> requestOtp({
    required String userName,
    required String otpSecret,
    required String ourSecret,
  }) async {
    try {
      final url = Uri.parse('$base_url$_requestOtpEndpoint');
      
      log('🔐 Requesting OTP for: $userName');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'UserName': userName,
          'OTP_Secret': otpSecret,
          'Our_Secret': ourSecret,
        },
      );

      log('📩 OTP Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          return {
            'success': jsonResponse['Code'] == 'OK',
            'message': jsonResponse['Desc'] ?? 'OTP request processed',
            'data': jsonResponse,
          };
        } catch (e) {
          log('❌ Error parsing OTP response: $e');
          return {
            'success': false,
            'message': 'Failed to process OTP response',
            'error': e.toString(),
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e, stackTrace) {
      log('❌ Error in requestOtp: $e\n$stackTrace');
      return {
        'success': false,
        'message': 'Network error: $e',
        'error': e.toString(),
      };
    }
  }
}