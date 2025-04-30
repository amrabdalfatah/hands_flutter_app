import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hands_test/app.dart';
import 'package:hands_test/core/services/firestore/firestore_interpreter.dart';
import 'package:hands_test/core/utils/constants.dart';
import 'package:hands_test/features/interpreter/presentation/interpreter_screen.dart';
import 'package:hands_test/model/interpreter.dart';

import '../presentation/interpreter_profile.dart';

class InterpreterViewModel extends GetxController {
  Interpreter? interpreterData;

  List<Widget> screens = const [
    InterpreterScreen(),
    InterpreterProfile(),
  ];

  List<String> appBars = const [
    'Home',
    'Profile',
  ];

  RxBool action = false.obs;
  RxBool loaded = true.obs;
  ValueNotifier<int> screenIndex = ValueNotifier(0);

  @override
  void onInit() async {
    super.onInit();
    getInterpreter();
    // await initializeAgora();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> setActiveStatus(bool isActive) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Interpreter')
          .doc(user.uid)
          .update({
        'active': isActive,
      });
    }
  }

  Future<void> getInterpreter() async {
    loaded.value = false;
    await setActiveStatus(true);
    await FirestoreInterpreter()
        .getCurrentInterpreter(AppConstants.userId!)
        .then((value) {
      interpreterData =
          Interpreter.fromJson(value.data() as Map<String, dynamic>?);
    });
    loaded.value = true;
    update();
  }

  void changeScreen(int selected) {
    screenIndex.value = selected;
    update();
  }

  // Sign out the user
  void signOut() async {
    await setActiveStatus(false);
    await FirebaseAuth.instance.signOut();
    final box = GetStorage();
    box.remove('userid');
    box.remove('person');
    Get.offAll(() => Controller().mainScreen);
  }
}
