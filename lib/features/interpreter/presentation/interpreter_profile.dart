import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/features/interpreter/controller/interpreter_viewmodel.dart';

class InterpreterProfile extends GetWidget<InterpreterViewModel> {
  const InterpreterProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("User Profile"),
      //   centerTitle: true,
      //   backgroundColor: Colors.blueAccent,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            const CircleAvatar(
              radius: 60,
              // backgroundImage: AssetImage(
              //     'assets/profile.jpg'), // Change to user's profile image
            ),
            const SizedBox(height: 15),
            Text(
              "${controller.interpreterData!.fullName}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${controller.interpreterData!.email}", // Example email
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(
                Icons.phone,
                color: Colors.blueAccent,
              ),
              title: Text(
                "+965 123 45678",
              ), // Example phone number
            ),
            const ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.blueAccent,
              ),
              title: Text(
                "Kuwait City, Kuwait",
              ), // Example location
            ),
            const ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.blueAccent,
              ),
              title: Text(
                "Arabic, English",
              ), // Example languages
            ),
            const Spacer(),
            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.signOut();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
