part of 'pfp_bloc.dart';

@immutable
sealed class PfpState {}

final class PfpInitial extends PfpState {}

final class PfpLoading extends PfpState {}

final class PfpLoaded extends PfpState {
  final File image;
  PfpLoaded({required this.image});
}

final class PfpError extends PfpState {
  final String message;
  PfpError({required this.message});
}
