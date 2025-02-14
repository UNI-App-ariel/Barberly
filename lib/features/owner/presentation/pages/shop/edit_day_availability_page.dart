import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/statemangment/bloc/shop_availability/shop_availability_bloc.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';
import 'package:uni_app/core/utils/my_utils.dart';

class EditDayAvailabilityPage extends StatefulWidget {
  final Barbershop shop;
  final int day;
  final List<TimeSlot>? defaultAvailability;
  final Availability availability;

  const EditDayAvailabilityPage({
    super.key,
    required this.shop,
    required this.day,
    this.defaultAvailability,
    required this.availability,
  });

  @override
  State<EditDayAvailabilityPage> createState() =>
      _EditDayAvailabilityPageState();
}

class _EditDayAvailabilityPageState extends State<EditDayAvailabilityPage>
    with SingleTickerProviderStateMixin {
  DateTime? _startTime;
  DateTime? _endTime;

  // Keep copies of the initial times to compare later.
  DateTime? _initialStartTime;
  DateTime? _initialEndTime;

  bool _showStartTimePicker = false;
  bool _showEndTimePicker = false;

  @override
  void initState() {
    super.initState();
    // Sort availability if provided.
    widget.defaultAvailability?.sort((a, b) => a.compareTo(b));
    // If availability exists, use its start and end times; otherwise, they remain null.
    _initialStartTime = widget.defaultAvailability?.firstOrNull?.startTime;
    _initialEndTime = widget.defaultAvailability?.lastOrNull?.endTime;
    _startTime = _initialStartTime;
    _endTime = _initialEndTime;
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final onSecondaryColor = Theme.of(context).colorScheme.onSecondary;

    // Determine if any changes have been made.
    bool hasChanges =
        (_startTime != _initialStartTime) || (_endTime != _initialEndTime);

    return BlocListener<ShopAvailabilityBloc, ShopAvailabilityState>(
      listener: (context, state) {
        if (state is ShopAvailabilityLoaded) {
          MyUtils.showSnackBar(context, 'Availability updated successfully.');
          Navigator.pop(context);
        } else if (state is ShopAvailabilityError) {
          MyUtils.showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(MyDateUtils.getDayName(widget.day)),
          actions: [
            CupertinoButton(
              onPressed: hasChanges
                  ? () {
                      _saveAvailability(context);
                    }
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
        body: Column(
          children: [
            CupertinoFormSection.insetGrouped(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              footer: widget.defaultAvailability == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'No availability set for this day.',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : null,
              children: [
                // Inline Start Time Picker Row
                InlineTimePickerRow(
                  label: 'Start Time',
                  time: _startTime,
                  expanded: _showStartTimePicker,
                  onTap: () {
                    setState(() {
                      _showStartTimePicker = !_showStartTimePicker;
                      if (_showStartTimePicker) _showEndTimePicker = false;
                    });
                  },
                  onTimeChanged: (newTime) {
                    setState(() {
                      _startTime = newTime;
                    });
                  },
                  color: secondaryColor,
                  textColor: onSecondaryColor,
                ),
                // Inline End Time Picker Row
                InlineTimePickerRow(
                  label: 'End Time',
                  time: _endTime,
                  expanded: _showEndTimePicker,
                  onTap: () {
                    setState(() {
                      _showEndTimePicker = !_showEndTimePicker;
                      if (_showEndTimePicker) _showStartTimePicker = false;
                    });
                  },
                  onTimeChanged: (newTime) {
                    setState(() {
                      _endTime = newTime;
                    });
                  },
                  color: secondaryColor,
                  textColor: onSecondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveAvailability(BuildContext context) {
    // Check if the start time is before the end time
    if (_startTime != null &&
        _endTime != null &&
        _startTime!.isAfter(_endTime!)) {
      MyUtils.showErrorSnackBar(context, 'Start time must be before end time.');
      return;
    }

    // create time slots with 30 minutes interval
    List<TimeSlot> timeSlots = [];
    for (DateTime time = _startTime!;
        time.isBefore(_endTime!);
        time = time.add(const Duration(minutes: 30))) {
      timeSlots.add(
        TimeSlot(
          startTime: time,
          endTime: time.add(const Duration(minutes: 30)),
        ),
      );
    }

    final newDefaultAvailability = widget.availability.defaultTimeSlots;

    newDefaultAvailability[widget.day] = timeSlots;

    // update the default time slots for the day in the availability object
    final newAvailability = widget.availability.copyWith(
      defaultTimeSlots: newDefaultAvailability,
    );

    // update the availability object in the database
    context.read<ShopAvailabilityBloc>().add(
          UpdateAvailabilityEvent(newAvailability),
        );
  }
}

/// A reusable widget that shows an inline time picker row similar to Apple Calendar.
/// When tapped, it expands or collapses a CupertinoDatePicker inline.
class InlineTimePickerRow extends StatelessWidget {
  final String label;
  final DateTime? time;
  final bool expanded;
  final VoidCallback onTap;
  final ValueChanged<DateTime> onTimeChanged;
  final Color color;
  final Color textColor;

  const InlineTimePickerRow({
    super.key,
    required this.label,
    required this.time,
    required this.expanded,
    required this.onTap,
    required this.onTimeChanged,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CupertinoFormRow(
        prefix: Text(label),
        helper: Center(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: expanded
                ? SizedBox(
                    height: 216,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: time,
                      onDateTimeChanged: onTimeChanged,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        child: Container(
          width: 65,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            time != null ? MyDateUtils.toTime(time!) : 'Select',
            style: TextStyle(
              color: expanded ? Colors.red : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
