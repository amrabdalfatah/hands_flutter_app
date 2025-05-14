import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/model/interpreter.dart';

import 'call_screen.dart';

class EmergencySessionScreen extends StatefulWidget {
  const EmergencySessionScreen({super.key});

  @override
  State<EmergencySessionScreen> createState() => _EmergencySessionScreenState();
}

class _EmergencySessionScreenState extends State<EmergencySessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Emergency Session"),
        backgroundColor: Colors.white, // this is a basic comment
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Interpreter')
            .where('active', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final interpreters = snapshot.data!.docs;
          return interpreters.isEmpty
              ? const Center(
                  child: Text("No Interpreter available now"),
                )
              : ListView.builder(
                  itemCount: interpreters.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    var user = Interpreter.fromJson(interpreters[index].data());
                    return Card(
                      child: ListTile(
                        title: Text(
                          user.fullName!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(user.id!),
                        trailing: const Icon(
                          Icons.video_call,
                          color: Colors.green,
                        ),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("Interpreter")
                              .doc(user.id)
                              .update({
                            "request_call": true,
                          });
                          Get.to(() => const CallScreen());
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
