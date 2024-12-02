// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyUser {
  final String id;
  final String email;
  final String name;
  final String? shopId;
  final String? photoUrl;
  final List<String> favoriteShops;
  final String role;

  MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.shopId,
    this.photoUrl,
    this.favoriteShops = const [],
    this.role = 'customer',
  });

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? shopId,
    String? photoUrl,
    List<String>? favoriteShops,
    String? role,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      shopId: shopId ?? this.shopId,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteShops: favoriteShops ?? this.favoriteShops,
      role: role ?? this.role,
    );
  }
}
