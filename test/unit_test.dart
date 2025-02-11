import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:uni_app/core/common/data/datasources/appointments_data_source.dart';
import 'package:uni_app/core/common/data/datasources/barbershop_data_source.dart';
import 'package:uni_app/core/common/data/models/appointment_model.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';

import 'mocks/mocks.mocks.dart';

void main() {
  late BarbershopDataSource barbershopDataSource;
  late AppointmentsDataSource appointmentsDataSource;

  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockUserCollection;
  late MockCollectionReference<Map<String, dynamic>> mockAppointmentCollection;
  late MockCollectionReference<Map<String, dynamic>> mockBarbershopCollection;
  late MockDocumentReference<Map<String, dynamic>> mockUserDocument;
  late MockDocumentReference<Map<String, dynamic>> mockAppointmentDocument;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockUserCollection = MockCollectionReference();
    mockAppointmentCollection = MockCollectionReference();
    mockBarbershopCollection = MockCollectionReference();
    mockUserDocument = MockDocumentReference();
    mockAppointmentDocument = MockDocumentReference();

    barbershopDataSource = BarbershopDataSourceImpl(firestore: mockFirestore);
    appointmentsDataSource =
        AppointmentsDataSourceImpl(firestore: mockFirestore);

    when(mockFirestore.collection('users')).thenReturn(mockUserCollection);
    when(mockUserCollection.doc(any)).thenReturn(mockUserDocument);

    when(mockFirestore.collection('appointments'))
        .thenReturn(mockAppointmentCollection);
    when(mockAppointmentCollection.doc(any))
        .thenReturn(mockAppointmentDocument);

    when(mockFirestore.collection('barbershops'))
        .thenReturn(mockBarbershopCollection);
  });

  group('Favorite Barbershop', () {
    const String userId = 'testUserId';
    const String barbershopId = 'testBarbershopId';

    test('should successfully favorite a barbershop', () async {
      // Arrange
      when(mockUserDocument.update({
        'favoriteShops': FieldValue.arrayUnion([barbershopId])
      })).thenAnswer((_) async => Future.value());

      // Act
      await barbershopDataSource.favoriteBarbershop(userId, barbershopId);

      // Assert
      verify(mockFirestore.collection('users')).called(1);
      verify(mockUserCollection.doc(userId)).called(1);
      verify(mockUserDocument.update({
        'favoriteShops': FieldValue.arrayUnion([barbershopId])
      })).called(1);
    });

    test('should throw ServerException when Firebase throws an error',
        () async {
      // Arrange
      when(mockUserDocument.update({
        'favoriteShops': FieldValue.arrayUnion([barbershopId])
      })).thenThrow(
          FirebaseException(plugin: 'firestore', message: 'Test Error'));

      // Act & Assert
      expect(
        () async =>
            await barbershopDataSource.favoriteBarbershop(userId, barbershopId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('Book Appointment', () {
    const String appointmentId = 'testAppointmentId';

    final appointment = AppointmentModel(
      id: appointmentId,
      userId: 'testUserId',
      shopId: 'testShopId',
      customerName: 'testCustomerName',
      customerEmail: 'testCustomerEmail',
      customerImageURL: null,
      date: DateTime(2025, 2, 8),
      startTime: DateTime(2025, 2, 8, 10, 0),
      endTime: DateTime(2025, 2, 8, 11, 0),
      serviceId: 'testServiceId',
      status: 'pending',
      createdAt: DateTime.now(),
    );

    test('should successfully book an appointment', () async {
      // Arrange
      when(mockAppointmentDocument.set(appointment.toMap()))
          .thenAnswer((_) async => Future.value());

      // Act
      await appointmentsDataSource.bookAppointment(appointment);

      // Assert
      verify(mockFirestore.collection('appointments')).called(1);
      verify(mockAppointmentCollection.doc(appointment.id)).called(1);
      verify(mockAppointmentDocument.set(appointment.toMap())).called(1);
    });

    test('should throw ServerException when Firestore throws an error',
        () async {
      // Arrange
      when(mockAppointmentDocument.set(appointment.toMap())).thenThrow(
          FirebaseException(plugin: 'firestore', message: 'Test Error'));

      // Act & Assert
      expect(
        () async => await appointmentsDataSource.bookAppointment(appointment),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('Add Barbershop', () {
    final barbershop = BarbershopModel(
      id: 'testBarbershopId',
      name: 'Test Barbershop',
      address: 'Test Address',
      phoneNumber: '1234567890',
      reviewCount: 100,
      imageUrl: null,
      rating: 4.5,
      services: [],
      barbers: [],
    );

    test('should successfully add a barbershop', () async {
      // Arrange
      final mockBarbershopDocument =
          MockDocumentReference<Map<String, dynamic>>();
      // Arrange
      when(mockBarbershopCollection.add(barbershop.toMap()))
          .thenAnswer((_) async => mockBarbershopDocument);

      // Act
      await barbershopDataSource.addBarbershop(barbershop);

      // Assert
      verify(mockFirestore.collection('barbershops')).called(1);
      verify(mockBarbershopCollection.add(barbershop.toMap())).called(1);
    });

    test('should throw ServerException when Firestore throws an error',
        () async {
      // Arrange
      when(mockBarbershopCollection.add(barbershop.toMap())).thenThrow(
          FirebaseException(plugin: 'firestore', message: 'Test Error'));

      // Act & Assert
      expect(
        () async => await barbershopDataSource.addBarbershop(barbershop),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
