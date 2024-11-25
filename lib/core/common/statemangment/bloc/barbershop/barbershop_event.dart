part of 'barbershop_bloc.dart';

@immutable
sealed class BarbershopEvent {}


class GetAllBarberShopsEvent extends BarbershopEvent {}

class GetBarbershopEvent extends BarbershopEvent {
  final String id;

  GetBarbershopEvent(this.id);
}

class AddBarbershopEvent extends BarbershopEvent {
  final Barbershop barbershop;

  AddBarbershopEvent(this.barbershop);
}

class UpdateBarbershopEvent extends BarbershopEvent {
  final Barbershop barbershop;

  UpdateBarbershopEvent(this.barbershop);
}

class DeleteBarbershopEvent extends BarbershopEvent {
  final String id;

  DeleteBarbershopEvent(this.id);
}