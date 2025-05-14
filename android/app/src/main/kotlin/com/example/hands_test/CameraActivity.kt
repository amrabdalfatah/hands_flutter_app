package com.example.hands_test

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult
import com.example.hands_test.GestureRecognizerHelper
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class CameraActivity : ComponentActivity(), GestureRecognizerHelper.GestureRecognizerListener {

    private lateinit var cameraExecutor: ExecutorService
    private var gestureRecognizerHelper: GestureRecognizerHelper? = null
    private var imageAnalyzer: ImageAnalysis? = null

    private lateinit var overlayView: OverlayView

    private val cameraPermissionCode = 101
    private val TAG = "CameraActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (allPermissionsGranted()) {
            setupCamera()
        } else {
            ActivityCompat.requestPermissions(
                this, arrayOf(Manifest.permission.CAMERA), cameraPermissionCode
            )
        }
    }

    private fun setupCamera() {

        setContentView(R.layout.activity_camera)

        val previewView = findViewById<androidx.camera.view.PreviewView>(R.id.previewView)
        overlayView = findViewById<OverlayView>(R.id.overlay)

        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraExecutor = Executors.newSingleThreadExecutor()

        cameraProviderFuture.addListener({
            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()

            val preview = Preview.Builder().build().also {
                it.setSurfaceProvider(previewView.surfaceProvider)
            }

            imageAnalyzer = ImageAnalysis.Builder()
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                .build()
                .also {
                    it.setAnalyzer(cameraExecutor) { imageProxy ->
                        recognizeHandGesture(imageProxy)
                    }
                }

            val cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA

            try {
                cameraProvider.unbindAll()
                cameraProvider.bindToLifecycle(
                    this, cameraSelector, preview, imageAnalyzer
                )
            } catch (exc: Exception) {
                Log.e(TAG, "Use case binding failed", exc)
            }

            setupGestureRecognizer()
        }, ContextCompat.getMainExecutor(this))
    }

    private fun setupGestureRecognizer() {
        gestureRecognizerHelper = GestureRecognizerHelper(
            context = this,
            runningMode = RunningMode.LIVE_STREAM,
            gestureRecognizerListener = this
        )
    }

    private fun recognizeHandGesture(imageProxy: ImageProxy) {
        Log.d("Analyzer", "Frame received")
        gestureRecognizerHelper?.recognizeLiveStream(imageProxy)
    }

    override fun onDestroy() {
        super.onDestroy()
        cameraExecutor.shutdown()
        gestureRecognizerHelper?.clearGestureRecognizer()
    }

    private fun allPermissionsGranted(): Boolean {
        return ContextCompat.checkSelfPermission(
            this, Manifest.permission.CAMERA
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<String>, grantResults: IntArray
    ) {
        if (requestCode == cameraPermissionCode) {
            if (allPermissionsGranted()) {
                setupCamera()
            } else {
                Toast.makeText(this, "Camera permission is required", Toast.LENGTH_SHORT).show()
                finish()
            }
        }
    }

    // === GestureRecognizerListener methods ===

    override fun onResults(resultBundle: GestureRecognizerHelper.ResultBundle) {
        val handResult = resultBundle.results.firstOrNull()

        handResult?.gestures()?.firstOrNull()?.let {
            val category = it.firstOrNull()?.categoryName()
            runOnUiThread {
                Toast.makeText(this, "Gesture: $category", Toast.LENGTH_SHORT).show()
            }
        }
        val gestures = resultBundle.results.firstOrNull()?.gestures()
        // gestures?.firstOrNull()?.let {
        //     val category = it.firstOrNull()?.categoryName()
        //     Log.i(TAG, "Detected gesture: $category")
        //     runOnUiThread {
        //         Toast.makeText(this, "Gesture: $category", Toast.LENGTH_SHORT).show()
        //     }
        // }
        runOnUiThread {
            // overlayView.setResults(
            //     handResult,
            //     resultBundle.inputImageWidth,
            //     resultBundle.inputImageHeight,
            // )
            overlayView.setResults(
                handResult,
                resultBundle.inputImageHeight,
                resultBundle.inputImageWidth,
                RunningMode.LIVE_STREAM,
            )
        }
    }

    override fun onError(error: String, errorCode: Int) {
        Log.e(TAG, "GestureRecognizer error: $error")
        runOnUiThread {
            Toast.makeText(this, "Error: $error", Toast.LENGTH_SHORT).show()
        }
    }
}
