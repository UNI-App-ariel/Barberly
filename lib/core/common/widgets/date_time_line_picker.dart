import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DateTimelinePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected; // Callback for selected date
  final DateTime startDate;
  final DateTime initialDate;
  final int? numberOfDays; // Number of days to show in the timeline
  final double padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool? showTodayButton;
  final List<DateTime>? dates;
  const DateTimelinePicker({
    super.key,
    required this.startDate,
    required this.initialDate,
    required this.onDateSelected,
    this.numberOfDays = 7,
    this.padding = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.showTodayButton = true,
    this.dates,
  });

  @override
  State<DateTimelinePicker> createState() => _DateTimelinePickerState();
}

class _DateTimelinePickerState extends State<DateTimelinePicker> {
  late DateTime _selectedDate;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.startDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display selected date at the top
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.padding + 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate), // Full date
                    style: TextStyle(
                      color: widget.foregroundColor ??
                          Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.showTodayButton ?? true,
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _selectToday();
                  },
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        // Date picker timeline
        SizedBox(
          height: 90,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(
              left: widget.padding,
            ),
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            itemCount: widget.dates?.length ?? widget.numberOfDays,
            itemBuilder: (context, index) {
              DateTime date = widget.dates?[index] ??
                  widget.startDate.add(Duration(days: index));
              return GestureDetector(
                key: const Key('date_picker'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedDate = date;
                    widget.onDateSelected(_selectedDate); // Notify parent
                  });
                },
                child: Container(
                  width: 60, // Adjust width based on design preference
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: DateUtils.isSameDay(date, _selectedDate)
                        ? Theme.of(context).colorScheme.primary
                        : widget.backgroundColor ??
                            Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _getBorderColor(date),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // month
                      Text(
                        DateFormat('MMM').format(date), // Abbreviated month
                        style: TextStyle(
                          color: DateUtils.isSameDay(date, _selectedDate)
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withValues(alpha:  0.5)
                              : widget.foregroundColor ??
                                  Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // day of the month
                      Text(
                        DateFormat('dd').format(date), // Day of the month
                        style: TextStyle(
                          color: DateUtils.isSameDay(date, _selectedDate)
                              ? Theme.of(context).colorScheme.onPrimary
                              : widget.foregroundColor ??
                                  Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 5),
                      // day of the week
                      Text(
                        DateFormat('EEE')
                            .format(date), // Abbreviated weekday (e.g., Mon)
                        style: TextStyle(
                          color: DateUtils.isSameDay(date, _selectedDate)
                              ? Theme.of(context).colorScheme.onPrimary
                              : widget.foregroundColor ??
                                  Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectToday() {
    setState(() {
      _selectedDate = DateTime.now();
      widget.onDateSelected(_selectedDate); // Notify parent
    });

    // Scroll to the very start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    });
  }

  Color _getBorderColor(DateTime date) {
    if (DateUtils.isSameDay(date, DateTime.now())) {
      return Theme.of(context).colorScheme.primary;
    } else if (DateUtils.isSameDay(date, _selectedDate)) {
      return Colors.transparent;
    } else {
      return widget.borderColor ?? Theme.of(context).colorScheme.secondary;
    }
  }
}
