import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/widgets/date_time_line_picker.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/owner/presentation/bloc/owner_shop/owner_shop_bloc.dart';
import 'package:uni_app/features/owner/presentation/pages/shop/edit_availability_page.dart';
import 'package:uni_app/features/owner/presentation/pages/shop/edit_shop_detail_page.dart';

class OwnerShopPage extends StatefulWidget {
  const OwnerShopPage({super.key});

  @override
  State<OwnerShopPage> createState() => _OwnerShopPageState();
}

class _OwnerShopPageState extends State<OwnerShopPage> {
  int selectedTabIndex = 0;
  DateTime selectedDate = DateTime.now();
  Barbershop? shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OwnerShopBloc, OwnerShopState>(
        listener: (context, state) {
          if (state is OwnerShopError) {
            MyUtils.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is OwnerShopLoading) {
            return const Center(
              child: Loader(),
            );
          } else if (state is OwnerShopLoaded) {
            shop = state.shop;
            if (shop != null) {
              context
                  .read<ShopAvailabilityBloc>()
                  .add(StreamAvailabilityEvent(shop!.id));
            }
            return _buildShopWithSlivers(state.shop);
          } else {
            return const Center(
              child: Text('No shop found'),
            );
          }
        },
      ),
    );
  }

  Widget _buildShopWithSlivers(Barbershop shop) {
    return CustomScrollView(
      slivers: [
        // Sliver AppBar with shop image
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.3,
          flexibleSpace: FlexibleSpaceBar(
            background: shop.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: shop.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
          pinned: true, // Keeps the app bar visible at the top
        ),

        // SliverList for shop content
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildShopDetails(shop),
              _buildEditShopButton(shop),
              _buildEditAvailabilityButton(shop),
              _buildTabs(shop),
              _buildTabPages(shop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShopDetails(Barbershop shop) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // Rating Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rating Text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${shop.rating}', // Rating
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Add color explicitly
                          ),
                        ),
                        TextSpan(
                          text: ' (${shop.reviewCount})', // Review count
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Star Icon
                  const Align(
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildEditShopButton(Barbershop shop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: MyButton(
        borderRadius: 15,
        backgroundColor: Colors.blue,
        onPressed: () {
          // Navigate to edit profile page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditShopDetailPage(),
            ),
          );
        },
        child: const Text(
          'Edit Shop',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _buildTabs(Barbershop shop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: MyButton(
              borderRadius: 15,
              backgroundColor: selectedTabIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              onPressed: () {
                // Navigate to edit profile page
                setState(() {
                  selectedTabIndex = 0;
                });
              },
              child: Text(
                'Availabilities',
                style: TextStyle(
                  fontSize: 15,
                  color: selectedTabIndex == 0
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MyButton(
              borderRadius: 15,
              backgroundColor: selectedTabIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              onPressed: () {
                // Navigate to edit profile page
                setState(() {
                  selectedTabIndex = 1;
                });
              },
              child: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 15,
                  color: selectedTabIndex == 1
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTabPages(Barbershop shop) {
    if (selectedTabIndex == 0) {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                DateTimelinePicker(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  borderColor: Theme.of(context).colorScheme.tertiary,
                  startDate: DateTime.now(),
                  initialDate: DateTime.now(),
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                const Divider(
                  // Divider
                  color: Colors.grey,
                  height: 40,
                  thickness: 1,
                ),

                // get time slots
                BlocBuilder<ShopAvailabilityBloc, ShopAvailabilityState>(
                  builder: (context, state) {
                    if (state is ShopAvailabilityLoading) {
                      return const Center(
                        child: Loader(),
                      );
                    } else if (state is ShopAvailabilityLoaded) {
                      final availability = state.availability.timeSlots;
                      final timeSlot = availability.entries.firstWhere(
                        (element) {
                          return DateTime(element.key.year, element.key.month,
                                  element.key.day) ==
                              DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                              );
                        },
                        orElse: () => MapEntry(selectedDate, []),
                      );

                      if (timeSlot.value.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                            child: Text('No availability found'),
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            timeSlot.value.length, // Number of time slots
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.8,
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                MyDateUtils.toTime(
                                    timeSlot.value[index].startTime),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No availability found'),
                      );
                    }
                  },
                )
              ],
            ),
          ));
    } else {
      return const SizedBox.shrink();
    }
  }

  _buildEditAvailabilityButton(Barbershop shop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: MyButton(
        borderRadius: 15,
        backgroundColor: Colors.blue,
        onPressed: () {
          // Navigate to edit profile page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  EditShopAvailabilityPage(shop: shop),
            ),
          );
        },
        child: const Text(
          'Edit Availability',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
