import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  const MainButton({super.key, required this.onTap, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 310,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1E88E5), // Bright Blue
                Color(0xFF64B5F6), // Light Blue
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child:  Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}