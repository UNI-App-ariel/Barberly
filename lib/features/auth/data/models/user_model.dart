import 'package:uni_app/features/auth/domain/entities/user.dart';

class MyUserModel extends MyUser {
  MyUserModel({
    required super.id,
    required super.email,
    required super.name,
    super.photoUrl,
  });

  // to map
  factory MyUserModel.fromMap(Map<String, dynamic> map) {
    return MyUserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }

  // from map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}
