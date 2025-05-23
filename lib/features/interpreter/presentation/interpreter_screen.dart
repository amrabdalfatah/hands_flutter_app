import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/features/interpreter/controller/interpreter_viewmodel.dart';
import 'package:hands_test/features/interpreter/presentation/call_screen.dart';

class InterpreterScreen extends GetWidget<InterpreterViewModel> {
  const InterpreterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Hello, ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: controller
                        .interpreterData!.fullName, // User's email or fallback
                    style: const TextStyle(
                      fontSize: 24, // Same size for consistency
                      fontWeight: FontWeight.w400,
                      color: Color(
                          0xFF236868), // Different color (Teal) for distinction
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Two cards per row
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Interpreter')
                      .where('request_call', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Get.snackbar(
                        "Request",
                        "Student sent to you request for call",
                        colorText: Colors.green,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 4),
                      );
                    }
                    final interpreters = snapshot.data!.docs;
                    return interpreters.isEmpty
                        ? GradientCard(
                            title: "Emergency \nSession",
                            icon: Icons.warning,
                            startColor: Colors.redAccent,
                            endColor: Colors.deepOrangeAccent,
                            onTap: () {},
                          )
                        : GradientCard(
                            title: "Emergency \nSession",
                            icon: Icons.warning,
                            startColor: Colors.redAccent,
                            endColor: Colors.deepOrangeAccent,
                            onTap: () => Get.to(() => const CallScreen()),
                          );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ GradientCard Widget
class GradientCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  const GradientCard({
    super.key,
    required this.title,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -10,
              child: _buildGrayCircle(100), // Larger main circle
            ),
            Positioned(
              top: 8,
              left: 120,
              child: _buildGrayCircle(95), // Smaller overlapping circle
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Function to Create Soft Gray Circles
  Widget _buildGrayCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20), // More subtle transparency
        shape: BoxShape.circle,
      ),
    );
  }
}
