
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
                  itemBuilder: (context, index) {
                    var user = Interpreter.fromJson(interpreters[index].data());
                    return Card(
                      child: ListTile(
                        title: Text(user.fullName!),
                        subtitle: Text(user.id!),
                        trailing: const Icon(
                          Icons.online_prediction,
                          color: Colors.green,
                        ),
                        onTap: () {
                          
                          Get.to(() => CallScreen());
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
