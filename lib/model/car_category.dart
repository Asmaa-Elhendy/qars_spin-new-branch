class CarCategory {
  final String id;
  final String name;

  CarCategory({
    required this.id,
    required this.name,
  });

  factory CarCategory.fromJson(Map<String, dynamic> json) {
    return CarCategory(
      id: json['Category_ID']?.toString() ?? '',
      name: json['Category_Name_PL'] ?? '',
    );
  }

  @override
  String toString() {
    return name;
  }
}
