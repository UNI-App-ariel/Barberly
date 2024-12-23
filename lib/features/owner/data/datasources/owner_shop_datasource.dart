import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';

abstract interface class OwnerShopDatasource {
  Future<BarbershopModel> getOwnerShop(String shopId);
  Future<BarbershopModel> updateOwnerShop(BarbershopModel ownerShop);
  Future<void> deleteOwnerShop(String id);
}

class OwnerShopDatasourceImpl implements OwnerShopDatasource {
  final FirebaseFirestore firestore;
  final firebaseStorage = FirebaseStorage.instance;

  OwnerShopDatasourceImpl({required this.firestore});

  @override
  Future<BarbershopModel> getOwnerShop(String shopId) async {
    try {
      final snapshot =
          await firestore.collection('barbershops').doc(shopId).get();
      if (!snapshot.exists) {
        throw const ServerException('Shop not found');
      }

      final data = BarbershopModel.fromMap(snapshot.data()!);
      return data;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BarbershopModel> updateOwnerShop(BarbershopModel ownerShop) async {
    try {
      // if image file is not null, upload it to firebase storage
      // if (ownerShop.imgaeFile != null) { // TODO: implement firebase storage (needs billing plan)
      //   final ref = firebaseStorage
      //       .ref()
      //       .child('barbershops/${ownerShop.id}/profileImage');
      //   final uploadTask = ref.putFile(ownerShop.imgaeFile!);
      //   final snapshot = await uploadTask.whenComplete(() => null);
      //   final imageUrl = await snapshot.ref.getDownloadURL();
      //   ownerShop =
      //       BarbershopModel.fromEntity(ownerShop.copyWith(imageUrl: imageUrl));
      // }

      await firestore
          .collection('barbershops')
          .doc(ownerShop.id)
          .update(ownerShop.toMap());
      return ownerShop;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteOwnerShop(String id) async {
    try {
      await firestore.collection('barbershops').doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
