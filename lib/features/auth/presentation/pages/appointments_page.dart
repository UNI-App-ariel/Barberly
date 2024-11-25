import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance
              .authStateChanges(), // Listen to auth state changes
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while waiting for auth state
            }

            final user = snapshot.data; // Get the current user

            if (user != null) {
              return _buildLoggedInView();
            } else {
              return _buildLoggedOutView(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoggedInView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today,
          size: 80,
          color: Colors.grey,
        ),
        SizedBox(height: 20),
        Text(
          "You have no upcoming appointments.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Log in to view your appointments",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Update route as needed
          },
          child: const Text(
            "Login/Signup",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
