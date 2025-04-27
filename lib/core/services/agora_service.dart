import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = "550ce048c6c6478a9cce2a051fb15826";
const String channelName = "testChannel";
const String token = 'null';

late RtcEngine agoraEngine;

Future<void> initAgora() async {
  agoraEngine = createAgoraRtcEngine();
  await agoraEngine.initialize(
    const RtcEngineContext(
      appId: appId,
    ),
  );
}

Future<void> startCall() async {
  await [Permission.camera, Permission.microphone].request();

  await agoraEngine.joinChannel(
    token: token,
    channelId: channelName,
    uid: 0,
    options: const ChannelMediaOptions(),
  );
}
