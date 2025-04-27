import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreenDrawer extends StatelessWidget {
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
              FirebaseAuth.instance.signOut();
              Navigator.pop(context); // Close the drawer after logging out
            },
          ),
        ],
      ),
    );
  }
}
