import 'package:uni_app/core/common/domain/entities/barbershop.dart';

/// Appointment represents a booking for a service at a barbershop.
///
/// It contains all the necessary information about the appointment,
/// including the associated barbershop, customer details, and timing.
class Appointment {
  final String id; // Unique identifier for the appointment
  final String shopId; // Identifier for the associated barbershop
  final String userId; // Identifier for the user who booked the appointment
  final String customerName; // Name of the customer
  final String customerEmail; // Email of the customer
  final String? customerImageURL; // Optional image URL of the customer
  final String serviceId; // Identifier for the service being booked
  final DateTime date; // Date of the appointment
  final DateTime startTime; // Start time of the appointment
  final DateTime endTime; // End time of the appointment
  final String status; // Status of the appointment (e.g., confirmed, cancelled)
  final DateTime createdAt; // Timestamp of when the appointment was created
  final Barbershop? shop; // Optional associated barbershop information

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

  /// Creates a copy of the current Appointment instance with optional new values.
  ///
  /// This is useful for updating specific fields without modifying the original instance.
  ///
  /// Parameters:
  /// - [id]: New id value
  /// - [shopId]: New shopId value
  /// - [userId]: New userId value
  /// - [customerName]: New customerName value
  /// - [customerEmail]: New customerEmail value
  /// - [customerImageURL]: New customerImageURL value
  /// - [serviceId]: New serviceId value
  /// - [date]: New date value
  /// - [startTime]: New startTime value
  /// - [endTime]: New endTime value
  /// - [status]: New status value
  /// - [createdAt]: New createdAt value
  /// - [shop]: New shop value
  ///
  /// Returns:
  /// - A new Appointment instance with updated values.
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
