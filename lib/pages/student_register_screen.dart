// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hands_test/core/utils/constants.dart';
import 'package:hands_test/core/utils/utils.dart';
import 'package:hands_test/pages/home_screen.dart';

import '../model/student.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  _StudentRegisterScreenState createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  bool process = false;
  // Text controllers
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _universityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _universityController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  // ✅ Updated signUp function with error handling and validation
  Future<void> signUp() async {
    setState(() {
      process = true;
    });
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showError("Email and password cannot be empty.");
      setState(() {
        process = false;
      });
      return;
    }

    if (!_emailController.text.contains("@")) {
      showError("Enter a valid email address.");
      setState(() {
        process = false;
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      showError("Password must be at least 6 characters long.");
      setState(() {
        process = false;
      });
      return;
    }

    try {
      if (passwordConfirmed()) {
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        AppConstants.userId = user.user!.uid;
        AppConstants.userName = _fullNameController.text;
        AppConstants.person = Person.student;
        final student = Student(
          id: user.user!.uid,
          fullName: _fullNameController.text,
          email: _emailController.text,
          university: _universityController.text,
          active: true,
        );

        await FirebaseFirestore.instance
            .collection("Students")
            .doc(user.user!.uid)
            .set(student.toJson());

        setState(() {
          process = false;
        });

        final box = GetStorage();
        box.write('userid', user.user!.uid);
        box.write('person', Person.student.index);

        Get.snackbar(
          "Success",
          "Register Student Success",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.green,
        );

        // ✅ Navigate to HomeScreen only after successful registration
        Get.offAll(() => const HomeScreen());
      } else {
        setState(() {
          process = false;
        });
        showError("Passwords do not match.");
      }
    } catch (e) {
      setState(() {
        process = false;
      });
      showError(e.toString());
    }
  }

  // Function to show error messages in a SnackBar
  void showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }

  // ✅ Password confirmation check
  bool passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmpasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBE8E6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                color: const Color(0xFFDBE8E6),
                child: Image.asset(
                  'assets/images/handsinwords_logo.png',
                  height: 300,
                ),
              ),
              Container(
                height: 50,
                width: 400,
                color: const Color(0xFFDBE8E6),
                child: const Text(
                  "Welcome To HandsInWords!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 68, 67, 67),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 400,
                color: const Color(0xFFDBE8E6),
                child: const Text(
                  "Let's get your task completed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 5, 5, 5),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Input Fields
              buildTextField(
                "Enter your full name",
                false,
                _fullNameController,
              ),
              const SizedBox(height: 15),
              buildTextField(
                "Enter email address",
                false,
                _emailController,
              ),
              const SizedBox(height: 15),
              buildTextField(
                "Enter Password",
                true,
                _passwordController,
              ),
              const SizedBox(height: 15),
              buildTextField(
                "Confirm Password",
                true,
                _confirmpasswordController,
              ),
              const SizedBox(height: 15),
              buildTextField(
                "Enter your University",
                false,
                _universityController,
              ),
              const SizedBox(height: 18),

              // ✅ Fixed Register Button with signUp function
              process
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: GestureDetector(
                        onTap: () async {
                          await signUp(); // Ensure registration completes before navigating
                        },
                        child: Container(
                          width: 310,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: const Color(0xFF45CECE),
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account ? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/LoginScreen');
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 57, 171, 171),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Extracted method to reduce code duplication for text fields
  Widget buildTextField(
      String hintText, bool obscureText, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: 310,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
