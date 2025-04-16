import 'package:flutter/material.dart';

class SavedLecturesScreen extends StatelessWidget {
  const SavedLecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Saved Lectures"),
        backgroundColor:  Colors.white,
      ),
      body: const Center(
        child: Text(
          "Saved Lectures Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}