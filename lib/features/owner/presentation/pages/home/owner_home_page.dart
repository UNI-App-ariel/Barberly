import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_appointments/owner_appointments_bloc.dart';
import 'package:uni_app/features/owner/presentation/widgets/owner_appointment_tile.dart';

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: false,
      ),
      body: BlocConsumer<OwnerAppointmentsBloc, OwnerAppointmentsState>(
        listener: (context, state) {
          if (state is OwnerAppointmentsError) {
            MyUtils.showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is OwnerAppointmentsLoading) {
            return const Center(
              child: Loader(),
            );
          } else if (state is OwnerAppointmentsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: state.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = state.appointments[index];
                  return OwnerAppointmentTile(appointment: appointment);
                },
              ),
            );
          } else {
            return const Center(
              child: Text('No appointments found'),
            );
          }
        },
      ),
    );
  }
}
