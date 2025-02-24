import 'package:uni_app/core/common/domain/entities/barbershop.dart';

/// BarbershopModel extends Barbershop and implements the serialization methods
/// to convert the model to and from Firestore documents.
final class BarbershopModel extends Barbershop {
  BarbershopModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phoneNumber,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.services,
    required super.barbers,
    required super.gallery,
    required super.ownerId,
    required super.isActive,
  });

  /// Method to convert Firestore document to BarbershopModel
  /// 
  /// This method takes a [Map<String, dynamic>] and returns a `BarbershopModel`
  factory BarbershopModel.fromMap(Map<String, dynamic> map) {
    return BarbershopModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      rating: map['rating'] is int ? (map['rating'] as int).toDouble() : map['rating'],
      reviewCount: map['reviewCount'],
      services: List<String>.from(map['services']),
      barbers: List<String>.from(map['barbers']),
      gallery: List<String>.from(map['gallery'] ?? []),
      ownerId: map['ownerId'],
      isActive: map['isActive'] ?? true,
    );
  }

  /// Method to convert BarbershopModel to Firestore document
  /// 
  /// This method returns a [Map<String, dynamic>] from a `BarbershopModel`
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'services': services,
      'barbers': barbers,
      'gallery': gallery,
      'ownerId': ownerId,
      'isActive': isActive,
    };
  }

  /// Convert Barbershop to BarbershopModel
  /// 
  /// This method takes a [Barbershop] object and returns a `BarbershopModel`
  factory BarbershopModel.fromEntity(Barbershop entity) {
    return BarbershopModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      services: entity.services,
      barbers: entity.barbers,
      gallery: entity.gallery,
      ownerId: entity.ownerId,
      isActive: entity.isActive,
    );
  }

  /// Convert BarbershopModel to Barbershop
  /// 
  /// This method returns a [Barbershop] object from a `BarbershopModel`
  Barbershop toEntity() {
    return Barbershop(
      id: id,
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      services: services,
      barbers: barbers,
      gallery: gallery,
      ownerId: ownerId,
      isActive: isActive,
    );
  }
}
