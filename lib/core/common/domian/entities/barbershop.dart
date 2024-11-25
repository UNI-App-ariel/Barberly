class Barbershop {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final List<String> barbers;

  Barbershop({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.services,
    required this.barbers,
  });
}