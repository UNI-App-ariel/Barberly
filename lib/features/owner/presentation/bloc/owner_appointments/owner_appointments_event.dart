part of 'owner_appointments_bloc.dart';

@immutable
sealed class OwnerAppointmentsEvent {}


class GetOwnerAppointemntsEvent extends OwnerAppointmentsEvent {
  final String shopId;

  GetOwnerAppointemntsEvent(this.shopId);
}
