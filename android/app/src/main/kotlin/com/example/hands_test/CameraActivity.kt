package com.example.hands_test

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import android.widget.TextView
import android.media.MediaPlayer
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


class CameraActivity : ComponentActivity(), GestureRecognizerHelper.GestureRecognizerListener {

    private lateinit var cameraExecutor: ExecutorService
    private var gestureRecognizerHelper: GestureRecognizerHelper? = null
    private var imageAnalyzer: ImageAnalysis? = null
    private lateinit var predictionTextView: TextView
    private var mediaPlayer: MediaPlayer? = null

    private lateinit var overlayView: OverlayView
    private lateinit var tflite: Interpreter

    private val cameraPermissionCode = 101
    private val TAG = "CameraActivity"

    private val signLanguageClasses = listOf(
        "الزائدة الدودية",
        "العمود الفقري",
        "سيئ",
        "الصدر",
        "أصلح",
        "طعام",
        "مرحبا",
        "لا",
        "عذرا",
        "جهاز التنفس",
        "الهيكل العظمي",
        "تحدث",
        "شكرا",
        "القصبة الهوائية",
        "نعم",
        "الوخز بالإبر",
        "عمر",
        "فاتورة",
        "ضغط الدم",
        "برجر",
        "كعكة",
        "كبسولة",
        "دجاج",
        "زكام",
        "يبكي",
        "الجهاز الهضمي",
        "طبيب",
        "قطارة",
        "أدوية",
        "بيض",
        "متحمس",
        "جيد",
        "حظا سعيدا",
        "سعيد",
        "صحي",
        "يسمع",
        "القلب",
        "جائع",
        "احبك",
        "المناعة",
        "يستنشق",
        "تلقيح",
        "الكبد",
        "دواء",
        "ميكروب",
        "منغولي",
        "عضلة",
        "حسنا",
        "البنكرياس",
        "صيدلية",
        "البلعوم",
        "إعاقة جسدية",
        "فحص جسدي",
        "تلقيح النباتات",
        "نبض",
        "فحص البصر",
        "صمت",
        "جمجمة",
        "سماعة الطبيب",
        "فيروس",
        "ضعف بصري",
        "استيقاظ",
        "أسوأ",
        "جرح",
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
        mediaPlayer?.release()
        mediaPlayer = null
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

    private var isPredictionDelayed = false

    private fun runModel(landmarks: List<NormalizedLandmark>) {
        if (isPredictionDelayed) return

        val input = preprocessLandmarks(landmarks)
        val output = Array(1) { FloatArray(signLanguageClasses.size) }

        tflite.run(input, output)

        val predictionIndex = output[0].indices.maxByOrNull { output[0][it] } ?: -1
        val predictionLabel = signLanguageClasses.getOrNull(predictionIndex)

        predictionLabel?.let { label ->
            isPredictionDelayed = true

            Handler(Looper.getMainLooper()).postDelayed({
                predictionTextView.text = "Prediction: $label"
                playAudioForPrediction(label)
                isPredictionDelayed = false
            }, 2000L) // 2 second delay
        }
    }

    private fun playAudioForPrediction(prediction: String) {
        // Stop current audio if playing
        mediaPlayer?.release()

        val resourceName = when (prediction) {
            "الزائدة الدودية" -> "alzaeda_aldwdia"
            "العمود الفقري" -> "alamod_alfakry"
            "سيئ" -> "seea"
            "الصدر" -> "alsadr"
            "أصلح" -> "aslah"
            "طعام" -> "taam"
            "مرحبا" -> "marhba"
            "عذرا" -> "ozra"
            "جهاز التنفس" -> "gehaz_tanfas"
            "الهيكل العظمي" -> "alhaykal_alazmy"
            "تحدث" -> "tahdath"
            "شكرا" -> "shokran"
            "القصبة الهوائية" -> "alkasba_alhoaea"
            "نعم" -> "naam"
            "الوخز بالإبر" -> "alwakhz_ebar"
            "عمر" -> "omr"
            "فاتورة" -> "fatora"
            "ضغط الدم" -> "daght_dam"
            "برجر" -> "borger"
            "كعكة" -> "kaka"
            "كبسولة" -> "kapsola"
            "دجاج" -> "dagag"
            "زكام" -> "zokam"
            "يبكي" -> "yabki"
            "الجهاز الهضمي" -> "algehaz_alhadmy"
            "طبيب" -> "tabeb"
            "قطارة" -> "katara"
            "أدوية" -> "adwia"
            "متحمس" -> "motahmas"
            "جيد" -> "gaed"
            "حظا سعيدا" -> "haza_saed"
            "سعيد" -> "saied"
            "صحي" -> "sehy"
            "يسمع" -> "yasmaa"
            "القلب" -> "alkalb"
            "جائع" -> "gaea"
            "احبك" -> "ahbak"
            "المناعة" -> "almanaa"
            "يستنشق" -> "yastanshak"
            "تلقيح" -> "talkeeh"
            "الكبد" -> "alkabd"
            "دواء" -> "dwaa"
            "ميكروب" -> "microb"
            "منغولي" -> "mangholi"
            "عضلة" -> "adla"
            "حسنا" -> "hasna"
            "البنكرياس" -> "albenkrias"
            "صيدلية" -> "siedlia"
            "البلعوم" -> "albalaom"
            "إعاقة جسدية" -> "eaqa_gasdia"
            "فحص جسدي" -> "fahs_gasd"
            "تلقيح النباتات" -> "talkeeh_alnabatat"
            "نبض" -> "nabd"
            "فحص البصر" -> "fahs_basr"
            "صمت" -> "samt"
            "جمجمة" -> "gomgma"
            "سماعة الطبيب" -> "samaa_eltabeb"
            "فيروس" -> "virous"
            "ضعف بصري" -> "daaf_basry"
            "استيقاظ" -> "estekaz"
            "أسوأ" -> "aswaa"
            "جرح" -> "garah"
            else -> null
        }

        resourceName?.let {
            val resId = resources.getIdentifier(it, "raw", packageName)
            if (resId != 0) {
                mediaPlayer = MediaPlayer.create(this, resId)
                mediaPlayer?.start()
            }
        }
    }
}
