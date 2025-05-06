package com.example.hands_test

import android.content.Context
import android.media.MediaPlayer
//import org.tensorflow.lite.Interpreter
//import org.tensorflow.lite.support.common.FileUtil
//import org.tensorflow.lite.support.image.TensorImage
import android.graphics.Bitmap
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.common.FileUtil
import org.tensorflow.lite.support.image.TensorImage
//import org.tensorflow.lite.support.label.Category
import java.nio.MappedByteBuffer

class TFLiteModel(context: Context) {
    private var interpreter: Interpreter
    private var mediaPlayer: MediaPlayer? = null
    private val labelMap = mapOf(
        0 to "",1 to "",2 to "",3 to "",4 to "",5 to "",6 to "",7 to "",8 to "",9 to "",10 to "",
        11 to "",12 to "",13 to "",14 to "عذرا", 15 to "",16 to "طعام",17 to "",18 to "",
        19 to "مرحبا",20 to "مساعده",21 to "منزل",22 to "انا",23 to "احبك",24 to "",25 to "",26 to "",
        27 to "",28 to "",29 to "لا",30 to "",31 to "",32 to "لو سمحت",33 to "",34 to "",35 to "",
        36 to "",37 to "شكرا",38 to "",39 to "",40 to "",
        41 to "",42 to "",43 to "نعم",44 to ""
    )
    private val audioMap = mapOf(
        "انا" to R.raw.ana,  // Create raw audio files for each gesture
        "لو سمحت" to R.raw.exec,
        "عذرا" to R.raw.execuse,
        "طعام" to R.raw.food,
        "مرحبا" to R.raw.hello,
        "مساعده" to R.raw.help,
        "منزل" to R.raw.house,
        "لا" to R.raw.no,
        "شكرا" to R.raw.thanks,
        "نعم" to R.raw.yes
    )

    init {
        // Load the TFLite model from assets
        val model: MappedByteBuffer = FileUtil.loadMappedFile(context, "model.tflite")
        interpreter = Interpreter(model)
    }

    fun classifyGesture(bitmap: Bitmap): String {
        // Convert bitmap to TensorImage
        val tensorImage = TensorImage.fromBitmap(bitmap)

        // Run inference
        val output = Array(1) { FloatArray(labelMap.size) }
        interpreter.run(tensorImage.buffer, output)

        // Get top result
        val maxIndex = output[0].indices.maxByOrNull { output[0][it] } ?: -1
        return labelMap[maxIndex] ?: "Unknown"
    }

    fun playGestureAudio(label: String, context: Context) {
        mediaPlayer?.release() // Release previous player

        audioMap[label]?.let { resId ->
            mediaPlayer = MediaPlayer.create(context, resId).apply {
                setOnCompletionListener { mp -> mp.release() }
                start()
            }
        }
    }

    fun close() {
        mediaPlayer?.release()
        interpreter.close()
    }
}