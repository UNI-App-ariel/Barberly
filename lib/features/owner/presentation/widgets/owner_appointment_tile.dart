import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/utils/my_date_utils.dart';

class OwnerAppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const OwnerAppointmentTile({
    super.key,
    required this.appointment,
  });

  // Function to fetch user data by userId
  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(
              'users') // Replace with your actual Firestore collection name
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data()!; // Return user details as a map
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUser(appointment.userId), // Fetch user details dynamically
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('No user data found'),
          );
        }

        final userData = snapshot.data!;
        final customerName = userData['name'] ?? 'Unknown';
        final email = userData['email'] ?? 'N/A';
        final status = appointment.status;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    customerName.substring(0, 2).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Appointment Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Name and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Service Provider
                    Row(
                      children: [
                        Icon(Icons.store,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          customerName, // Replace with actual provider name if available
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Date and Time
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          MyDateUtils.toTime(appointment.startTime).toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Phone Number
                    Row(
                      children: [
                        Icon(Icons.email,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          email,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
