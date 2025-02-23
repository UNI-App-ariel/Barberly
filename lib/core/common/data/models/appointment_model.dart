import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:uni_app/core/common/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.shopId,
    required super.userId,
    required super.customerName,
    required super.customerEmail,
    required super.customerImageURL,
    required super.serviceId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.createdAt,
  });

  // Factory method to convert Firestore document to AppointmentModel
  factory AppointmentModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      shopId: data['shop_id'] ?? '',
      userId: data['user_id'] ?? '',
      customerName: data['customer_name'] ?? '',
      customerEmail: data['customer_Email'] ?? '',
      customerImageURL: data['customer_image_url'],
      serviceId: data['service_id'] ?? '',
      date: (data['date'] != null)
          ? (data['date'] as Timestamp)
              .toDate() // Convert Firestore Timestamp to DateTime
          : DateTime.now(),
      startTime: DateFormat('HH:mm').parse(data['start_time']),
      endTime: DateFormat('HH:mm').parse(data['end_time']),
      status: data['status'] ?? '',
      createdAt: (data['created_at'] != null)
          ? (data['created_at'] as Timestamp)
              .toDate() // Convert Firestore Timestamp to DateTime
          : DateTime.now(),
    );
  }

  // Method to convert AppointmentModel to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId,
      'user_id': userId,
      'customer_name': customerName,
      'customer_Email': customerEmail,
      'customer_image_url': customerImageURL,
      'service_id': serviceId,
      'date':
          // Timestamp.fromDate(DateTime(date.year, date.month, date.day, 0, 0)),
          Timestamp.fromDate(date),
      'start_time': DateFormat('HH:mm').format(startTime),
      'end_time': DateFormat('HH:mm').format(endTime),
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  // Method to convert AppointmentModel to Appointment
  Appointment toEntity() {
    return Appointment(
      id: id,
      shopId: shopId,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerImageURL: customerImageURL,
      serviceId: serviceId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      status: status,
      createdAt: createdAt,
    );
  }

  // Method to convert Appointment to AppointmentModel
  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      shopId: appointment.shopId,
      userId: appointment.userId,
      customerName: appointment.customerName,
      customerEmail: appointment.customerEmail,
      customerImageURL: appointment.customerImageURL,
      serviceId: appointment.serviceId,
      date: appointment.date,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      status: appointment.status,
      createdAt: appointment.createdAt,
    );
  }
}
