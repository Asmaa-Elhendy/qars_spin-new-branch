class Showroom {
  final String name;
  final String logoUrl;
  final int carsCount;
  final int views;
  final double rating;
  final bool isFeatured;

  Showroom({
    required this.name,
    required this.logoUrl,
    required this.carsCount,
    required this.views,
    required this.rating,
    this.isFeatured = false,
  });
}