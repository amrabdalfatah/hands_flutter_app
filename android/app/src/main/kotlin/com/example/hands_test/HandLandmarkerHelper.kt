//package com.example.hands_test
//
//import android.content.Context
//import android.graphics.Bitmap
//import android.graphics.BitmapFactory
//import android.graphics.Matrix
//import android.media.Image
//import android.os.SystemClock
//import android.util.Log
//import androidx.annotation.VisibleForTesting
//import androidx.camera.core.ImageProxy
//import com.google.mediapipe.framework.image.BitmapImageBuilder
//import com.google.mediapipe.framework.image.MPImage
//import com.google.mediapipe.tasks.core.BaseOptions
//import com.google.mediapipe.tasks.core.Delegate
//import com.google.mediapipe.tasks.vision.core.RunningMode
//import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarker
//import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult
//import java.nio.ByteBuffer
//
//class HandLandmarkerHelper(
//    var minHandDetectionConfidence: Float = DEFAULT_HAND_DETECTION_CONFIDENCE,
//    var minHandTrackingConfidence: Float = DEFAULT_HAND_TRACKING_CONFIDENCE,
//    var minHandPresenceConfidence: Float = DEFAULT_HAND_PRESENCE_CONFIDENCE,
//    var maxNumHands: Int = DEFAULT_NUM_HANDS,
//    var currentDelegate: Int = DELEGATE_CPU,
//    var runningMode: RunningMode = RunningMode.LIVE_STREAM,
//    val context: Context,
//    val handLandmarkerHelperListener: LandmarkerListener? = null
//) {
//    private var handLandmarker: HandLandmarker? = null
//    private var lastProcessedTime = 0L
//    private val MIN_FRAME_INTERVAL_MS = 100 // 10 FPS
//
//    init {
//        setupHandLandmarker()
//    }
//
//    fun clearHandLandmarker() {
//        handLandmarker?.close()
//        handLandmarker = null
//    }
//
//    fun setupHandLandmarker() {
//        try {
//            val baseOptions = BaseOptions.builder()
//                .setModelAssetPath(MP_HAND_LANDMARKER_TASK)
//                .setDelegate(if (currentDelegate == DELEGATE_GPU) Delegate.GPU else Delegate.CPU)
//                .build()
//
//            val options = HandLandmarker.HandLandmarkerOptions.builder()
//                .setBaseOptions(baseOptions)
//                .setMinHandDetectionConfidence(minHandDetectionConfidence)
//                .setMinTrackingConfidence(minHandTrackingConfidence)
//                .setMinHandPresenceConfidence(minHandPresenceConfidence)
//                .setNumHands(maxNumHands)
//                .setRunningMode(runningMode)
//                .setResultListener(this::returnLivestreamResult)
//                .setErrorListener(this::returnLivestreamError)
//                .build()
//
//            handLandmarker = HandLandmarker.createFromOptions(context, options)
//            Log.d(TAG, "HandLandmarker initialized successfully")
//        } catch (e: Exception) {
//            Log.e(TAG, "HandLandmarker initialization failed", e)
//            handLandmarkerHelperListener?.onError(
//                "HandLandmarker initialization failed: ${e.message}",
//                if (e is RuntimeException) GPU_ERROR else OTHER_ERROR
//            )
//        }
//    }
//
//    fun processCameraFrame(imageProxy: ImageProxy, isFrontCamera: Boolean = false) {
//        try {
//            if (handLandmarker == null) {
//                Log.w(TAG, "HandLandmarker not initialized")
//                return
//            }
//
//            // Convert to ARGB_8888 format for better compatibility
//            val bitmap = Bitmap.createBitmap(
//                imageProxy.width,
//                imageProxy.height,
//                Bitmap.Config.ARGB_8888
//            )
//            imageProxy.use { proxy ->
//                bitmap.copyPixelsFromBuffer(proxy.planes[0].buffer)
//            }
//
//            // Apply rotation if needed
//            val matrix = Matrix().apply {
//                postRotate(imageProxy.imageInfo.rotationDegrees.toFloat())
//            }
//
//            val rotatedBitmap = Bitmap.createBitmap(
//                bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true
//            )
//
//            // Log bitmap dimensions for debugging
//            Log.d(TAG, "Processing bitmap: ${rotatedBitmap.width}x${rotatedBitmap.height}")
//
//            val mpImage = BitmapImageBuilder(rotatedBitmap).build()
//            detectAsync(mpImage, SystemClock.uptimeMillis())
//        } catch (e: Exception) {
//            Log.e(TAG, "Frame processing error", e)
//        } finally {
//            imageProxy.close()
//        }
//    }
//
//    private fun ImageProxy.toBitmap(): Bitmap {
//        val plane = planes[0]
//        val buffer = plane.buffer
//        val bytes = ByteArray(buffer.remaining())
//        buffer.get(bytes)
//        return BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
//    }
//
//    @VisibleForTesting
//    fun detectAsync(mpImage: MPImage, frameTime: Long) {
//        handLandmarker?.detectAsync(mpImage, frameTime)
//    }
//
//    private fun returnLivestreamResult(result: HandLandmarkerResult, input: MPImage) {
//        Log.d(TAG, "Received results with ${result.landmarks().size} hands")
//
//        if (result.landmarks().isNotEmpty()) {
//            result.landmarks().forEachIndexed { handIndex, landmarks ->
////                Log.d(TAG, "Hand $handIndex has ${landmarks.landmarkList().size} landmarks")
////                landmarks.landmarkList().take(5).forEachIndexed { i, landmark ->
////                    Log.d(TAG, "Landmark $i: (${landmark.x()}, ${landmark.y()}, ${landmark.z()})")
////                }
//            }
//        }
//
//        val inferenceTime = SystemClock.uptimeMillis() - result.timestampMs()
//        handLandmarkerHelperListener?.onResults(
//            ResultBundle(listOf(result), inferenceTime, input.height, input.width)
//        )
//    }
//
//    private fun returnLivestreamError(error: RuntimeException) {
//        Log.e(TAG, "HandLandmarker error", error)
//        handLandmarkerHelperListener?.onError(
//            error.message ?: "Unknown detection error"
//        )
//    }
//
//    companion object {
//        const val TAG = "HandLandmarkerHelper"
//        private const val MP_HAND_LANDMARKER_TASK = "hand_landmarker.task"
//        const val DELEGATE_CPU = 0
//        const val DELEGATE_GPU = 1
//        const val DEFAULT_HAND_DETECTION_CONFIDENCE = 0.5F
//        const val DEFAULT_HAND_TRACKING_CONFIDENCE = 0.5F
//        const val DEFAULT_HAND_PRESENCE_CONFIDENCE = 0.5F
//        const val DEFAULT_NUM_HANDS = 1
//        const val OTHER_ERROR = 0
//        const val GPU_ERROR = 1
//    }
//
//    data class ResultBundle(
//        val results: List<HandLandmarkerResult>,
//        val inferenceTime: Long,
//        val inputImageHeight: Int,
//        val inputImageWidth: Int,
//    )
//
//    interface LandmarkerListener {
//        fun onError(error: String, errorCode: Int = OTHER_ERROR)
//        fun onResults(resultBundle: ResultBundle)
//    }
//}