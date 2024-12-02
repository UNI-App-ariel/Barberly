import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/features/auth/data/models/user_model.dart';

abstract interface class FavoritesDataSource {
  Future<List<BarbershopModel>> getFavoriteShops(String userId);
}

class FavoritesDataSourceImpl implements FavoritesDataSource {
  final FirebaseFirestore firestore;

  FavoritesDataSourceImpl({required this.firestore});

  @override
  Future<List<BarbershopModel>> getFavoriteShops(String userId) async {
    try {
      final uesrSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (!uesrSnapshot.exists) {
        throw const ServerException('User not found');
      }

      final user = MyUserModel.fromMap(uesrSnapshot.data()!);

      final favoriteShops = user.favoriteShops;

      final favoriteShopsSnapshot = await firestore
          .collection('barbershops')
          .where('id', whereIn: favoriteShops)
          .get();

      return favoriteShopsSnapshot.docs
          .map((e) => BarbershopModel.fromMap(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
