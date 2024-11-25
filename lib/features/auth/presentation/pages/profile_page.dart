import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: user?.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          user!.photoURL!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                user?.displayName ?? "Guest User",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                user?.email ?? "No email provided",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Edit Profile"),
              onTap: () {
                // Implement edit profile functionality here
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log Out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login', // Update to your login page route
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}