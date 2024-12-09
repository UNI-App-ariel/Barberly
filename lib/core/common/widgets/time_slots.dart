import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final TimeSlot? selectedSlot;
  final bool isRtl;
  final ValueChanged<TimeSlot> onTimeSlotSelected;
  final String noTimeSlotsText;
  final String title;

  const TimeSlotPicker({
    super.key,
    required this.timeSlots,
    required this.onTimeSlotSelected,
    this.selectedSlot,
    this.isRtl = false,
    this.noTimeSlotsText = 'No time slots available',
    this.title = 'Select a Time',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Text(
                title,
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
          child: timeSlots.isEmpty
              ? Center(
                  child: Text(
                    noTimeSlotsText,
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
                    final slot = timeSlots[index];
                    final isSelected = selectedSlot == slot;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTimeSlotSelected(slot);
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
