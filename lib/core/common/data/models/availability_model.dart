import 'package:intl/intl.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';

class AvailabilityModel extends Availability {
  AvailabilityModel({
    required super.id,
    required super.defaultTimeSlots,
    required super.customTimeSlots,
    required super.timeSlots,
    super.availabilityWindow = 7,
  });

  // Factory to create AvailabilityModel from Firestore document
  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      id: map['id'] ?? '', // Default empty string if 'id' is null
      availabilityWindow:
          map['availability_window'] ?? 7, // Default value if not present

      // Safely handle 'default_availability' by checking null and type
      defaultTimeSlots: (map['default_availability'] != null &&
              map['default_availability'] is Map<String, dynamic> &&
              (map['default_availability'] as Map<String, dynamic>)
                  .isNotEmpty &&
              (map['default_availability'] as Map<String, dynamic>).values.any(
                  (value) =>
                      value is List &&
                      value
                          .isNotEmpty)) // Check if any value in the map is a non-empty List
          ? (map['default_availability'] as Map<String, dynamic>).map(
              (key, value) {
                return MapEntry(
                  int.parse(key), // Weekdays (1 for Sunday, 7 for Saturday)
                  (value as List<dynamic>)
                      .map((slot) => TimeSlotModel.fromMap(slot))
                      .toList(),
                );
              },
            )
          : {for (int i = 1; i <= 7; i++) i: []},

      // Safely handle 'custom_availability' by checking null and type
      customTimeSlots: (map['custom_availability'] != null &&
              map['custom_availability'] is Map<String, dynamic> &&
              (map['custom_availability'] as Map<String, dynamic>).isNotEmpty &&
              (map['custom_availability'] as Map<String, dynamic>).values.any(
                  (value) =>
                      value is List &&
                      value
                          .isNotEmpty)) // Check if any value in the map is a non-empty List
          ? (map['custom_availability'] as Map<String, dynamic>).map(
              (key, value) {
                return MapEntry(
                  DateFormat('dd-MM-yyyy').parse(key),
                  (value as List<dynamic>).map((slot) {
                    return TimeSlotModel.fromMap(slot);
                  }).toList(),
                );
              },
            )
          : {}, // Default to empty map if not present

      // Empty map for timeSlots (will be populated after merging)
      timeSlots: {},
    );
  }

  // Convert AvailabilityModel to Map for Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'availability_window': availabilityWindow,
      'default_availability': defaultTimeSlots.map(
        (key, value) => MapEntry(
          key.toString(),
          value
              .map((slot) =>
                  (slot as TimeSlotModel).toMap()) // Serialize time slots
              .toList(),
        ),
      ),
      'custom_availability': customTimeSlots.map(
        (key, value) => MapEntry(
          DateFormat('dd-MM-yyyy').format(key),
          value
              .map((slot) =>
                  (slot as TimeSlotModel).toMap()) // Serialize time slots
              .toList(),
        ),
      ),
    };
  }

  // Convert Availability to AvailabilityModel
  static AvailabilityModel fromDomain(Availability availability) {
    return AvailabilityModel(
      id: availability.id,
      availabilityWindow: availability.availabilityWindow,
      defaultTimeSlots: availability.defaultTimeSlots.map(
        (key, slots) => MapEntry(
          key,
          slots.map((slot) => TimeSlotModel.fromDomain(slot)).toList(),
        ),
      ),
      customTimeSlots: availability.customTimeSlots.map(
        (key, slots) => MapEntry(
          key,
          slots.map((slot) => TimeSlotModel.fromDomain(slot)).toList(),
        ),
      ),
      timeSlots: availability.timeSlots,
    );
  }
}

class TimeSlotModel extends TimeSlot {
  TimeSlotModel({
    required super.startTime,
    required super.endTime,
    super.isBooked,
  });

  // Factory to create a TimeSlotModel from a map
  factory TimeSlotModel.fromMap(Map<String, dynamic> data) {
    return TimeSlotModel(
      startTime: DateFormat('HH:mm').parse(data['start_time'] ??
          DateTime.now().toIso8601String()), // Parse to DateTime
      endTime: DateFormat('HH:mm').parse(data['end_time'] ??
          DateTime.now().toIso8601String()), // Parse to DateTime
      isBooked: data['is_booked'] ?? false,
    );
  }

  // Converts the TimeSlotModel to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'start_time': DateFormat('HH:mm').format(startTime),
      'end_time': DateFormat('HH:mm').format(endTime),
      'is_booked': isBooked,
    };
  }

  // Convert TimeSlot to TimeSlotModel
  static TimeSlotModel fromDomain(TimeSlot slot) {
    return TimeSlotModel(
      startTime: slot.startTime,
      endTime: slot.endTime,
      isBooked: slot.isBooked,
    );
  }
}