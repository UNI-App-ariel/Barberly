import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';

class AppointmentSuccessSheet extends StatelessWidget {
  final Appointment appointment;
  const AppointmentSuccessSheet({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final shop =
        context.read<BarbershopBloc>().getBarbershopById(appointment.shopId);
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  size: 160,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'Appointment Booked',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Your appointment has been booked successfully',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: shop?.imageUrl != null
                                ? CachedNetworkImageProvider(shop!.imageUrl!)
                                : null,
                            child: shop?.imageUrl == null
                                ? const Icon(Icons.storefront)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop?.name ?? 'Unknown Shop',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.calendar,
                                    size: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    MyDateUtils.toDate(appointment.date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.time,
                                    size: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${MyDateUtils.toTime(appointment.startTime)} - ${MyDateUtils.toTime(appointment.endTime)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                MyButton(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
