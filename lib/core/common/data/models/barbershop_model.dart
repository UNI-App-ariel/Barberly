import 'package:uni_app/core/common/domian/entities/barbershop.dart';

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
  });

  // from map
  factory BarbershopModel.fromMap(Map<String, dynamic> map) {
    return BarbershopModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      rating: map['rating'],
      reviewCount: map['reviewCount'],
      services: List<String>.from(map['services']),
      barbers: List<String>.from(map['barbers']),
      gallery: List<String>.from(map['gallery'] ?? []),
      ownerId: map['ownerId'],
    );
  }

  // to map
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
    };
  }

  // from entity
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
    );
  }

  // to entity
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
    );
  }
}
