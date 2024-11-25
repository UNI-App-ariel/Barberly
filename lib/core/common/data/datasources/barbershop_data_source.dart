import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';

abstract interface class BarbershopDataSource {
  Future<List<BarbershopModel>> getBarbershops();
  Future<BarbershopModel> getBarbershop(String id);
  Future<void> addBarbershop(BarbershopModel barbershop);
  Future<void> updateBarbershop(BarbershopModel barbershop);
  Future<void> deleteBarbershop(String id);
}

class BarbershopDataSourceImpl implements BarbershopDataSource {
  final FirebaseFirestore firestore;

  BarbershopDataSourceImpl({required this.firestore});

  @override
  Future<void> addBarbershop(BarbershopModel barbershop) async {
    try {
      await firestore.collection('barbershops').add(barbershop.toMap());
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
      return snapshot.then((value) => value.docs
          .map((e) => BarbershopModel.fromMap(e.data()))
          .toList());
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
}