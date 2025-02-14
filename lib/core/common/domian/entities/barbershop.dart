// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class Barbershop {
  final String id;
  final String name;
  final String? address;
  final String phoneNumber;
  final String? imageUrl;
  final List<String> gallery;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final List<String> barbers;

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
  });

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
    );
  }
}
