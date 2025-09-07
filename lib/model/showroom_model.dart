class Showroom {
  final int id;
  final String name;
  final String logoUrl;
  final int carsCount;
  final int views;
  final String rating;
  final bool isFeatured;

  Showroom({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.carsCount,
    required this.views,
    required this.rating,
    this.isFeatured = false,
  });
}