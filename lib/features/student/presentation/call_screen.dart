import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:hands_test/core/services/agora_service.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isJoined = false;
  @override
  void initState() {
    super.initState();
    // startCall();
    startCallAndListen();
  }

  Future<void> startCallAndListen() async {
    await startCall();

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onLeaveChannel: (connection, stats) {
          setState(() {
            _isJoined = false;
          });
        },
      ),
    );
  }

  Future<void> endCall() async {
    await agoraEngine.leaveChannel();
    Get.back();
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isJoined
                ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agoraEngine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  )
                : const Text(
                    'Joining Channel...',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: endCall,
              child: const Icon(Icons.call_end, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
