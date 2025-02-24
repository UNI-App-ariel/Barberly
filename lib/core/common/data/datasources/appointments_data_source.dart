import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_app/core/common/data/models/appointment_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';

/// This class is responsible for fetching and updating appointments data from Firestore.
/// It uses `Firebase Firestore`.
abstract interface class AppointmentsDataSource {
  /// Method to get a stream of appointments data from Firestore.
  ///
  /// Parameters:
  /// - [userId]: the `id` of the user whose appointments are to be fetched
  ///
  /// Returns:
  /// - a stream of [AppointmentModel]
  Stream<List<AppointmentModel>> getAppointments(String userId);

  /// Method to book an appointment in Firestore.
  ///
  /// Parameters:
  /// - [appointment]: the appointment to be booked
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while booking the appointment
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> bookAppointment(AppointmentModel appointment);

  /// Method to cancel an appointment in Firestore.
  ///
  /// Parameters:
  /// - [appointmentId]: the `id` of the appointment to be cancelled
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while cancelling the appointment
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> cancelAppointment(String appointmentId);

  /// Method to update an appointment in Firestore.
  ///
  /// Parameters:
  /// - [appointment]: the appointment to be updated
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while updating the appointment
  ///
  /// Returns:
  /// - a `Future<void>`
  Future<void> updateAppointment(AppointmentModel appointment);
}

/// This class is responsible for fetching and updating appointments data from Firestore.
/// It uses `Firebase Firestore`.
///
/// Parameters:
/// - [firestore]: an instance of FirebaseFirestore
class AppointmentsDataSourceImpl implements AppointmentsDataSource {
  final FirebaseFirestore firestore; // an instance of FirebaseFirestore

  AppointmentsDataSourceImpl({required this.firestore});

  /// Method to get a stream of appointments data from Firestore.
  ///
  /// Parameters:
  /// - [userId]: the `id` of the user whose appointments are to be fetched
  ///
  /// Returns:
  /// - a stream of [AppointmentModel]
  @override
  Stream<List<AppointmentModel>> getAppointments(String userId) async* {
    try {
      final appointments = firestore
          .collection('appointments')
          .where('user_id', isEqualTo: userId)
          .snapshots();
      yield* appointments.map((snapshot) =>
          snapshot.docs.map((doc) => AppointmentModel.fromMap(doc)).toList());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Method to book an appointment in Firestore.
  ///
  /// Parameters:
  /// - [appointment]: the appointment to be booked
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while booking the appointment
  ///
  /// Returns:
  /// - a `Future<void>`
  @override
  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Method to cancel an appointment in Firestore.
  ///
  /// Parameters:
  /// - [appointmentId]: the `id` of the appointment to be cancelled
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while cancelling the appointment
  ///
  /// Returns:
  /// - a `Future<void>`
  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Method to update an appointment in Firestore.
  ///
  /// Parameters:
  /// - [appointment]: the appointment to be updated
  ///
  /// Throws:
  /// - [ServerException]: if an error occurs while updating the appointment
  ///
  /// Returns:
  /// - a `Future<void>`
  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointment.id)
          .update(appointment.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
