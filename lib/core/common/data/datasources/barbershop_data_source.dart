import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_app/core/common/data/models/appointment_model.dart';
import 'package:uni_app/core/common/data/models/availability_model.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';

/// Abstract class for BarbershopDataSource
/// This class defines the methods that will be used to interact with the data source
abstract interface class BarbershopDataSource {
  /// Method to get all barbershops
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while fetching barbershops
  ///
  /// Returns:
  /// - a `Future<List<BarbershopModel>>`
  Future<List<BarbershopModel>> getBarbershops();

  /// Method to get a barbershop by its `id`
  ///
  /// Parameters:
  /// - [id]: the `id` of the barbershop to be fetched
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while fetching the barbershop
  ///
  /// Returns:
  /// - a `Future<BarbershopModel>`
  Future<BarbershopModel> getBarbershop(String id);

  /// Method to add a new barbershop
  ///
  /// Parameters:
  /// - [barbershop]: the barbershop to be added
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while adding the barbershop
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> addBarbershop(BarbershopModel barbershop);

  /// Method to update a barbershop
  ///
  /// Parameters:
  /// - [barbershop]: the barbershop to be updated
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while updating the barbershop
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> updateBarbershop(BarbershopModel barbershop);

  /// Method to delete a barbershop
  ///
  /// Parameters:
  /// - [id]: the `id` of the barbershop to be deleted
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while deleting the barbershop
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> deleteBarbershop(String id);

  /// Method to favorite a barbershop
  ///
  /// Parameters:
  /// - [userId]: the `id` of the user who is favoriting the barbershop
  /// - [barbershopId]: the `id` of the barbershop to be favorited
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while favoriting the barbershop
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> favoriteBarbershop(String userId, String barbershopId);

  /// Method to unfavorite a barbershop
  ///
  /// Parameters:
  /// - [userId]: the `id` of the user who is unfavoriting the barbershop
  /// - [barbershopId]: the `id` of the barbershop to be unfavorited
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while unfavoriting the barbershop
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> unfavoriteBarbershop(String userId, String barbershopId);

  /// Method to get a merged availability stream
  ///
  /// Parameters:
  /// - [shopId]: the `id` of the barbershop whose availability is to be fetched
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while fetching the availability
  ///
  /// Returns:
  /// - a `Stream<AvailabilityModel>`
  Stream<AvailabilityModel> getMergedAvailabilityStream(String shopId);

  /// Method to get a stream of appointments
  ///
  /// Parameters:
  /// - [shopId]: the `id` of the barbershop whose appointments are to be fetched
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while fetching appointments
  ///
  /// Returns:
  /// - a `Stream<List<AppointmentModel>>`
  Stream<List<AppointmentModel>> getAppointmentsStream(String shopId);

  /// Method to update availability
  ///
  /// Parameters:
  /// - [availability]: the availability to be updated
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while updating the availability
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> updateAvailability(AvailabilityModel availability);
}

class BarbershopDataSourceImpl implements BarbershopDataSource {
  final FirebaseFirestore firestore;

  BarbershopDataSourceImpl({required this.firestore});

  @override
  Future<void> addBarbershop(BarbershopModel barbershop) async {
    try {
      await firestore
          .collection('barbershops')
          .doc(barbershop.id)
          .set(barbershop.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBarbershop(String id) async {
    try {
      await firestore.collection('barbershops').doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BarbershopModel> getBarbershop(String id) {
    try {
      final snapshot = firestore.collection('barbershops').doc(id).get();
      return snapshot.then((value) => BarbershopModel.fromMap(value.data()!));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BarbershopModel>> getBarbershops() {
    try {
      final snapshot = firestore.collection('barbershops').get();
      return snapshot.then((value) =>
          value.docs.map((e) => BarbershopModel.fromMap(e.data())).toList());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateBarbershop(BarbershopModel barbershop) {
    try {
      return firestore
          .collection('barbershops')
          .doc(barbershop.id)
          .update(barbershop.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> favoriteBarbershop(String userId, String barbershopId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'favoriteShops': FieldValue.arrayUnion([barbershopId])
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unfavoriteBarbershop(String userId, String barbershopId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'favoriteShops': FieldValue.arrayRemove([barbershopId])
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<AvailabilityModel> getMergedAvailabilityStream(String shopId) async* {
    try {
      // Get availability stream
      final availabilityStream = firestore
          .collection('availability')
          .doc(shopId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists) {
          throw const ServerException('Availability not found');
        }
        return AvailabilityModel.fromMap(snapshot.data()!);
      });

      // Get appointments stream
      final appointmentsStream = firestore
          .collection('appointments')
          .where('shop_id', isEqualTo: shopId)
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 1)))
          .where('status', whereNotIn: ['cancelled', 'rejected'])
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc))
              .toList());

      // Merge the availability and appointments streams
      yield* Rx.combineLatest2(
        availabilityStream,
        appointmentsStream,
        (AvailabilityModel availability, List<AppointmentModel> appointments) {
          // Merge default and custom availability

          AvailabilityModel mergedAvailability =
              _mergeDefaultAndCustomAvailability(availability);

          // Mark booked time slots based on appointments
          return _markBookedTimeSlots(mergedAvailability, appointments);
        },
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

// Helper function to merge default and custom availability
  AvailabilityModel _mergeDefaultAndCustomAvailability(
      AvailabilityModel availability) {
    Map<DateTime, List<TimeSlotModel>> mergedTimeSlots = {};

    DateTime now = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
    // Iterate over the next `availabilityWindow` days
    for (int i = 0; i < availability.availabilityWindow; i++) {
      DateTime currentDate = now.add(Duration(days: i));
      // Check if there's custom availability for the current date
      if (availability.customTimeSlots.containsKey(currentDate) &&
          availability.customTimeSlots[currentDate] != null) {
        // Safely access customTimeSlots
        mergedTimeSlots[currentDate] = availability
            .customTimeSlots[currentDate]!
            .map((slot) => TimeSlotModel.fromEntity(
                slot)) // Convert TimeSlot to TimeSlotModel
            .toList();
      } else {
        // Use default availability based on the weekday
        int weekday = currentDate.weekday % 7 + 1;

        // Check if defaultTimeSlots[weekday] is not null before accessing
        if (availability.defaultTimeSlots.containsKey(weekday) &&
                availability.defaultTimeSlots[weekday] != null
            // && availability.defaultTimeSlots[weekday]!.isNotEmpty
            ) {
          mergedTimeSlots[currentDate] = availability.defaultTimeSlots[weekday]!
              .map((slot) => TimeSlotModel.fromEntity(
                  slot)) // Convert TimeSlot to TimeSlotModel
              .toList();
        }
      }
    }

    if (mergedTimeSlots.isEmpty ||
        mergedTimeSlots.values.every((slots) => slots.isEmpty)) {
      return availability;
    }

    return AvailabilityModel.fromEntity(
        availability.copyWith(timeSlots: mergedTimeSlots));
  }

// Helper function to mark booked time slots
  AvailabilityModel _markBookedTimeSlots(
      AvailabilityModel availability, List<AppointmentModel> appointments) {
    availability.timeSlots.forEach((date, timeSlots) {
      for (var slot in timeSlots) {
        if (appointments.any((appointment) {
          final isSameDate = MyDateUtils.isSameDate(appointment.date, date);

          final isSameTime =
              MyDateUtils.isSameTime(appointment.startTime, slot.startTime) &&
                  MyDateUtils.isSameTime(appointment.endTime, slot.endTime);

          return isSameDate && isSameTime;
        })) {
          slot.isBooked = true;
        }
      }
    });

    return availability;
  }

  @override
  Stream<List<AppointmentModel>> getAppointmentsStream(String shopId) async* {
    try {
      yield* firestore
          .collection('appointments')
          .where('shop_id', isEqualTo: shopId)
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 1)))
          .where('status', whereNotIn: ['cancelled', 'rejected'])
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc))
              .toList());
    } on FirebaseException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateAvailability(AvailabilityModel availability) async {
    try {
      await firestore
          .collection('availability')
          .doc(availability.id)
          .update(availability.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
