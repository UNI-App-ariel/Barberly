

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:uni_app/core/common/domian/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.shopId,
    required super.userId,
    required super.customerName,
    required super.customerNumber,
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
      customerNumber: data['customer_number'] ?? '',
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
      'customer_number': customerNumber,
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
}
