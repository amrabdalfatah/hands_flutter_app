import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/features/student/controller/student_viewmodel.dart';

class HomeScreenDrawer extends GetWidget<StudentViewModel> {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header with Logo
          DrawerHeader(
            child: Center(
              child: Image.asset(
                'assets/images/HandsInWordsLogo.png',
                width: 250,
                height: 250,
              ),
            ),
          ),
          // Logout Option
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // Adjust padding
            leading: const Icon(Icons.logout,
                color: Colors.black), // Black logout icon
            title: const Text(
              "LOGOUT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            onTap: () {
              controller.signOut();
            },
          ),
        ],
      ),
    );
  }
}
