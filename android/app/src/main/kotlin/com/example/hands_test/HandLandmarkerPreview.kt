//package com.example.hands_test
//
//import android.content.Context
//import android.graphics.Canvas
//import android.graphics.Color
//import android.graphics.Paint
//import android.util.Log
//import android.view.View
//import android.widget.FrameLayout
//import androidx.camera.core.CameraSelector
//import androidx.camera.core.ImageAnalysis
//import androidx.camera.core.Preview
//import androidx.camera.lifecycle.ProcessCameraProvider
//import androidx.camera.view.PreviewView
//import androidx.core.content.ContextCompat
//import androidx.lifecycle.LifecycleOwner
//import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
//import com.google.mediapipe.tasks.vision.core.RunningMode
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.plugin.platform.PlatformView
//import java.util.concurrent.Executors
//
//class HandLandmarkerPreview(
//    private val context: Context,
//    private val viewId: Int,
//    private val activity: FlutterFragmentActivity
//) : PlatformView, HandLandmarkerHelper.LandmarkerListener {
//
//    private val TAG = "HandLandmarkerPreview"
//    private val previewView = PreviewView(context)
//    private val cameraExecutor = Executors.newSingleThreadExecutor()
//    private lateinit var handLandmarkerHelper: HandLandmarkerHelper
//    private var isFrontCamera = false
//    private var container: FrameLayout? = null
//    private val overlayView = LandmarkOverlayView(context)
//
//    init {
//        setupHandLandmarker()
//        startCamera()
//    }
//
//    private fun setupHandLandmarker() {
//        handLandmarkerHelper = HandLandmarkerHelper(
//            minHandDetectionConfidence = 0.7f,
//            minHandTrackingConfidence = 0.5f,
//            minHandPresenceConfidence = 0.5f,
//            maxNumHands = 2,
//            currentDelegate = HandLandmarkerHelper.DELEGATE_GPU,
//            runningMode = RunningMode.LIVE_STREAM,
//            context = context,
//            handLandmarkerHelperListener = this
//        )
//    }
//
//    fun startCamera() {
//        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
//
//        cameraProviderFuture.addListener({
//            try {
//                val cameraProvider = cameraProviderFuture.get()
//                cameraProvider.unbindAll()
//
//                val preview = Preview.Builder()
//                    .setTargetRotation(previewView.display.rotation)
//                    .build()
//                    .also { it.setSurfaceProvider(previewView.surfaceProvider) }
//
//                // Use back camera by default for better reliability
//                val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA
//
//                // Create image analysis use case
//                val imageAnalysis = ImageAnalysis.Builder()
//                    .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
//                    .build()
//                    .also {
//                        it.setAnalyzer(cameraExecutor) { imageProxy ->
//                            handLandmarkerHelper.processCameraFrame(imageProxy, isFrontCamera = false)
//                        }
//                    }
//
//                cameraProvider.bindToLifecycle(
//                    activity as LifecycleOwner,
//                    cameraSelector,
//                    preview,
//                    imageAnalysis  // Add image analysis to pipeline
//                )
//
//                Log.d(TAG, "Camera started with analysis use case")
//            } catch (exc: Exception) {
//                Log.e(TAG, "Camera binding failed", exc)
//                onError("Camera error: ${exc.localizedMessage}")
//            }
//        }, ContextCompat.getMainExecutor(context))
//    }
//
//    override fun getView(): View {
//        if (container == null) {
//            container = FrameLayout(context).apply {
//                layoutParams = FrameLayout.LayoutParams(
//                    FrameLayout.LayoutParams.MATCH_PARENT,
//                    FrameLayout.LayoutParams.MATCH_PARENT
//                )
//                addView(previewView)
//                addView(overlayView)
//            }
//        }
//        return container!!
//    }
//
//    override fun dispose() {
//        try {
//            handLandmarkerHelper.clearHandLandmarker()
//            cameraExecutor.shutdown()
//            container?.removeAllViews()
//            container = null
//        } catch (e: Exception) {
//            Log.e(TAG, "Error during dispose", e)
//        }
//    }
//
//    override fun onResults(resultBundle: HandLandmarkerHelper.ResultBundle) {
//        val handCount = resultBundle.results.size
//        val inferenceTime = resultBundle.inferenceTime
//
//        activity.runOnUiThread {
//            if (handCount > 0) {
//                val allLandmarks = resultBundle.results.flatMap { it.landmarks().flatten() }
//                overlayView.updateLandmarks(allLandmarks)
//                sendDetectionUpdate(handCount, inferenceTime)
//            } else {
//                overlayView.updateLandmarks(emptyList())
//                sendDetectionUpdate(0, 0)
//            }
//        }
//    }
//
//    private fun sendDetectionUpdate(handCount: Int, inferenceTime: Long) {
//        activity.runOnUiThread {
//            try {
//                (activity as MainActivity).detectionChannel.invokeMethod(
//                    "updateDetectionStatus",
//                    mapOf(
//                        "handCount" to handCount,
//                        "inferenceTime" to inferenceTime
//                    )
//                )
//            } catch (e: Exception) {
//                Log.e(TAG, "Error sending detection update", e)
//            }
//        }
//    }
//
//    override fun onError(error: String, errorCode: Int) {
//        Log.e(TAG, "Error: $error (code: $errorCode)")
//    }
//
//    private class LandmarkOverlayView(context: Context) : View(context) {
//        private var landmarks: List<NormalizedLandmark> = emptyList()
//        private val landmarkPaint = Paint().apply {
//            color = Color.RED
//            strokeWidth = 12f
//            style = Paint.Style.FILL
//        }
//        private val connectionPaint = Paint().apply {
//            color = Color.GREEN
//            strokeWidth = 5f
//            style = Paint.Style.STROKE
//        }
//
//        // Hand connections (simplified)
//        private val handConnections = listOf(
//            Pair(0, 1), Pair(1, 2), Pair(2, 3), Pair(3, 4),    // Thumb
//            Pair(0, 5), Pair(5, 6), Pair(6, 7), Pair(7, 8),    // Index
//            Pair(0, 9), Pair(9, 10), Pair(10, 11), Pair(11, 12), // Middle
//            Pair(0, 13), Pair(13, 14), Pair(14, 15), Pair(15, 16), // Ring
//            Pair(0, 17), Pair(17, 18), Pair(18, 19), Pair(19, 20)  // Pinky
//        )
//
//        fun updateLandmarks(newLandmarks: List<NormalizedLandmark>) {
//            landmarks = newLandmarks
//            invalidate()
//        }
//
//        override fun onDraw(canvas: Canvas) {
//            super.onDraw(canvas)
//
//            // Draw connections first
//            for (connection in handConnections) {
//                if (landmarks.size > connection.second) {
//                    val start = landmarks[connection.first]
//                    val end = landmarks[connection.second]
//                    canvas.drawLine(
//                        start.x() * width,
//                        start.y() * height,
//                        end.x() * width,
//                        end.y() * height,
//                        connectionPaint
//                    )
//                }
//            }
//
//            // Then draw landmarks
//            landmarks.forEach { landmark ->
//                canvas.drawCircle(
//                    landmark.x() * width,
//                    landmark.y() * height,
//                    12f,
//                    landmarkPaint
//                )
//            }
//        }
//    }
//}