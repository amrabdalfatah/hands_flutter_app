import 'package:get/get.dart';
import 'package:hands_test/features/student/controller/student_viewmodel.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentViewModel());
  }
}
