import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/core/utils/my_utils.dart';

class AdminShopTile extends StatelessWidget {
  final Barbershop barbershop;
  const AdminShopTile({
    super.key,
    required this.barbershop,
  });

  @override
  Widget build(BuildContext context) {
    double borderRadius = 10;
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(context, borderRadius),
          _buildInfo(context),
          _buildOptionButton(context),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, double borderRadius) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
        ),
        child: barbershop.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: barbershop.imageUrl!,
                fit: BoxFit.cover,
              )
            : Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius),
                    )),
                child: const Icon(
                  Icons.image,
                ),
              ),
      ),
    );
  }

  _buildInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              barbershop.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            // status
            Row(
              children: [
                // status icon
                Icon(
                  barbershop.isActive ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: barbershop.isActive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),

                // status
                Text(
                  barbershop.isActive ? 'Active' : 'Inactive',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const Spacer(),

            // address
            Row(
              children: [
                // address icon
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),

                // address
                Text(
                  barbershop.address ?? 'No address',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            // phone number
            Row(
              children: [
                // phone icon
                const Icon(
                  Icons.phone,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),

                // phone number
                Text(
                  barbershop.phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildOptionButton(BuildContext context) {
    return IconButton(
      icon: const FaIcon(
        FontAwesomeIcons.ellipsisVertical,
        size: 16,
      ),
      visualDensity: VisualDensity.compact,
      onPressed: () {
        showMaterialModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        barbershop.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    // activate/deactivate shop
                    MySettingsTile(
                      title: barbershop.isActive
                          ? 'Deactivate shop'
                          : 'Activate shop',
                      leading: const FaIcon(
                        FontAwesomeIcons.powerOff,
                        size: 18,
                        color: Colors.white,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      titleColor:
                          barbershop.isActive ? Colors.red : Colors.green,
                      leadingBackgroundColor:
                          barbershop.isActive ? Colors.red : Colors.green,
                      onTap: () {
                        // pop the modal
                        Navigator.pop(context);

                        // activate/deactivate shop
                        context.read<BarbershopBloc>().add(
                            UpdateBarbershopEvent(barbershop.copyWith(
                                isActive: !barbershop.isActive)));
                      },
                    ),

                    const SizedBox(height: 8),

                    // delete shop
                    MySettingsTile(
                      title: 'Delete shop',
                      leading: const FaIcon(
                        FontAwesomeIcons.trash,
                        size: 18,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      titleColor: Colors.white,
                      leadingBackgroundColor: Colors.red,
                      onTap: () {
                        MyUtils.showConfirmationDialog(
                          context: context,
                          message: 'Are you sure you want to delete this shop?',
                          onConfirm: () {
                            // pop the modal
                            Navigator.pop(context);

                            // delete shop
                            context
                                .read<BarbershopBloc>()
                                .add(DeleteBarbershopEvent(barbershop.id));
                          },
                        );
                      },
                    ),

                    //
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
