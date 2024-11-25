import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      // body: Center(
      //   child: StreamBuilder<User?>(
      //     stream: FirebaseAuth.instance
      //         .authStateChanges(), // Listen to auth state changes
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const CircularProgressIndicator(); // Show loading while waiting for auth state
      //       }

      //       final user = snapshot.data; // Get the current user

      //       if (user != null) {
      //         return _buildLoggedInView();
      //       } else {
      //         return _buildLoggedOutView(context);
      //       }
      //     },
      //   ),
      // ),
      body: _buildLoggedInView(context),
    );
  }

  Widget _buildLoggedInView(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 40,
            color: Colors.red,
          ),
          SizedBox(height: 10),
          Text(
            "There are no favorite shops.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
