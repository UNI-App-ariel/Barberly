import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
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
  late bool isRtl;

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
            showErrorSnackBar(context, state.message);
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
              showMyBottomSheet(
                context: context,
                isPage: true,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                child: SuccessBottomSheet(
                  appointment: state.appointment,
                  shop: widget.shop,
                ),
              );
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
                "No availability",
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
        // const Spacer(),
        // Visibility(
        //   visible: _getBookButtonVisibility(),
        //   child: BookingButton(
        //     selectedDate: _selectedDate,
        //     selectedTime: _selectedTimeSlot?.startTime,
        //     onPressed: () => _bookAppointment(context),
        //     state: _buttonState,
        //   ),
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
      backgroundColor: Colors.amberAccent
      foregroundColor: Colors.white,
      borderColor: Colors.amberAccent,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(
                S.of(context).bookingSheetPicker_time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
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
                  ? Center(
                      child: Text(
                        S.of(context).bookingSheet_noTimeSlotsAvailable,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: isRtl ? 0 : 20,
                        right: isRtl ? 20 : 0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        TimeSlot slot = timeSlots[index];
                        bool isSelected = _selectedTimeSlot == slot;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
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
                                  : AppColors.onDarkBackground,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                MyDateFormat('HH:mm').format(slot.startTime),
                                style: const TextStyle(
                                  color: Colors.white,
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