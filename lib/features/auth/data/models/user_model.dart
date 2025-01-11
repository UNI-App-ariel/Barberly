import 'package:uni_app/features/auth/domain/entities/user.dart';

class MyUserModel extends MyUser {
  MyUserModel({
    required super.id,
    required super.email,
    required super.name,
    super.shopId,
    super.photoUrl,
    super.favoriteShops = const [],
    super.role = 'customer',
    super.accountType = 'email',
  });

  // from map
  factory MyUserModel.fromMap(Map<String, dynamic> map) {
    return MyUserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      shopId: map['shopId'],
      photoUrl: map['photoUrl'],
      favoriteShops: List<String>.from(map['favoriteShops']),
      role: map['role'],
      accountType: map['accountType'] ?? 'email'
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'shopId': shopId,
      'photoUrl': photoUrl,
      'favoriteShops': favoriteShops,
      'role': role,
      'accountType': accountType,
    };
  }

  static MyUserModel fromEntity(MyUser user) {
    return MyUserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      shopId: user.shopId,
      photoUrl: user.photoUrl,
      favoriteShops: user.favoriteShops,
      role: user.role,
      accountType: user.accountType,
    );
  }
}
