import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/booked_appointments/booked_appointments_bloc.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/customer/presentation/widgets/customer_appointment_tile.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late MyUser? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = context.watch<AppUserBloc>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            user != null ? _buildLoggedInView() : _buildLoggedOutView(context),
      ),
    );
  }

  Widget _buildLoggedInView() {
    return BlocConsumer<BookedAppointmentsBloc, BookedAppointmentsState>(
      listener: (context, state) {
        if (state is BookedAppointmentsError) {
          MyUtils.showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is BookedAppointmentsLoaded) {
          if (state.appointments.isEmpty) {
            return const Center(
              child: Text("No appointments booked yet"),
            );
          }
          return ListView.builder(
            itemCount: state.appointments.length,
            itemBuilder: (context, index) {
              final appointment = state.appointments[index];
              return CustomerAppointmentTile(
                appointment: appointment,
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Log in to view your appointments",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Update route as needed
          },
          child: const Text(
            "Login/Signup",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
