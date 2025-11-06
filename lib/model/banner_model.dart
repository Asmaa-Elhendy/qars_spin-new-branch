import 'dart:convert';

class BannerModel {
  final int bannerId;
  final String bannerType;
  final String targetType;
  final String imageUrlPl;
  final String imageUrlSl;
  final String targetUrlPl;
  final String targetUrlSl;

  BannerModel({
    required this.bannerId,
    required this.bannerType,
    required this.targetType,
    required this.imageUrlPl,
    required this.imageUrlSl,
    required this.targetUrlPl,
    required this.targetUrlSl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['Banner_ID'] ?? 0,
      bannerType: json['Banner_Type'] ?? '',
      targetType: json['Target_Type'] ?? '',
      imageUrlPl: json['Image_URL_PL'] ?? '',
      imageUrlSl: json['Image_URL_SL'] ?? '',
      targetUrlPl: json['Target_URL_PL'] ?? '',
      targetUrlSl: json['Target_URL_SL'] ?? '',
    );
  }
}

class BannerResponse {
  final String code;
  final String desc;
  final int count;
  final List<BannerModel> data;

  BannerResponse({
    required this.code,
    required this.desc,
    required this.count,
    required this.data,
  });

  factory BannerResponse.fromJson(dynamic json) {
    try {
      // If json is already a Map, use it directly
      if (json is Map<String, dynamic>) {
        return _parseBannerData(json);
      }
      // If json is a String, decode it first
      else if (json is String) {
        final decoded = jsonDecode(json);
        if (decoded is Map<String, dynamic>) {
          return _parseBannerData(decoded);
        }
      }

      throw FormatException('Invalid JSON format');
    } catch (e) {
      print('❌ Error parsing BannerResponse: $e');
      print('JSON: $json');
      return BannerResponse(
        code: 'ERROR',
        desc: 'Failed to parse response: ${e.toString()}',
        count: 0,
        data: [],
      );
    }
  }

  static BannerResponse _parseBannerData(Map<String, dynamic> data) {
    List<dynamic> dataList = [];
    if (data['Data'] is List) {
      dataList = data['Data'];
    } else if (data['data'] is List) {
      dataList = data['data']; // Handle case-insensitive key
    }

    return BannerResponse(
      code: (data['Code'] ?? data['code'] ?? '').toString(),
      desc: (data['Desc'] ?? data['desc'] ?? '').toString(),
      count: data['Count'] is int
          ? data['Count'] as int
          : data['count'] is int
          ? data['count'] as int
          : int.tryParse((data['Count'] ?? data['count'] ?? '0').toString()) ?? 0,
      data: dataList
          .where((e) => e is Map<String, dynamic>)
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}