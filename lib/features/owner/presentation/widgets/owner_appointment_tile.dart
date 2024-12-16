import 'package:flutter/material.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';

class OwnerAppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const OwnerAppointmentTile({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${appointment.customerName}'),
        ],
      ),
    );
  }
}
