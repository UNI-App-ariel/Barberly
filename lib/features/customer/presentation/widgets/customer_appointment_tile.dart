import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/statemangment/bloc/appointment/appointment_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';
import 'package:uni_app/core/utils/my_utils.dart';

class CustomerAppointmentTile extends StatelessWidget {
  final Appointment appointment;
  const CustomerAppointmentTile({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final barbershop =
        context.watch<BarbershopBloc>().getBarbershopById(appointment.shopId);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // barbershop image
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(4, 0),
                ),
              ],
              image: barbershop != null && barbershop.imageUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(barbershop.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: barbershop == null || barbershop.imageUrl == null
                ? FaIcon(
                    FontAwesomeIcons.shop,
                    size: 20,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // barbershop name
                Text(
                  barbershop?.name ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 2),

                // appointment date
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      MyDateUtils.toDate(appointment.date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // appointment time
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${MyDateUtils.toTime(appointment.startTime)} - ${MyDateUtils.toTime(appointment.endTime)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // shop address
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.locationDot,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      barbershop?.address ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              CupertinoIcons.trash,
              color: Colors.red,
              size: 20,
            ),
            onPressed: () {
              // cancel appointment
              MyUtils.showConfirmationDialog(
                context: context,
                message: 'Are you sure you want to cancel this appointment?',
                onConfirm: () {
                  context
                      .read<AppointmentBloc>()
                      .add(CancelAppointmentEvent(appointment));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
