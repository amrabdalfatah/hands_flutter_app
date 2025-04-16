import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/core/view_model/auth_viewmodel.dart';

class InputField extends StatelessWidget {
  final bool isPassword;
  final String hint;
  final AuthViewModel controller;
  const InputField({super.key, required this.isPassword, required this.hint, required this.controller,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: 310,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: isPassword ? GetX<AuthViewModel> (
            builder: (authCtrl) {
              return TextFormField(
                keyboardType: TextInputType.visiblePassword,
          
            obscureText: authCtrl.shownPassword.value,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              suffixIcon: IconButton(onPressed: () {
                controller.changeShownPassword();
              }, icon: Icon(
                controller.shownPassword.value ? 
                Icons.visibility : Icons.visibility_off,
              ),),
            ),
            onSaved: (value) {
              controller.password = value!;
            },
            validator: (value) {
              if(controller.password.isEmpty) {
                return 'Please, Enter Your Password';
              } else if (controller.password.length < 6) {
                return 'Your Password is not valid';
              }
              return null;
            },
          );
            },
          ) : TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
            onSaved: (value) {
              controller.email = value!;
            },
            validator: (value) {
              final regex = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
              if(controller.email.isEmpty) {
                return 'Please, Enter Your Email';
              } else if (!regex.hasMatch(value!)) {
                return 'Your Email is not valid';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}