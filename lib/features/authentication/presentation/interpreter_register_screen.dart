import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/model/interpreter.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/utils.dart';

class InterpreterRegisterScreen extends StatefulWidget {
  const InterpreterRegisterScreen({super.key});
  @override
  _InterpreterRegisterScreen createState() => _InterpreterRegisterScreen();
}

class _InterpreterRegisterScreen extends State<InterpreterRegisterScreen> {
  bool process = false;
  // Text controllers
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
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

        final interpreter = Interpreter(
          id: user.user!.uid,
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          active: true,
        );

        await FirebaseFirestore.instance
            .collection("Interpreter")
            .doc(user.user!.uid)
            .set(interpreter.toJson());
        setState(() {
          process = false;
        });

        Get.snackbar(
          'Success',
          'Register Success',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.green,
        );
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
                child: Image.asset('assets/images/handsinwords_logo.png',
                    height: 300),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 310,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your full name",
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 310,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter email address",
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 310,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Password",
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 310,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              process
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                          //height: 40,
                          width: 310,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: const Color(0xFF45CECE),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () async {
                                await signUp();
                                Navigator.pushReplacementNamed(
                                    context, '/HomeScreen');
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already have an account ? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/LoginScreen');
                  },
                  child: const Text('Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 57, 171, 171),
                        fontSize: 16,
                      )),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
