import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/features/student/controller/student_viewmodel.dart';

import 'Home_screen_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentViewModel>(
      init: StudentViewModel(),
      builder: (controller) {
        return controller.loaded.value
            ? Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  currentIndex: controller
                      .screenIndex.value, // Highlights the selected icon
                  onTap:
                      controller.changeScreen, // Calls the function when tapped
                  items: const [
                    // Home item
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    // Profile
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_2),
                      label: 'Profile',
                    ),
                    // Settings
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(controller.appBars[controller.screenIndex.value]),
                  iconTheme: const IconThemeData(
                    color: Colors.black,
                  ), // Ensure menu icon is visible
                  centerTitle: true, // Centers the title
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 100, 97, 97),
                      ),
                      iconSize: 30,
                      onPressed: () {
                        // TODO: Handle notification action
                      },
                    ),
                  ],
                ),
                drawer: const HomeScreenDrawer(),
                body: controller.screens[controller.screenIndex.value],
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
