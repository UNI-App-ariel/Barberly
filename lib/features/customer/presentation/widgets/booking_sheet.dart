import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/appointment/appointment_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/common/widgets/date_time_line_picker.dart';
import 'package:uni_app/core/common/widgets/loader.dart';
import 'package:uni_app/core/utils/my_utils.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

enum BookingButtonState {
  readyToBook,
  loading,
  booked,
  error,
  notValid,
}

class BookingSheet extends StatefulWidget {
  final MyUser? user;
  final Barbershop shop;
  final void Function({
    required DateTime? selectedDate,
    required TimeSlot? selectedTimeSlot,
    required BookingButtonState buttonState,
  }) onSelectionChange;
  const BookingSheet({
    super.key,
    required this.user,
    required this.shop,
    required this.onSelectionChange,
  });

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  Map<DateTime, List<TimeSlot>> availabilityData = {};
  DateTime? _selectedDate;
  TimeSlot? _selectedTimeSlot;
  DateTime? _firstDate;
  BookingButtonState _buttonState = BookingButtonState.readyToBook;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopAvailabilityBloc, ShopAvailabilityState>(
      builder: (context, state) {
        if (state is ShopAvailabilityLoaded) {
          availabilityData = state.availability.timeSlots;
          _selectedDate ??= availabilityData.keys.firstOrNull;
          _firstDate = availabilityData.keys.firstOrNull;
        } else if (state is ShopAvailabilityError) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            MyUtils.showErrorSnackBar(context, state.message);
          });
          // showErrorSnackBar(context, state.message);
        } else if (state is ShopAvailabilityLoading) {
          return const Center(
            child: Loader(),
          );
        }

        return BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is AppointmentBooked) {
              setState(() {
                _buttonState = BookingButtonState.booked;
                _selectedTimeSlot = null;
                widget.onSelectionChange(
                  selectedDate: _selectedDate,
                  selectedTimeSlot: _selectedTimeSlot,
                  buttonState: _buttonState,
                );
              });
              // showMyBottomSheet(
              //   context: context,
              //   isPage: true,
              //   isScrollControlled: true,
              //   isDismissible: false,
              //   enableDrag: false,
              //   child: SuccessBottomSheet(
              //     appointment: state.appointment,
              //     shop: widget.shop,
              //   ),
              // );
            } else if (state is AppointmentFailure) {
              setState(() {
                _buttonState = BookingButtonState.error;
                _selectedTimeSlot = null;
                widget.onSelectionChange(
                  selectedDate: _selectedDate,
                  selectedTimeSlot: _selectedTimeSlot,
                  buttonState: _buttonState,
                );
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          child: availabilityData.isEmpty
              ? Text(
                  'No available time slots',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                )
              : _buildBookingSheet(),
        );
      },
    );
  }

  Widget _buildBookingSheet() {
    return Column(
      children: [
        _buildDatePicker(),
        const SizedBox(height: 20),
        _buildTimeSlots(),
        const SizedBox(height: 20),
        // MyButton(
        //   child: const Text("book Appointment"),
        //   onPressed: () => context.read<AppointmentBloc>().add(
        //         BookAppointmentEvent(
        //           Appointment(
        //             id: const Uuid().v1(),
        //             userId: widget.user!.id,
        //             customerName: widget.user!.name,
        //             customerEmail: widget.user!.email,
        //             customerImageURL: widget.user!.photoUrl,
        //             serviceId: '0',
        //             startTime: _selectedTimeSlot!.startTime,
        //             endTime: _selectedTimeSlot!.endTime,
        //             status: 'pending',
        //             createdAt: DateTime.now(),
        //             shopId: widget.shop.id,
        //             date: _selectedDate!,
        //           ),
        //         ),
        //       ),
        // ),
      ],
    );
  }

  Widget _buildDatePicker() {
    if (_firstDate == null) {
      return Center(
        child: Text(
          'Loading...',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
        ),
      );
    }
    return DateTimelinePicker(
      startDate: _firstDate ?? DateTime.now(),
      initialDate: _selectedDate ?? _firstDate ?? DateTime.now(),
      dates: availabilityData.keys.toList(),
      padding: 20,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      borderColor: Theme.of(context).colorScheme.secondary,
      showTodayButton: false,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
          _selectedTimeSlot = null;
          _buttonState = BookingButtonState.readyToBook;
          widget.onSelectionChange(
            selectedDate: _selectedDate,
            selectedTimeSlot: _selectedTimeSlot,
            buttonState: _buttonState,
          );
        });
      },
    );
  }

  Widget _buildTimeSlots() {
    List<TimeSlot> timeSlots = _getAvailableTimeSlots(_selectedDate);
    if (_selectedDate == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(
                'Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: availabilityData.isNotEmpty
              ? timeSlots.isEmpty
                  ? const Center(
                      child: Text(
                        'No available time slots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        TimeSlot slot = timeSlots[index];
                        bool isSelected = _selectedTimeSlot == slot;
                        return GestureDetector(
                          key: const Key('time_slot'),
                          onTap: () {
                            setState(() {
                              _selectedTimeSlot = slot;
                              _buttonState = BookingButtonState.readyToBook;
                              widget.onSelectionChange(
                                selectedDate: _selectedDate,
                                selectedTimeSlot: _selectedTimeSlot,
                                buttonState: _buttonState,
                              );
                            });
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('HH:mm').format(slot.startTime),
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  List<TimeSlot> _getAvailableTimeSlots(DateTime? date) {
    if (date != null && availabilityData.containsKey(date)) {
      return availabilityData[date]!.where((slot) => !slot.isBooked).toList();
    } else {
      return [];
    }
  }
}
