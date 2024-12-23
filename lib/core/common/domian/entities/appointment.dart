import 'package:uni_app/core/common/domian/entities/barbershop.dart';

class Appointment {
  final String id;
  final String shopId;
  final String userId;
  final String customerName;
  final String customerEmail;
  final String? customerImageURL;
  final String serviceId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;
  final Barbershop? shop;

  const Appointment({
    required this.id,
    required this.shopId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerImageURL,
    required this.serviceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    this.shop,
  });

  // copyWith method
  Appointment copyWith({
    String? id,
    String? shopId,
    String? userId,
    String? customerName,
    String? customerEmail,
    String? customerImageURL,
    String? serviceId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    DateTime? createdAt,
    Barbershop? shop,
  }) {
    return Appointment(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerImageURL: customerImageURL ?? this.customerImageURL,
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      shop: shop ?? this.shop,
    );
  }
}
