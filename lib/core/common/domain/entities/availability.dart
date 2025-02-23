
class Availability {
  final String id;
  final int availabilityWindow;
  final Map<int, List<TimeSlot>>
      defaultTimeSlots; // For default weekly availability (Sun-Sat)
  final Map<DateTime, List<TimeSlot>>
      customTimeSlots; // For custom date-based availability
  final Map<DateTime, List<TimeSlot>> timeSlots; 


  Availability({
    required this.id,
    this.availabilityWindow = 7,
    required this.defaultTimeSlots,
    required this.customTimeSlots,
    required this.timeSlots,
  });

  // Empty constructor
  factory Availability.empty(String id) {
    return Availability(
      id: id,
      availabilityWindow: 7,
      defaultTimeSlots: {
        1: [],
        2: [],
        3: [],
        4: [],
        5: [],
        6: [],
        7: [],
      },
      customTimeSlots: {},
      timeSlots: {},
    );
  }

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

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  bool isBooked;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });


  int compareTo(TimeSlot b) {
    if (startTime.hour < b.startTime.hour) {
      return -1;
    } else if (startTime.hour > b.startTime.hour) {
      return 1;
    } else {
      if (startTime.minute < b.startTime.minute) {
        return -1;
      } else if (startTime.minute > b.startTime.minute) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  // override toString
  @override
  String toString() {
    return 'TimeSlot($startTime)';
  }
}