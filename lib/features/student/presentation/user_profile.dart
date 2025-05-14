import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/student_viewmodel.dart';

class UserProfile extends GetWidget<StudentViewModel> {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            const CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                "assets/images/HandsInWordsLogo.png",
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
              title: Text(
                "${controller.studentData!.fullName}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ), // Example phone number
            ),
            ListTile(
              leading: const Icon(
                Icons.email,
                color: Colors.blueAccent,
              ),
              title: Text(
                "${controller.studentData!.email}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ), // Example location
            ),
            const ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.blueAccent,
              ),
              title: Text(
                "English",
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
                  backgroundColor: Colors.redAccent,
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
