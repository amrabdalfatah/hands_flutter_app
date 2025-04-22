import 'package:get/get.dart';
import 'package:hands_test/core/view_model/student_viewmodel.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentViewModel());
  }
}
