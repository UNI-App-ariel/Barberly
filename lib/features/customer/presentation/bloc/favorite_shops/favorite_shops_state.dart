part of 'favorite_shops_bloc.dart';

@immutable
sealed class FavoriteShopsState {}

final class FavoriteShopsInitial extends FavoriteShopsState {}

final class FavoriteShopsLoading extends FavoriteShopsState {}

final class FavoriteShopsLoaded extends FavoriteShopsState {
  final List<Barbershop> barbershops;

  FavoriteShopsLoaded(this.barbershops);
}

final class FavoriteShopsError extends FavoriteShopsState {
  final String message;

  FavoriteShopsError(this.message);
}
