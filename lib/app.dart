import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hands_test/core/utils/constants.dart';
import 'package:hands_test/core/utils/utils.dart';
import 'package:hands_test/features/student/presentation/call_screen.dart';

import 'core/helper/binding.dart';
import 'features/authentication/presentation/login_screen.dart';
import 'features/interpreter/presentation/interpreter_home_view.dart';
import 'features/student/presentation/home_screen.dart';

import 'package:permission_handler/permission_handler.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    controller.setUserId();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      home: const HomePage(),
      // home: controller.mainScreen,
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _channelController = TextEditingController();
  bool _validateError = false;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/video_call.png', height: 120),
              const SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText:
                      _validateError ? 'Channel name is mandatory' : null,
                  border: const UnderlineInputBorder(),
                  hintText: 'Channel name',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _onJoin(),
                      child: const Text('JOIN'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });

    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }
}
