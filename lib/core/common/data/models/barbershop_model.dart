import 'dart:io';

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
    super.imgaeFile,
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
    );
  }

  

}
