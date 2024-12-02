part of 'favorite_shops_bloc.dart';

@immutable
sealed class FavoriteShopsEvent {}

class GetFavoriteShopsEvent extends FavoriteShopsEvent {
  final String userId;

  GetFavoriteShopsEvent(this.userId);
}


