import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/core/view_model/student_viewmodel.dart';
import 'package:hands_test/pages/audio_to_text_screen.dart';
import 'package:hands_test/pages/emergency_session_screen.dart';
import 'package:hands_test/pages/saved_lectures_screen.dart';
import 'package:hands_test/pages/sign_to_audio_screen.dart';

class HomeView extends GetWidget<StudentViewModel> {
  const HomeView({super.key});

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
                        .studentData!.fullName, // User's email or fallback
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
          const Center(
            child: Text(
              "Choose a service to get started!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 62, 61, 61),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // 🔹 New GradientCard UI replacing the old ListView
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Two cards per row
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                GradientCard(
                  title: "Sign Language to Audio",
                  icon: Icons.front_hand,
                  startColor: Colors.teal,
                  endColor: Colors.green,
                  onTap: () {
                    Get.to(() => const SignToAudioScreen());
                  },
                ),
                GradientCard(
                  title: "Saved Lectures",
                  icon: Icons.save,
                  startColor: const Color.fromARGB(255, 242, 154, 23),
                  endColor: const Color.fromARGB(255, 249, 182, 25),
                  onTap: () => Get.to(() => const SavedLecturesScreen()),
                ),
                GradientCard(
                  title: "Audio to Text",
                  icon: Icons.mic,
                  startColor: const Color.fromARGB(255, 93, 68, 255),
                  endColor: Colors.blue,
                  onTap: () => Get.to(() => const AudioToTextScreen()),
                ),
                GradientCard(
                  title: "Emergency Session",
                  icon: Icons.warning,
                  startColor: Colors.redAccent,
                  endColor: Colors.deepOrangeAccent,
                  onTap: () => Get.to(() => const EmergencySessionScreen()),
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
    return GestureDetector(
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
            // 🔹 Semi-transparent circles, placed precisely at the top-right corner
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

            // 🔹 Card Content (Centered)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 38),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
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
