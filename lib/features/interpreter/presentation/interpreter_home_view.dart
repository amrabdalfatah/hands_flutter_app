import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/features/interpreter/controller/interpreter_viewmodel.dart';

class InterpreterHomeView extends StatelessWidget {
  const InterpreterHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterpreterViewModel>(
      init: InterpreterViewModel(),
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
                ),
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
