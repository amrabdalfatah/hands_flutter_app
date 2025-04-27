import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = "550ce048c6c6478a9cce2a051fb15826";
const String channelName = "testChannel";

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  // bool _isJoined = false;
  bool localUserJoined = false;
  int? remoteId;
  late RtcEngine _engine;
  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: appId));

    // await _engine!.enableVideo();
    // await _engine!.startPreview();

    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (conn, elapsed) {
        print("Joined channel: conn.channelId");
        setState(() {
          localUserJoined = true;
        });
      },
      onUserJoined: (conn, remoteUid, elapsed) {
        print("/////////////////////////////");
        print("/////////////////////////////");
        print("/////////////////////////////");
        print("/////////////////////////////");
        print("Remote user joined:$remoteUid");
        setState(() {
          remoteId = remoteUid;
        });
      },
      onUserOffline: (conn, remote, rea) {
        setState(() {
          remoteId = null;
        });
      },
      onTokenPrivilegeWillExpire: (con, tok) {},
    ));
    // await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: "anytoken2",
      channelId: channelName,
      uid: 1,
      options: ChannelMediaOptions(),
    );
  }

  @override
  void dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // startCall();
    // startCallAndListen();
    initAgora();
  }

  // Future<void> startCallAndListen() async {
  //   await startCall();

  //   agoraEngine.registerEventHandler(
  //     RtcEngineEventHandler(
  //       onJoinChannelSuccess: (connection, elapsed) {
  //         setState(() {
  //           _isJoined = true;
  //         });
  //       },
  //       onLeaveChannel: (connection, stats) {
  //         setState(() {
  //           _isJoined = false;
  //         });
  //       },
  //     ),
  //   );
  // }

  // Future<void> endCall() async {
  //   await agoraEngine.leaveChannel();
  //   Get.back();
  // }

  // @override
  // void dispose() {
  //   agoraEngine.leaveChannel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: remoteId),
                connection: const RtcConnection(channelId: channelName),
              ),
            ),
          ),
          // AgoraVideoView(
          //   controller: VideoViewController(
          //     rtcEngine: _engine,
          //     canvas: const VideoCanvas(uid: 0),
          //   ),
          // ),
        ],
      ),
      // body: Stack(
      //   children: [
      //     Center(
      //       child: _isJoined
      //           ? AgoraVideoView(
      //               controller: VideoViewController(
      //                 rtcEngine: agoraEngine,
      //                 canvas: const VideoCanvas(uid: 0),
      //               ),
      //             )
      //           : const Text(
      //               'Joining Channel...',
      //               style: TextStyle(color: Colors.white),
      //             ),
      //     ),
      //     Positioned(
      //       bottom: 40,
      //       left: MediaQuery.of(context).size.width * 0.3,
      //       right: MediaQuery.of(context).size.width * 0.3,
      //       child: FloatingActionButton(
      //         backgroundColor: Colors.red,
      //         onPressed: endCall,
      //         child: const Icon(Icons.call_end, color: Colors.white),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
