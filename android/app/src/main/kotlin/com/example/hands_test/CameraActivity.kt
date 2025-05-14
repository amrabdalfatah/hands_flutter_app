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
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
import com.google.mediapipe.tasks.vision.handlandmarker.HandLandmarkerResult
import com.example.hands_test.GestureRecognizerHelper
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import android.widget.TextView

class CameraActivity : ComponentActivity(), GestureRecognizerHelper.GestureRecognizerListener {

    private lateinit var cameraExecutor: ExecutorService
    private var gestureRecognizerHelper: GestureRecognizerHelper? = null
    private var imageAnalyzer: ImageAnalysis? = null
    private lateinit var predictionTextView: TextView

    private lateinit var overlayView: OverlayView
    private lateinit var tflite: Interpreter

    private val cameraPermissionCode = 101
    private val TAG = "CameraActivity"

    private val signLanguageClasses = listOf(
        "الزائدة الدودية", "العمود الفقري", "الصدر", "جهاز التنفس", "الهيكل العظمي",
        "القصبة الهوائية", "الوخز بالإبر", "ضغط الدم", "كبسولة", "زكام", "الجهاز الهضمي",
        "يشرب", "قطارة", "أدوية", "صحي", "يسمع", "القلب", "المناعة", "يستنشق", "تلقيح",
        "الكبد", "دواء", "ميكروب", "منغولي", "عضلة", "البنكرياس", "صيدلية", "البلعوم",
        "إعاقة جسدية", "فحص جسدي", "تلقيح النباتات", "نبض", "فحص البصر", "صمت",
        "جمجمة", "نوم", "سماعة الطبيب", "فيروس", "ضعف بصري", "استيقاظ", "جرح"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (allPermissionsGranted()) {
            setupCamera()
        } else {
            ActivityCompat.requestPermissions(
                this, arrayOf(Manifest.permission.CAMERA), cameraPermissionCode
            )
        }
        tflite = Interpreter(loadModelFile())
    }

    private fun setupCamera() {

        setContentView(R.layout.activity_camera)
        predictionTextView = findViewById(R.id.predictionText)

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

        runOnUiThread {
            overlayView.setResults(
                handResult,
                resultBundle.inputImageHeight,
                resultBundle.inputImageWidth,
                RunningMode.LIVE_STREAM,
            )
        }

        handResult?.landmarks()?.firstOrNull()?.let { landmarks -> 
            runModel(landmarks)
        }
    }

    override fun onError(error: String, errorCode: Int) {
        Log.e(TAG, "GestureRecognizer error: $error")
        runOnUiThread {
            Toast.makeText(this, "Error: $error", Toast.LENGTH_SHORT).show()
        }
    }

    // === TFLite model ===

    private fun loadModelFile(): MappedByteBuffer {
        val fileDescriptor = assets.openFd("sign_lang.tflite")
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }

    private fun preprocessLandmarks(landmarks: List<NormalizedLandmark>): ByteBuffer {
        val landmarkCount = 42  // model expects 42 landmarks
        val inputBuffer = ByteBuffer.allocateDirect(landmarkCount * 3 * 4)
        inputBuffer.order(ByteOrder.nativeOrder())
        for (i in 0 until landmarkCount) {
            if (i < landmarks.size) {
                val landmark = landmarks[i]
                inputBuffer.putFloat(landmark.x())
                inputBuffer.putFloat(landmark.y())
                inputBuffer.putFloat(landmark.z())
            } else {
                // pad with zeros
                inputBuffer.putFloat(0f)
                inputBuffer.putFloat(0f)
                inputBuffer.putFloat(0f)
            }
        }

        inputBuffer.rewind()
        return inputBuffer
        // for (landmark in landmarks) {
        //     inputBuffer.putFloat(landmark.x())
        //     inputBuffer.putFloat(landmark.y())
        //     inputBuffer.putFloat(landmark.z())
        // }
        // inputBuffer.rewind()
        // return inputBuffer
    }

    private fun runModel(landmarks: List<NormalizedLandmark>) {
        val input = preprocessLandmarks(landmarks)
        val output = Array(1) { FloatArray(signLanguageClasses.size) }

        tflite.run(input, output)

        val predictionIndex = output[0].indices.maxByOrNull { output[0][it] } ?: -1
        val predictionLabel = signLanguageClasses.getOrNull(predictionIndex)

        predictionLabel?.let {
            runOnUiThread {
                // val toast = Toast.makeText(this, "Predicted: $it", Toast.LENGTH_SHORT)
                // toast.show()
                // toast.cancel()
                predictionTextView.text = "Prediction: $it"
            }
        }
    }
}
