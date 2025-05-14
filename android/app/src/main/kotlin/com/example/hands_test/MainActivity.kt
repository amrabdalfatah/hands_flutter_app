package com.example.hands_test

import androidx.annotation.NonNull
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    // private val CHANNEL_EVENT = "signLanguageToAudio"
    private val CAMERA_CHANNEL = "cameraControl"


    // private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // EventChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL_EVENT).setStreamHandler(
        //     object : EventChannel.StreamHandler {
        //         override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        //             eventSink = events
        //             eventSink?.success("Event channel is ready")
        //         }

        //         override fun onCancel(arguments: Any?) {
        //             eventSink = null
        //         }
        //     }
        // )
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CAMERA_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startCamera") {
                val intent = Intent(this, CameraActivity::class.java)
                startActivity(intent)
                result.success("Camera activity started")
            } else {
                result.notImplemented()
            }
        }
    }

    // private fun startCamera() {
    //     Handler(Looper.getMainLooper()).postDelayed({
    //         // Start camera logic
    //         eventSink?.success("Camera started")
    //     }, 1500)
    // }
    
}