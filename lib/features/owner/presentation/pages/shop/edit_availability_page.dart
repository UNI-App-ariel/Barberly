import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';
import 'package:uni_app/features/owner/presentation/pages/shop/edit_day_availability_page.dart';

class EditShopAvailabilityPage extends StatelessWidget {
  final Barbershop shop;
  const EditShopAvailabilityPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Availability'),
      ),
      body: BlocBuilder<ShopAvailabilityBloc, ShopAvailabilityState>(
        builder: (context, state) {
          if (state is ShopAvailabilityLoading) {
            return const Loader();
          } else if (state is ShopAvailabilityLoaded) {
            return _buildAvailabilityList(context, state.availability);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAvailabilityList(
      BuildContext context, Availability availability) {
    final defaultAvailability = availability.defaultTimeSlots;
    return CupertinoListSection.insetGrouped(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: List.generate(7, (index) => index + 1).map(
        (day) {
          final dayName = MyDateUtils.getDayName(day);
          final times = _getTimes(defaultAvailability[day]);
          return CupertinoListTile(
            title: Text(dayName),
            subtitle: Text(times),
            trailing: const Icon(
              CupertinoIcons.right_chevron,
              size: 18,
              color: CupertinoColors.systemGrey,
            ),
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditDayAvailabilityPage(
                shop: shop,
                day: day,
                defaultAvailability: defaultAvailability[day],
                availability: availability,
              );
            })),
          );
        },
      ).toList(),
    );
  }

  String _getTimes(List<TimeSlot>? defaultAvailability) {
    if (defaultAvailability == null || defaultAvailability.isEmpty) {
      return 'Closed';
    }

    // sort the time slots by start time
    defaultAvailability.sort((a, b) => a.compareTo(b));

    final startTime = defaultAvailability.first.startTime;
    final endTime = defaultAvailability.last.endTime;

    return '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
  }
}
