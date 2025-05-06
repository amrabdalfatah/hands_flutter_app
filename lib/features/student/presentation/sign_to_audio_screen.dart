import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// import 'package:flutter_mediapipe/gen/landmark.pb.dart' as media;

import '../controller/student_viewmodel.dart';

// class SignToAudioScreen extends GetWidget<StudentViewModel> {
//   const SignToAudioScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           GetBuilder<StudentViewModel>(
//             builder: (cont) {
//               return cont.loaded.value
//                   ? const Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : CameraPreview(controller.cameraController!);
//             },
//           ),
//           Positioned(
//             top: 40,
//             left: 20,
//             right: 20,
//             child: Obx(
//               () => Text(
//                 controller.result.value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   backgroundColor: Colors.black54,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SignToAudioScreen extends StatefulWidget {
  const SignToAudioScreen({super.key});

  @override
  State<SignToAudioScreen> createState() => _SignToAudioScreenState();
}

class _SignToAudioScreenState extends State<SignToAudioScreen> {
  var imageUrl = "";
  static const pickImageChannel = MethodChannel("pickImagePlatform");

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                try {
                  final String result =
                      await pickImageChannel.invokeMethod("pickImage");
                  setState(() {
                    imageUrl = result;
                  });
                } on PlatformException catch (e) {
                  debugPrint("Fail: ${e.message}");
                }
              },
              child: const Text("Pick Image"),
            ),
            imageUrl != ""
                ? SizedBox(
                    width: 400,
                    height: 400,
                    child: MyImageView(imageUrl: imageUrl),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

const myImageView = "myImageView";

class MyImageView extends StatefulWidget {
  final String imageUrl;

  const MyImageView({
    super.key,
    required this.imageUrl,
  });

  @override
  State<MyImageView> createState() => _MyImageViewState();
}

class _MyImageViewState extends State<MyImageView> {
  final Map<String, dynamic> creationParams = <String, dynamic>{};
  late Key _key;

  @override
  void initState() {
    super.initState();
    _key = UniqueKey();
    creationParams["imageUrl"] = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant MyImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      creationParams["imageUrl"] = widget.imageUrl;
      _key = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AndroidView(
            key: _key,
            viewType: myImageView,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          )
        : UiKitView(
            key: _key,
            viewType: myImageView,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          );
  }
}
