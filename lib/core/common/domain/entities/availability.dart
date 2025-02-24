/// Represents the availability of a shop, including default and custom time slots.
class Availability {
  final String id; // Unique identifier for the availability
  final int
      availabilityWindow; // Number of days for which the availability is set
  final Map<int, List<TimeSlot>>
      defaultTimeSlots; // Default weekly availability (Sun-Sat)
  final Map<DateTime, List<TimeSlot>>
      customTimeSlots; // Custom date-based availability
  final Map<DateTime, List<TimeSlot>> timeSlots; // Current availability slots

  Availability({
    required this.id,
    this.availabilityWindow = 7,
    required this.defaultTimeSlots,
    required this.customTimeSlots,
    required this.timeSlots,
  });

  /// Creates an empty Availability instance with default values.
  factory Availability.empty(String id) {
    return Availability(
      id: id,
      availabilityWindow: 7,
      defaultTimeSlots: {
        1: [], // Sunday
        2: [], // Monday
        3: [], // Tuesday
        4: [], // Wednesday
        5: [], // Thursday
        6: [], // Friday
        7: [], // Saturday
      },
      customTimeSlots: {},
      timeSlots: {},
    );
  }

  /// Creates a copy of the current Availability instance with optional new values.
  Availability copyWith({
    String? id,
    int? availabilityWindow,
    Map<int, List<TimeSlot>>? defaultTimeSlots,
    Map<DateTime, List<TimeSlot>>? customTimeSlots,
    Map<DateTime, List<TimeSlot>>? timeSlots,
  }) {
    return Availability(
      id: id ?? this.id,
      availabilityWindow: availabilityWindow ?? this.availabilityWindow,
      defaultTimeSlots: defaultTimeSlots ?? this.defaultTimeSlots,
      customTimeSlots: customTimeSlots ?? this.customTimeSlots,
      timeSlots: timeSlots ?? this.timeSlots,
    );
  }
}

/// Represents a time slot for an appointment with a start and end time.
class TimeSlot {
  final DateTime startTime; // Start time of the time slot
  final DateTime endTime; // End time of the time slot
  bool isBooked; // Indicates if the time slot is booked

  TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  /// Compares this TimeSlot with another TimeSlot for sorting purposes.
  int compareTo(TimeSlot b) {
    if (startTime.hour < b.startTime.hour) {
      return -1; // This TimeSlot is earlier
    } else if (startTime.hour > b.startTime.hour) {
      return 1; // This TimeSlot is later
    } else {
      // Compare minutes if hours are the same
      if (startTime.minute < b.startTime.minute) {
        return -1; // This TimeSlot is earlier
      } else if (startTime.minute > b.startTime.minute) {
        return 1; // This TimeSlot is later
      } else {
        return 0; // They are equal
      }
    }
  }

  // Override toString for better debugging output
  @override
  String toString() {
    return 'TimeSlot($startTime - $endTime, isBooked: $isBooked)';
  }
}
