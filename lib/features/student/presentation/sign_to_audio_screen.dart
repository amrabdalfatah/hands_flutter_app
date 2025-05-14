import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignToAudioScreen extends StatefulWidget {
  const SignToAudioScreen({super.key});

  @override
  State<SignToAudioScreen> createState() => _SignToAudioScreenState();
}

class _SignToAudioScreenState extends State<SignToAudioScreen> {
  // static const _eventChannel = EventChannel("signLanguageToAudio");
  static const _channel = MethodChannel("cameraControl");

  String _status = "Press the button to start camera";

  // StreamSubscription? _subscription;
  // String data = "Waiting for data...";

  @override
  void initState() {
    super.initState();
    // _startListening();
  }

  // _startListening() {
  //   _eventChannel.receiveBroadcastStream().listen(
  //     (event) {
  //       setState(() {
  //         _status = event.toString();
  //       });
  //     },
  //     onError: (error) {
  //       setState(() {
  //         _status = "Error: $error";
  //       });
  //     },
  //   );
  // }

  Future<void> _startCamera() async {
    try {
      await _channel.invokeMethod("startCamera");
    } on PlatformException catch (e) {
      setState(() {
        _status = "Failed to start camera: '${e.message}'.";
      });
    }
  }

  // @override
  // void dispose() {
  //   _subscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _startCamera,
                child: Text('Start Camera'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pick Image Channel

// class SignToAudioScreen extends StatefulWidget {
//   const SignToAudioScreen({super.key});

//   @override
//   State<SignToAudioScreen> createState() => _SignToAudioScreenState();
// }

// class _SignToAudioScreenState extends State<SignToAudioScreen> {
//   var imageUrl = "";
//   static const pickImageChannel = MethodChannel("pickImagePlatform");

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             TextButton(
//               onPressed: () async {
//                 try {
//                   final String result =
//                       await pickImageChannel.invokeMethod("pickImage");
//                   setState(() {
//                     imageUrl = result;
//                   });
//                 } on PlatformException catch (e) {
//                   debugPrint("Fail: ${e.message}");
//                 }
//               },
//               child: const Text("Pick Image"),
//             ),
//             imageUrl != ""
//                 ? SizedBox(
//                     width: 400,
//                     height: 400,
//                     child: MyImageView(imageUrl: imageUrl),
//                   )
//                 : Container()
//           ],
//         ),
//       ),
//     );
//   }
// }

// const myImageView = "myImageView";

// class MyImageView extends StatefulWidget {
//   final String imageUrl;

//   const MyImageView({
//     super.key,
//     required this.imageUrl,
//   });

//   @override
//   State<MyImageView> createState() => _MyImageViewState();
// }

// class _MyImageViewState extends State<MyImageView> {
//   final Map<String, dynamic> creationParams = <String, dynamic>{};
//   late Key _key;

//   @override
//   void initState() {
//     super.initState();
//     _key = UniqueKey();
//     creationParams["imageUrl"] = widget.imageUrl;
//   }

//   @override
//   void didUpdateWidget(covariant MyImageView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.imageUrl != widget.imageUrl) {
//       creationParams["imageUrl"] = widget.imageUrl;
//       _key = UniqueKey();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Platform.isAndroid
//         ? AndroidView(
//             key: _key,
//             viewType: myImageView,
//             layoutDirection: TextDirection.ltr,
//             creationParams: creationParams,
//             creationParamsCodec: const StandardMessageCodec(),
//           )
//         : UiKitView(
//             key: _key,
//             viewType: myImageView,
//             layoutDirection: TextDirection.ltr,
//             creationParams: creationParams,
//             creationParamsCodec: const StandardMessageCodec(),
//           );
//   }
// }
