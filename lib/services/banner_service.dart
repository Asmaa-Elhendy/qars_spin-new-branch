import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:qarsspin/controller/const/base_url.dart';
import '../controller/ads/data_layer.dart';
import '../model/banner_model.dart';

class BannerService {
  static const String endpoint = '/BannersRelatedAPI.asmx/GetListOfActiveBanners';
  static const String impressionEndpoint = '/BannersRelatedAPI.asmx/InsertAdBannerImpression';

  Future<void> trackBannerImpression(int bannerId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get user ID (username or "0" for guests)
      final userId = prefs.getString('username')??'';

      // Get current language (default to 'en' if not set)
      final userLanguage ='en';

      // Prepare request body
      final requestBody = {
        'Banner_ID': bannerId.toString(),
        'User_ID': userId,
        'User_Language': userLanguage,
        'Impression_Source': 'Android',
        'Our_Secret': ourSecret,
      };

      final url = Uri.parse('$base_url$impressionEndpoint');

      log('🔵 ==== BANNER IMPRESSION TRACKING STARTED ====');
      log('🔗 URL: $url');
      log('📝 Request body: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );

      log('✅ Banner impression tracked - Status: ${response.statusCode}');
    } catch (e) {
      log('❌ Error tracking banner impression: $e');
    }
  }

  Future<void> trackBannerClick(int bannerId) async {
    final url = Uri.parse('$base_url/BannersRelatedAPI.asmx/InsertAdBannerClick');

    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('username') ?? '';

      final body = {
        'Banner_ID': bannerId.toString(), // must match exactly
        'User_ID': userId,
        'Click_Source': 'Android',
        'User_Language': 'en',
        'Our_Secret': ourSecret, // include if required for auth
      };


      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        log('Response body: ${response.body}');
      } else {
        log('⚠️ Failed to register click: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Error during banner click registration: $e');
    }
  }

  Future<List<BannerModel>> getActiveBanners() async {
    final url = Uri.parse('$base_url$endpoint');
    final String clientDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

    // Prepare the request body
    final requestBody = {
      'Client_Date':clientDate //'01-25-2025',
    };

    log('🔵 ==== BANNER FETCH STARTED ====');//k
    log('🔗 URL: $url');
    log('📝 Request body: $requestBody');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      log('\n📥 Response received');
      log('Status: ${response.statusCode}');
      log('Headers: ${response.headers}');

      // Log response body (first 500 chars)
      final responsePreview = response.body.length > 500
          ? '${response.body.substring(0, 500)}...'
          : response.body;
      log('Response (first 500 chars):\n$responsePreview');

      if (response.statusCode == 200) {
        try {
          // Parse the response
          final dynamic jsonResponse = json.decode(response.body);
          log('\n🔍 Parsed JSON type: ${jsonResponse.runtimeType}');

          final bannerResponse = BannerResponse.fromJson(jsonResponse);

          log('\n📊 Parsed response:');
          log('Code: ${bannerResponse.code}');
          log('Description: ${bannerResponse.desc}');
          log('Count: ${bannerResponse.count}');
          log('Banners found: ${bannerResponse.data.length}');

          if (bannerResponse.code == 'OK' || bannerResponse.code == '200') {
            if (bannerResponse.data.isNotEmpty) {
              log('✅ Success! Found ${bannerResponse.data.length} banners');
              // Log first banner details for verification
              if (bannerResponse.data.isNotEmpty) {
                final firstBanner = bannerResponse.data.first;
                log('\n📌 First banner details:');
                log('ID: ${firstBanner.bannerId}');
                log('Type: ${firstBanner.bannerType}');
                log('Target: ${firstBanner.targetType}');
                log('Image URL (PL): ${firstBanner.imageUrlPl}');
              }
              return bannerResponse.data;
            } else {
              log('⚠️  No banners found in response');
            }
          } else {
            log('❌ API Error:');
            log('   Code: ${bannerResponse.code}');
            log('   Desc: ${bannerResponse.desc}');
          }
        } catch (e, stackTrace) {
          log('❌ Error parsing response:');
          log('   Error: $e');
          log('   Stack trace: $stackTrace');
          log('   Response body: ${response.body}');
        }
      } else {
        log('❌ HTTP Error:');
        log('   Status: ${response.statusCode}');
        log('   Body: ${response.body}');
      }
    } catch (e, stackTrace) {
      log('❌ Network error:');
      log('   Error: $e');
      log('   Stack trace: $stackTrace');
    }

    log('\n🔴 Returning empty banner list');
    return [];
  }

  BannerModel? getBannerByPriority(List<BannerModel> banners, String page, String type) {
    if (banners.isEmpty) return null;

    // Convert input parameters to lowercase for case-insensitive comparison
    final lowerType = type.toLowerCase();
    final lowerPage = page.toLowerCase();

    final priorityOrder = [
      {'type': lowerType, 'target': lowerPage},
      {'type': lowerType, 'target': 'global'},
      {'type': '${lowerType}filler', 'target': lowerPage},
      {'type': '${lowerType}filler', 'target': 'global'},
    ];

    log('🔍 Looking for banner with type: $type and page: $page (case-insensitive)');

    for (var priority in priorityOrder) {
      final matches = banners.where((b) {
        // Convert both banner properties and priority values to lowercase for case-insensitive comparison
        final bannerType = b.bannerType?.toLowerCase() ?? '';
        final bannerTarget = b.targetType?.toLowerCase() ?? '';
        final priorityType = (priority['type'] as String?)?.toLowerCase() ?? '';
        final priorityTarget = (priority['target'] as String?)?.toLowerCase() ?? '';
        
        // Compare both type and target in a case-insensitive way
        return bannerType == priorityType && 
               bannerTarget.contains(priorityTarget);
      }).toList();

      if (matches.isNotEmpty) {
        log('🎯 Found ${matches.length} matches for ${priority['type']} - ${priority['target']}');
        matches.shuffle();
        final selected = matches.first;
        log('🖼️ Selected banner ID: ${selected.bannerId}');
        return selected;
      } else {
        log('ℹ️ No match for ${priority['type']} - ${priority['target']}');
      }
    }

    log('⚠️ No banner found matching criteria');
    return null;
  }
}