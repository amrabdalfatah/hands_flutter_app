import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/Home_screen_drawer.dart';
import '../pages/audio_to_text_Screen.dart';
import '../pages/emergency_session_screen.dart';
import '../pages/login_screen.dart';
import '../pages/saved_lectures_screen.dart';
import '../pages/sign_to_audio_screen.dart';
import '../pages/student_settings.dart';
import '../pages/user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  int _selectedIndex = 0; // Track selected index for bottom navigation

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Define navigation for each tab
    switch (index) {
      case 0:
        // Stay on the HomeScreen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentSettings()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the user is null, redirect to login screen
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      });
      return const Scaffold(
          body:
              Center(child: CircularProgressIndicator())); // Temporary loading
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex, // Highlights the selected icon
        onTap: _onItemTapped, // Calls the function when tapped
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
        iconTheme: const IconThemeData(
            color: Colors.black), // Ensure menu icon is visible
        centerTitle: true, // Centers the title
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16), // Moves notification icon further right
            child: Transform.translate(
              offset: const Offset(0, 10), // Moves the icon downward
              child: IconButton(
                icon: const Icon(Icons.notifications,
                    color: Color.fromARGB(255, 100, 97, 97)),
                iconSize: 30,
                onPressed: () {
                  // TODO: Handle notification action
                },
              ),
            ),
          ),
        ],
      ),
      drawer: const HomeScreenDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Row (Align Left)
            Row(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 48, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Greeting Text with Styled User Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Hello, ", // Static "Hello" text
                      style: TextStyle(
                        fontSize: 28, // Bigger font
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Keep black for contrast
                      ),
                    ),
                    TextSpan(
                      text: user?.email ?? "User", // User's email or fallback
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
                    onTap: () => _navigateTo(context, SignToAudioScreen()),
                  ),
                  GradientCard(
                    title: "Saved Lectures",
                    icon: Icons.save,
                    startColor: const Color.fromARGB(255, 242, 154, 23),
                    endColor: const Color.fromARGB(255, 249, 182, 25),
                    onTap: () => _navigateTo(context, SavedLecturesScreen()),
                  ),
                  GradientCard(
                    title: "Audio to Text",
                    icon: Icons.mic,
                    startColor: const Color.fromARGB(255, 93, 68, 255),
                    endColor: Colors.blue,
                    onTap: () => _navigateTo(context, AudioToTextScreen()),
                  ),
                  GradientCard(
                    title: "Emergency Session",
                    icon: Icons.warning,
                    startColor: Colors.redAccent,
                    endColor: Colors.deepOrangeAccent,
                    onTap: () => _navigateTo(context, EmergencySessionScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
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
    Key? key,
    required this.title,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  }) : super(key: key);

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
