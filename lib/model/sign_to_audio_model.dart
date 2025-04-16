// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
//
// class SignToAudioModel {
//   late Interpreter _interpreter;
//
//   Future<void> loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//       print('////////////////////////////');
//       print('////////////////////////////');
//       print('Model loaded successfully');
//     } catch (e) {
//       print('Failed to load model: $e');
//     }
//   }
//
//   // Preprocess the image (resize, normalize, etc.)
//   List<double> preprocessImage(img.Image image) {
//     img.Image resized = img.copyResize(image,
//         width: 224, height: 224); // Resize based on model input
//     List<double> input = [];
//
//     for (var y = 0; y < resized.height; y++) {
//       for (var x = 0; x < resized.width; x++) {
//         var pixel = resized.getPixel(x, y);
//         input.add((pixel.r) / 255.0);
//         input.add((pixel.g) / 255.0);
//         input.add((pixel.b) / 255.0);
//       }
//     }
//
//     return input;
//   }
//
//   String runInference(img.Image image) {
//     List<double> input = preprocessImage(image);
//     var inputTensor = [input];
//     var output = List.filled(1, 0).reshape([1, 1]);
//
//     _interpreter.run(inputTensor, output);
//
//     return output[0][0].toString(); // Adjust based on model output
//   }
// }
