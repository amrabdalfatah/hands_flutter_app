import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await initializeAgora();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // made by
  runApp(const MyApp());
}
// 007eJxTYCg+4vFfn/vR/Pu9r6QMWa58Xdj1+o5I0369xhz1/VLBgrMUGMwNjBKTE00tkiwNE01STEyTLI3MDZOMTSyTkgzSTIwstCeqZjQEMjL8V3/LysgAgSA+B0NGYl5KsWNBAQMDAPW4IRA=

