import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hands_test/features/student/controller/student_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call_screen.dart';

const String appId = "550ce048c6c6478a9cce2a051fb15826";
const String channelName = "testChannel";

class EmergencySessionScreen extends StatefulWidget {
  const EmergencySessionScreen({super.key});

  @override
  State<EmergencySessionScreen> createState() => _EmergencySessionScreenState();
}

class _EmergencySessionScreenState extends State<EmergencySessionScreen> {
  bool localUserJoined = false;
  int? remoteId;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    // initAgora();
  }

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
        print("Remote user joined:remoteUid");
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
      token: "anytoken",
      channelId: channelName,
      uid: 0,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Emergency Session"),
        backgroundColor: Colors.white, // this is a basic comment
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Interpreter')
            .where('active', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final interpreters = snapshot.data!.docs;
          return interpreters.isEmpty
              ? const Center(
                  child: Text("No Interpreter available now"),
                )
              : ListView.builder(
                  itemCount: interpreters.length,
                  itemBuilder: (context, index) {
                    var user = interpreters[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['uid']),
                      onTap: () {
                        Get.to(() => const CallScreen());
                      },
                    );
                  },
                );
        },
      ),
      // body: Stack(
      //   children: [
      //     AgoraVideoView(
      //       controller: VideoViewController(
      //         rtcEngine: _engine,
      //         canvas: const VideoCanvas(uid: 0),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
