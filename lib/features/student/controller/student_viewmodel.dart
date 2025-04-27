import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hands_test/app.dart';
import 'package:hands_test/core/services/firestore/firestore_student.dart';
import 'package:hands_test/core/utils/constants.dart';
import 'package:hands_test/model/student.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../presentation/home_view.dart';
import '../presentation/student_settings.dart';
import '../presentation/user_profile.dart';

class StudentViewModel extends GetxController {
  Student? studentData;

  List<Widget> screens = const [
    HomeView(),
    UserProfile(),
    StudentSettings(),
  ];

  List<String> appBars = const [
    'Home',
    'Profile',
    'Settings',
  ];

  RxBool action = false.obs;
  RxBool loaded = true.obs;
  ValueNotifier<int> screenIndex = ValueNotifier(0);
  CameraController? cameraController;
  late tfl.Interpreter interpreter;

  // Use RxString for reactive state management
  RxString result = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    getStudent();
  }

  signLanguage() async {
    await _initCamera();
    await _loadModel();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    interpreter.close();
    super.onClose();
  }

  Future<void> getStudent() async {
    loaded.value = false;
    await FirestoreStudent()
        .getCurrentStudent(AppConstants.userId!)
        .then((value) {
      studentData = Student.fromJson(value.data() as Map<String, dynamic>?);
    });
    loaded.value = true;
    update();
  }

  void changeScreen(int selected) {
    screenIndex.value = selected;
    update();
  }

  // Initialize the camera
  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    cameraController = CameraController(
      cameras[1],
      ResolutionPreset.high,
      // enableAudio: false,
    );
    await cameraController!.initialize();

    loaded.value = false;
    update(); // Update state in GetX
  }

  // Load the TensorFlow Lite model
  Future<void> _loadModel() async {
    try {
      interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');

      await cameraController!.startImageStream((CameraImage image) async {
        await runModelOnFrame(image);
      });
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  // Preprocess the image (resize, normalize, etc.)
  List<double> preprocessImage(img.Image image) {
    img.Image resized = img.copyResize(
      image,
      width: 224,
      height: 224,
    ); // Resize based on model input
    List<double> input = [];

    for (var y = 0; y < resized.height; y++) {
      for (var x = 0; x < resized.width; x++) {
        var pixel = resized.getPixel(x, y);
        input.add((pixel.r) / 255.0);
        input.add((pixel.g) / 255.0);
        input.add((pixel.b) / 255.0);
      }
    }

    return input;
  }

  String runInference(img.Image image) {
    List<double> input = preprocessImage(image);
    var inputTensor = [input];
    var output = List.generate(1194, (_) => List.filled(45, 0.0));
    interpreter.run(inputTensor, output);
    int bestIndex = 0;
    double maxVal = 0;

    for (int i = 0; i < output.length; i++) {
      double localMax = output[i].reduce((a, b) => a > b ? a : b);
      if (localMax > maxVal) {
        maxVal = localMax;
        bestIndex = i;
      }
    }
    int labelIndex = bestIndex;
    result.value = _getLabel(labelIndex);
    update();

    return output[0][0].toString(); // Adjust based on model output
  }

  // new runModel
  Future<void> runModelOnFrame(CameraImage image) async {
    if (!cameraController!.value.isStreamingImages) return;
    img.Image imageNew =
        convertCameraImage(image, targetWidth: 224, targetHeight: 224);
    final result = runInference(imageNew);
  }

  // Convert
  img.Image convertCameraImage(
    CameraImage image, {
    int targetWidth = 224,
    int targetHeight = 224,
  }) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imageRGB = img.Image(width: width, height: height);

    final Uint8List y = image.planes[0].bytes;
    final Uint8List u = image.planes[1].bytes;
    final Uint8List v = image.planes[2].bytes;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        final int yIndex = row * width + col;

        final int uvIndex =
            (row ~/ 2) * uvRowStride + (col ~/ 2) * uvPixelStride;
        final int yVal = y[yIndex];
        final int uVal = u[uvIndex];
        final int vVal = v[uvIndex];

        final double r = yVal + 1.402 * (vVal - 128);
        final double g =
            yVal - 0.344136 * (uVal - 128) - 0.714136 * (vVal - 128);
        final double b = yVal + 1.772 * (uVal - 128);
        imageRGB.setPixelRgb(col, row, r.clamp(0, 255).toInt(),
            g.clamp(0, 255).toInt(), b.clamp(0, 255).toInt());
      }
    }

    // Resize for model input
    final img.Image resized =
        img.copyResize(imageRGB, width: targetWidth, height: targetHeight);
    return resized;
  }

  // Map the model output to readable text
  String _getLabel(int index) {
    print('///////////////');
    print(index);
    Map<int, String> labels = {
      848: "انا",
      1: "جيد",
      2: "الكويت",
      3: "مستشفى",
      4: "اهلا",
      5: "اهلا وسهلا",
      6: "بك",
      7: "في",
    };

    return labels[index] ?? "غير معروف";
  }

  // Sign out the user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    final box = GetStorage();
    box.remove('userid');
    box.remove('person');
    Get.offAll(() => Controller().mainScreen);
  }
}
