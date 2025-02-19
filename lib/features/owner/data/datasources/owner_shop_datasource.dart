import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';

abstract interface class OwnerShopDatasource {
  Stream<BarbershopModel> getOwnerShop(String shopId);
  Future<BarbershopModel> updateOwnerShop(
      BarbershopModel ownerShop, File? pickedImage, List<File>? galleryImages);
  Future<void> deleteOwnerShop(String id);

  Future<void> deleteImageFromGallery(String shopId, String imageUrl);
}

class OwnerShopDatasourceImpl implements OwnerShopDatasource {
  final FirebaseFirestore firestore;
  final firebaseStorage = FirebaseStorage.instance;

  OwnerShopDatasourceImpl({required this.firestore});

  @override
  Stream<BarbershopModel> getOwnerShop(String shopId) async* {
    try {
      final snapshot =
          firestore.collection('barbershops').doc(shopId).snapshots();
      await for (final snapshot in snapshot) {
        final data = BarbershopModel.fromMap(snapshot.data()!);
        yield data;
      }
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BarbershopModel> updateOwnerShop(BarbershopModel ownerShop,
      File? pickedImage, List<File>? galleryImages) async {
    try {
      String? profileImageUrl;

      // If a new profile picture is selected, upload it and get the URL
      if (pickedImage != null) {
        // Check if the shop already has an existing image
        if (ownerShop.imageUrl != null && ownerShop.imageUrl!.isNotEmpty) {
          final oldImageRef = firebaseStorage.refFromURL(ownerShop.imageUrl!);
          await oldImageRef.delete();
        }

        // Upload new profile image to Firebase Storage
        final ref = firebaseStorage.ref().child(
            'barbershops/${ownerShop.id}/profile/${DateTime.now().millisecondsSinceEpoch}.jpg');

        profileImageUrl = await ref
            .putFile(pickedImage)
            .then((p0) => p0.ref.getDownloadURL());

        // Update the ownerShop object with the new profile picture URL
        ownerShop = BarbershopModel.fromEntity(
          ownerShop.copyWith(imageUrl: profileImageUrl),
        );
      }

      // Upload gallery images if they exist
      if (galleryImages != null) {
        final List<String> galleryUrls = [];
        for (final image in galleryImages) {
          final ref = firebaseStorage.ref().child(
              'barbershops/${ownerShop.id}/gallery/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final imageUrl =
              await ref.putFile(image).then((p0) => p0.ref.getDownloadURL());
          galleryUrls.add(imageUrl);
        }
        ownerShop = BarbershopModel.fromEntity(ownerShop.copyWith(
          gallery: [...ownerShop.gallery, ...galleryUrls],
        ));
      }

      // Update Firestore with new data (profile picture & gallery images)
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

  @override
  Future<void> deleteImageFromGallery(String shopId, String imageUrl) async {
    try {
      final ref = firebaseStorage.refFromURL(imageUrl);
      await ref.delete();

      final shopRef = firestore.collection('barbershops').doc(shopId);
      final snapshot = await shopRef.get();
      if (!snapshot.exists) {
        throw const ServerException('Shop not found');
      } else {
        await shopRef.update({
          'gallery': FieldValue.arrayRemove([imageUrl])
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
