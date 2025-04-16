import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required void Function() showLoginPage});

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

            // Centered Logo
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
            _buildSelectionButton(
              context,
              "Student",
              [Color(0xFF1E88E5), Color(0xFF64B5F6)],
              Colors.white,
              '/StudentRegisterScreen',
            ),

            const SizedBox(height: 15),

            // Interpreter Button
            _buildSelectionButton(
              context,
              "Interpreter",
              [Colors.white, Colors.white],
              Colors.blue,
              '/InterpreterRegisterScreen',
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Button with Gradient
  static Widget _buildSelectionButton(BuildContext context, String text,
      List<Color> gradientColors, Color textColor, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
