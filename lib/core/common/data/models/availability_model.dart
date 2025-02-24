import 'package:intl/intl.dart';
import 'package:uni_app/core/common/domain/entities/availability.dart';

/// AvailabilityModel extends Availability and implements the serialization methods
/// to convert the model to and from Firestore documents.
class AvailabilityModel extends Availability {
  AvailabilityModel({
    required super.id,
    required super.defaultTimeSlots,
    required super.customTimeSlots,
    required super.timeSlots,
    super.availabilityWindow = 7,
  });

  /// Method to convert Firestore document to AvailabilityModel
  ///
  /// This method takes a [Map<String, dynamic>] and returns an `AvailabilityModel`
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

  /// Method to convert AvailabilityModel to Firestore document
  ///
  /// This method returns a `Map<String, dynamic>` which can be used to
  /// add/update a document in Firestore.
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

  /// Convert Availability to AvailabilityModel
  ///
  /// This method takes an [Availability] object and returns an `AvailabilityModel`
  static AvailabilityModel fromEntity(Availability availability) {
    return AvailabilityModel(
      id: availability.id,
      availabilityWindow: availability.availabilityWindow,
      defaultTimeSlots: availability.defaultTimeSlots.map(
        (key, slots) => MapEntry(
          key,
          slots.map((slot) => TimeSlotModel.fromEntity(slot)).toList(),
        ),
      ),
      customTimeSlots: availability.customTimeSlots.map(
        (key, slots) => MapEntry(
          key,
          slots.map((slot) => TimeSlotModel.fromEntity(slot)).toList(),
        ),
      ),
      timeSlots: availability.timeSlots,
    );
  }
}

/// TimeSlotModel extends TimeSlot and implements the serialization methods
/// to convert the model to and from Firestore documents.
class TimeSlotModel extends TimeSlot {
  TimeSlotModel({
    required super.startTime,
    required super.endTime,
    super.isBooked,
  });

  /// Method to convert Firestore document to TimeSlotModel
  ///
  /// This method takes a [Map<String, dynamic>] and returns a `TimeSlotModel`
  factory TimeSlotModel.fromMap(Map<String, dynamic> data) {
    return TimeSlotModel(
      startTime: DateFormat('HH:mm').parse(data['start_time'] ??
          DateTime.now().toIso8601String()), // Parse to DateTime
      endTime: DateFormat('HH:mm').parse(data['end_time'] ??
          DateTime.now().toIso8601String()), // Parse to DateTime
      isBooked: data['is_booked'] ?? false,
    );
  }

  /// Method to convert TimeSlotModel to Firestore document
  ///
  /// This method returns a `Map<String, dynamic>` which can be used to
  /// add/update a document in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'start_time': DateFormat('HH:mm').format(startTime),
      'end_time': DateFormat('HH:mm').format(endTime),
      'is_booked': isBooked,
    };
  }

  /// Convert TimeSlot to TimeSlotModel
  /// 
  /// This method takes a [TimeSlot] object and returns a `TimeSlotModel`
  static TimeSlotModel fromEntity(TimeSlot slot) {
    return TimeSlotModel(
      startTime: slot.startTime,
      endTime: slot.endTime,
      isBooked: slot.isBooked,
    );
  }
}
