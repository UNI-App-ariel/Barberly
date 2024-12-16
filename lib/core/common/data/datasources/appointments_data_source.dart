import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_app/core/common/data/models/appointment_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';

abstract interface class AppointmentsDataSource {
  Stream<List<AppointmentModel>> getAppointments(String userId);
  Future<void> bookAppointment(AppointmentModel appointment);
  Future<void> cancelAppointment(String appointmentId);
}


class AppointmentsDataSourceImpl implements AppointmentsDataSource {
  final FirebaseFirestore firestore;

  AppointmentsDataSourceImpl({required this.firestore});

  @override
  Stream<List<AppointmentModel>> getAppointments(String userId) async* {
    try{ 
      final appointments = firestore.collection('appointments').where('userId', isEqualTo: userId).snapshots();
      yield* appointments.map((snapshot) => snapshot.docs.map((doc) => AppointmentModel.fromMap(doc)).toList());
    } on FirebaseException catch(e) {
      throw ServerException(e.message?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      await firestore.collection('appointments').doc(appointment.id).set(appointment.toMap());
    } on FirebaseException catch(e) {
      throw ServerException(e.message?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try
    {
      await firestore.collection('appointments').doc(appointmentId).delete();
    } on FirebaseException catch(e) {
      throw ServerException(e.message?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }

  }
}