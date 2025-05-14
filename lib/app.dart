import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hands_test/core/utils/constants.dart';
import 'package:hands_test/core/utils/utils.dart';

import 'core/helper/binding.dart';
import 'features/authentication/presentation/login_screen.dart';
import 'features/interpreter/presentation/interpreter_home_view.dart';
import 'features/student/presentation/home_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    controller.setUserId();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      // home: const HomePage(),
      home: controller.mainScreen,
    );
  }
}

class Controller extends GetxController {
  final box = GetStorage();
  String get language => box.read('language') ?? 'En';
  String? get userId => box.read('userid');
  int? get person => box.read('person');

  void setUserId() {
    AppConstants.userId = userId;
  }

  Widget get mainScreen => userId == null
      ? LoginScreen()
      : person == Person.interpreter.index
          ? const InterpreterHomeView()
          : const HomeScreen();

  void changeLang(String val) => box.write('language', val);
}
