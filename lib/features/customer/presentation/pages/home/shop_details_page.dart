import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/appointment/appointment_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/barbershop/barbershop_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/common/widgets/my_button.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/customer/presentation/widgets/appointment_success_sheet.dart';

import 'package:uni_app/features/customer/presentation/widgets/booking_sheet.dart';
import 'package:uni_app/features/customer/presentation/widgets/shop_details_chip.dart';
import 'package:uuid/uuid.dart';

class ShopDetailsPage extends StatefulWidget {
  final Barbershop shop;

  const ShopDetailsPage({super.key, required this.shop});

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  int selectedChipIndex = 0;
  MyUser? user;
  DateTime? _selectedDate;
  TimeSlot? _selectedTimeSlot;
  BookingButtonState? _buttonState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get user
    user = context.watch<AppUserBloc>().currentUser;
    _fetchAvailability();
  }

  void _fetchAvailability() {
    context
        .read<ShopAvailabilityBloc>()
        .add(StreamAvailabilityEvent(widget.shop.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.3,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImage(),
                  // title: Text(widget.shop.name),
                ),
                leading: IconButton(
                  icon: _buildBackButton(context),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  _buildFavoriteButton(
                      user?.favoriteShops.contains(widget.shop.id) ?? false),
                ],
              ),
              SliverToBoxAdapter(
                child: BlocConsumer<AppointmentBloc, AppointmentState>(
                  listener: (context, state) {
                    if (state is AppointmentBooked) {
                      // pop the page
                      Navigator.of(context).pop();

                      // show success sheet
                      showCustomModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (context) {
                          return AppointmentSuccessSheet(
                              appointment: state.appointment);
                        },
                        containerWidget: (context, animation, child) =>
                            ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.92,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: child,
                            ),
                          ),
                        ),
                      );
                    } else if (state is AppointmentFailure) {
                      MyUtils.showErrorSnackBar(context, state.message);
                    } else if (state is AppointmentLoading) {
                      setState(() {
                        _buttonState = BookingButtonState.loading;
                      });
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildChips(),
                        const SizedBox(height: 20),
                        _buildSheet(selectedChipIndex),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          // booking button
          Visibility(
            visible: selectedChipIndex == 0,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // date
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _selectedDate != null
                                  ? MyDateUtils.toDate(_selectedDate!)
                                  : '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.clock,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _selectedTimeSlot != null
                                  ? '${MyDateUtils.toTime(_selectedTimeSlot!.startTime)} - ${MyDateUtils.toTime(_selectedTimeSlot!.endTime)}'
                                  : 'Select Time',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        // time
                      ],
                    ),
                    const SizedBox(height: 16),
                    MyButton(
                      borderRadius: 30,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      backgroundColor: _getButtonColor(_buttonState),
                      child: _getButtonChild(_buttonState),
                      onPressed: () {
                        if (_selectedDate != null &&
                            _selectedTimeSlot != null) {
                          context.read<AppointmentBloc>().add(
                                BookAppointmentEvent(
                                  Appointment(
                                      id: const Uuid().v1(),
                                      userId: user!.id,
                                      customerName: user!.name,
                                      customerEmail: user!.email,
                                      customerImageURL: user!.photoUrl,
                                      serviceId: '0',
                                      startTime: _selectedTimeSlot!.startTime,
                                      endTime: _selectedTimeSlot!.endTime,
                                      status: 'pending',
                                      createdAt: DateTime.now(),
                                      shopId: widget.shop.id,
                                      date: DateTime(
                                        _selectedDate!.year,
                                        _selectedDate!.month,
                                        _selectedDate!.day,
                                        _selectedTimeSlot!.startTime.hour,
                                        _selectedTimeSlot!.startTime.minute,
                                      )),
                                ),
                              );
                        } else {
                          setState(() {
                            _buttonState = BookingButtonState.notValid;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (widget.shop.imageUrl == null) {
      return Center(
        child: Icon(
          Icons.store,
          size: 50,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.shop.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Icon(
          Icons.image,
          size: 50,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          size: 50,
        ),
      );
    }
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const FaIcon(
        FontAwesomeIcons.arrowLeft,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildFavoriteButton(bool isFavorite) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: FaIcon(
          isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: isFavorite ? Colors.red : Colors.white,
          size: 20,
        ),
      ),
      onPressed: () {
        if (user == null) {
          return;
        }
        setState(() {
          isFavorite
              ? context
                  .read<BarbershopBloc>()
                  .add(UnFavoriteShopEvent(user!.id, widget.shop.id))
              : context
                  .read<BarbershopBloc>()
                  .add(FavoriteShopEvent(user!.id, widget.shop.id));
        });
      },
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyChip(
            label: 'Booking',
            isSelected: selectedChipIndex == 0,
            onTap: () => setState(() => selectedChipIndex = 0),
          ),
          const SizedBox(width: 10),
          MyChip(
            label: 'Gallery',
            isSelected: selectedChipIndex == 1,
            onTap: () => setState(() => selectedChipIndex = 1),
          ),
          // TODO: Implement RateSheet
          // const SizedBox(width: 10),
          // MyChip(
          //   label: 'Rate',
          //   isSelected: selectedChipIndex == 2,
          //   onTap: () => setState(() => selectedChipIndex = 2),
          // ),
        ],
      ),
    );
  }

  Widget _buildSheet(int selectedChipIndex) {
    switch (selectedChipIndex) {
      case 0:
        return BookingSheet(
          user: user,
          shop: widget.shop,
          onSelectionChange: ({
            required selectedDate,
            required selectedTimeSlot,
            required buttonState,
          }) {
            setState(() {
              _selectedDate = selectedDate;
              _selectedTimeSlot = selectedTimeSlot;
              _buttonState = buttonState;
            });
          },
        );
      case 1:
      // return GallerySheet(
      //   images: widget.shop.galleryImages,
      //   shopId: widget.shop.id,
      // );
      case 2:
      // return const RateSheet();
      default:
        return const SizedBox();
    }
  }

  Widget _getButtonChild(BookingButtonState? buttonState) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
    switch (buttonState) {
      case BookingButtonState.notValid:
        return Text('Select Date and Time', style: textStyle);
      case BookingButtonState.loading:
        return const Loader();
      case BookingButtonState.booked:
        return Text('Booked', style: textStyle);
      case BookingButtonState.error:
        return Text('Error', style: textStyle);
      case BookingButtonState.readyToBook:
        return Text('Book Appointment', style: textStyle);
      default:
        return Text('Book Appointment', style: textStyle);
    }
  }

  Color _getButtonColor(BookingButtonState? buttonState) {
    switch (buttonState) {
      case BookingButtonState.loading:
        return Theme.of(context).colorScheme.primary;
      case BookingButtonState.booked:
        return Colors.green;
      case BookingButtonState.error:
        return Theme.of(context).colorScheme.error;
      case BookingButtonState.readyToBook:
        return Theme.of(context).colorScheme.primary;
      case BookingButtonState.notValid:
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
