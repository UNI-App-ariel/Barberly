/// Represents a barbershop with its details and associated services.
class Barbershop {
  final String id; // Unique identifier for the barbershop
  final String name; // Name of the barbershop
  final String? address; // Address of the barbershop (optional)
  final String phoneNumber; // Contact phone number of the barbershop
  final String? imageUrl; // URL for the barbershop's image (optional)
  final List<String> gallery; // List of image URLs for the gallery
  final double rating; // Rating of the barbershop
  final int reviewCount; // Number of reviews received by the barbershop
  final List<String> services; // List of services offered by the barbershop
  final List<String> barbers; // List of barbers working at the barbershop
  final String ownerId; // ID of the owner of the barbershop
  final bool isActive; // Status indicating if the barbershop is active

  /// Creates a new [Barbershop] instance.
  Barbershop({
    required this.id,
    required this.name,
    this.address,
    required this.phoneNumber,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.services,
    required this.barbers,
    this.gallery = const [],
    required this.ownerId,
    this.isActive = true,
  });

  /// Creates a copy of the current [Barbershop] instance with optional new values.
  ///
  /// The [resetImageUrl] flag determines whether to reset the image URL to null.
  Barbershop copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? imageUrl,
    List<String>? gallery,
    bool resetImageUrl = false,
    double? rating,
    int? reviewCount,
    List<String>? services,
    List<String>? barbers,
    String? ownerId,
    bool? isActive,
  }) {
    return Barbershop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: resetImageUrl ? null : imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      services: services ?? this.services,
      barbers: barbers ?? this.barbers,
      gallery: gallery ?? this.gallery,
      ownerId: ownerId ?? this.ownerId,
      isActive: isActive ?? this.isActive,
    );
  }
}