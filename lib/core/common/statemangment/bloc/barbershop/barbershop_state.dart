part of 'barbershop_bloc.dart';

@immutable
sealed class BarbershopState {}

final class BarbershopInitial extends BarbershopState {}

final class BarbershopLoading extends BarbershopState {}

final class BarbershopLoaded extends BarbershopState {
  final List<Barbershop> barbershops;

  BarbershopLoaded(this.barbershops);
}

final class BarbershopError extends BarbershopState {
  final String message;

  BarbershopError(this.message);
}