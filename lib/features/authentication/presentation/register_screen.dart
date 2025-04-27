import 'package:flutter/material.dart';
import 'interpreter_register_screen.dart';
import 'student_register_screen.dart';

import '../../../widgets/selection_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/HandsInWordsLogo.png',
                width: 320,
                height: 320,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              "Welcome !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please select one",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            // Student Button
            const SelectionButton(
              text: "Student",
              gradientColors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
              textColor: Colors.white,
              screen: StudentRegisterScreen(),
            ),
            const SizedBox(height: 15),
            // Interpreter Button
            const SelectionButton(
              text: "Interpreter",
              gradientColors: [Colors.white, Colors.white],
              textColor: Colors.blue,
              screen: InterpreterRegisterScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
