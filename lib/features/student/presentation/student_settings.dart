import 'package:flutter/material.dart';

class StudentSettings extends StatefulWidget {
  const StudentSettings({super.key});

  @override
  State<StudentSettings> createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  bool languageSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.language,
              color: Colors.blueAccent,
            ),
            title: const Text(
              "Language",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "EN",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Switch(
                  value: languageSelected,
                  onChanged: (val) {
                    setState(() {
                      languageSelected = val;
                    });
                  },
                ),
                const Text(
                  "AR",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
