// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyUser {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final List<String> favoriteShops;

  MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.favoriteShops = const [],
  });

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
