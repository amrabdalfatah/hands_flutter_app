import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/core/view_model/auth_viewmodel.dart';
import 'package:hands_test/pages/splash_screen.dart';
import 'package:hands_test/widgets/input_field.dart';
import 'package:hands_test/widgets/main_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthViewModel());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/HandsInWordsLogo.png',
                  width: 320, // Logo size
                  height: 320, // Logo size
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 35),
              InputField(
                  isPassword: false,
                  hint: "Enter email address",
                  controller: controller),
              const SizedBox(height: 15),
              InputField(
                  isPassword: true,
                  hint: "Enter Password",
                  controller: controller),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 5.0,
                ),
                child: Container(
                  width: 290,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GetX<AuthViewModel>(
                builder: (process) {
                  return process.action.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MainButton(
                          onTap: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              controller.signInWithEmailAndPassword();
                            }
                          },
                          text: 'Login',
                        );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.offAll(() => SplashScreen());
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
