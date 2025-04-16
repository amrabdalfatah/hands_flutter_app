import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../core/view_model/student_viewmodel.dart';

class SignToAudioScreen extends GetWidget<StudentViewModel> {
  const SignToAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentViewModel>(
      init: StudentViewModel(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              GetBuilder<StudentViewModel>(builder: (cont) {
                return cont.loaded.value ? Center(
                  child: CircularProgressIndicator(),
                ): CameraPreview(controller.cameraController!);
              },),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Obx(
                  () => Text(
                    controller.result.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
