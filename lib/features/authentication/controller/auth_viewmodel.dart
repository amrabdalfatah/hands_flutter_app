import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hands_test/core/services/firestore/firestore_interpreter.dart';
import 'package:hands_test/core/services/firestore/firestore_student.dart';
import 'package:hands_test/core/utils/constants.dart';
import 'package:hands_test/core/utils/utils.dart';
import 'package:hands_test/features/interpreter/presentation/interpreter_home_view.dart';
import 'package:hands_test/features/student/presentation/home_screen.dart';
import 'package:hands_test/model/interpreter.dart';
import 'package:hands_test/model/student.dart';

class AuthViewModel extends GetxController {
  late final FirebaseAuth _auth;
  late RxBool shownPassword;
  late RxBool action;
  String email = '', password = '';

  @override
  void onInit() {
    super.onInit();
    _auth = FirebaseAuth.instance;
    shownPassword = true.obs;
    action = false.obs;
  }

  void changeShownPassword() {
    shownPassword.value = !shownPassword.value;
  }

  void signInWithEmailAndPassword() async {
    action.value = true;
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        final box = GetStorage();
        box.write('userid', value.user!.uid);
        if (await FirestoreInterpreter().checkInterpreter(value.user!.uid)) {
          AppConstants.person = Person.interpreter;
          box.write('person', Person.interpreter.index);
          AppConstants.userId = value.user!.uid;
          Interpreter? interpreterData;
          await FirestoreInterpreter()
              .getCurrentInterpreter(value.user!.uid)
              .then((value) {
            interpreterData =
                Interpreter.fromJson(value.data() as Map<String, dynamic>?);
            AppConstants.userName = '${interpreterData!.fullName}';
          });
          action.value = false;
          update();
          Get.offAll(() => const InterpreterHomeView());
        } else {
          AppConstants.person = Person.student;
          box.write('person', Person.student.index);
          AppConstants.userId = value.user!.uid;
          Student? studentData;
          await FirestoreStudent()
              .getCurrentStudent(value.user!.uid)
              .then((value) {
            studentData =
                Student.fromJson(value.data() as Map<String, dynamic>?);
            AppConstants.userName = '${studentData!.fullName}';
          });
          action.value = false;
          update();
          Get.offAll(() => const HomeScreen());
        }
      });
    } catch (e) {
      action.value = false;
      update();
      Get.snackbar(
        'Error Login',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }
}
