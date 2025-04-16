import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            CircleAvatar(
              radius: 60,
              // backgroundImage: AssetImage(
              //     'assets/profile.jpg'), // Change to user's profile image
            ),
            const SizedBox(height: 15),
            // User Name
            const Text(
              "Dalal Otaibi", // Example name
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Email
            const Text(
              "dalal@example.com", // Example email
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // User Details
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blueAccent),
              title: Text("+965 123 45678"), // Example phone number
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.blueAccent),
              title: Text("Kuwait City, Kuwait"), // Example location
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.blueAccent),
              title: Text("Arabic, English"), // Example languages
            ),
            const Spacer(),
            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Edit Profile Page
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
