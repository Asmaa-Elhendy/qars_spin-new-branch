class Specs {
  final String postId;
  final String specId;
  final String specType;
  final String specHeaderPl;
  final String specValuePl;
  final String specHeaderSl;
  final String specValueSl;
  final bool isHidden;

  Specs({
    required this.postId,
    required this.specId,
    required this.specType,
    required this.specHeaderPl,
    required this.specValuePl,
    required this.specHeaderSl,
    required this.specValueSl,
    required this.isHidden,
  });

  factory Specs.fromJson(Map<String, dynamic> json) {
    return Specs(
      postId: json['Post_ID'] ?? '',
      specId: json['Spec_ID'] ?? '',
      specType: json['Spec_Type'] ?? '',
      specHeaderPl: json['Spec_Header_PL'] ?? '',
      specValuePl: json['Spec_Value_PL'] ?? '',
      specHeaderSl: json['Spec_Header_SL'] ?? '',
      specValueSl: json['Spec_Value_SL'] ?? '',
      isHidden: json['isHidden'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Post_ID': postId,
      'Spec_ID': specId,
      'Spec_Type': specType,
      'Spec_Header_PL': specHeaderPl,
      'Spec_Value_PL': specValuePl,
      'Spec_Header_SL': specHeaderSl,
      'Spec_Value_SL': specValueSl,
      'isHidden': isHidden ? '1' : '0',
    };
  }
}